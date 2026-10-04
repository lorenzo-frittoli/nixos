# Secrets

Managed with [sops-nix](https://github.com/Mic92/sops-nix). Encrypted files in
this directory are safe to commit.

## How decryption works

Each host decrypts using its **SSH ed25519 host key** (converted to an age
identity internally). `services.openssh.generateHostKeys = true` is set in
`modules/system/secrets`, so the key exists on every host. Secrets you want a
host to read must be encrypted to that host's age recipient.

## Bootstrap

1. **Your editing key** (already generated on this machine at
   `~/.config/sops/age/keys.txt`). Public key is in `.sops.yaml` as `&admin`.
   To recreate: `age-keygen -o ~/.config/sops/age/keys.txt`.

2. **Host recipients** — on each host after its first boot:

   ```bash
   sudo ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
   ```

   Add the printed `age1...` to `.sops.yaml` (`&calcolatore` / `&server`) and
   remove the matching `#` before it in the `creation_rules` list.

3. **Create / edit a secrets file**:

   ```bash
   sops secrets/calcolatore.yaml
   ```

   Add keys, save, and commit the encrypted file.

4. **Re-key existing files after changing recipients**:

   ```bash
   sops updatekeys secrets/calcolatore.yaml
   ```

## Wiring secrets into the config

Define the secret and reference its activation path. Examples:

```nix
# modules/hosts/<host>/configuration.nix
sops.secrets."user01/password".neededForUsers = true;
users.users.user01.hashedPasswordFile = config.sops.secrets."user01/password".path;

sops.secrets."gemini-api-key".owner = "frittata";
```

For API keys / env vars, render a file and source it (see `sops.templates`):

```nix
sops.secrets."gemini-api-key".owner = "frittata";
sops.templates."frittata-env".content = ''
  export GEMINI_API_KEY=${config.sops.placeholder."gemini-api-key"}
'';
# -> config.sops.templates."frittata-env".path, source it from programs.zsh
```

## Inventory of secret candidates in this config

| Candidate | Where | Suggested wiring |
|---|---|---|
| `server` `user01` password | `modules/hosts/server/configuration.nix` (`initialPassword = "qwer"`) | `hashedPasswordFile` |
| `frittata` password | `modules/hosts/calcolatore/configuration.nix` (`sudo` requires a password, but none is set) | `hashedPasswordFile` |
| `GEMINI_API_KEY` | `gemini-cli` (development attr) | `sops.templates` → zsh env |
| `pi-coding-agent` API key(s) | `pi-coding-agent` (development attr) | `sops.templates` → zsh env |
| GitHub token | `gh` (development attr) | `sops.templates` → `GH_TOKEN`/`GITHUB_TOKEN` |
| Future server service secrets | services you add to `server` | `sops.secrets` + `*File` options |

Not secrets (do not manage here): SSH **authorized** keys (public), the
host's own SSH host keys (generated locally), Wi-Fi passwords (NetworkManager
keyring), app session data (Telegram/Signal/Brave profiles).

The `hotspot` zsh script prompts for its password interactively; it is not
stored and does not need sops.
