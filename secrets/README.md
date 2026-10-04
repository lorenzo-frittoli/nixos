# Secrets

Managed with [sops-nix](https://github.com/Mic92/sops-nix). Encrypted files in
this directory are safe to commit.

## How decryption works

Each host decrypts using an **age key file** at `/var/lib/sops-nix/key.txt`
(configured in `modules/system/secrets`). This is a copy of your personal age
key, so the same key works on every host. (An alternative using per-host SSH
host keys is described at the bottom.)

## Bootstrap (do this before switching on a new host)

1. **Your editing key** already exists on this machine at
   `~/.config/sops/age/keys.txt`. Its public key is `&admin` in `.sops.yaml`.
   Back it up. To recreate it: `age-keygen -o ~/.config/sops/age/keys.txt`.

2. **Install the key on the host** (run with sudo):

   ```bash
   sudo install -d -m 700 /var/lib/sops-nix
   sudo install -m 600 ~/.config/sops/age/keys.txt /var/lib/sops-nix/key.txt
   ```

   On a *different* machine, copy the key over first, e.g.
   `scp ~/.config/sops/age/keys.txt host:/tmp/ && ssh host 'sudo install -d -m700 /var/lib/sops-nix && sudo install -m600 /tmp/keys.txt /var/lib/sops-nix/key.txt && rm /tmp/keys.txt'`.

   If this file is missing, `nixos-rebuild switch` fails at activation (build
   still succeeds).

3. **Edit secrets** (sops is in the development attr):

   ```bash
   sops secrets/calcolatore.yaml
   ```

   Fill in the values, save, and commit the encrypted file.

## Current secrets

`secrets/calcolatore.yaml`:

| Key | Consumed as | Wiring |
|---|---|---|
| `gh_token` | `GH_TOKEN` | `sops.templates."frittata-env"` → sourced by zsh |
| `deepseek_api_key` | `DEEPSEEK_API_KEY` | same |

The rendered env file is `/run/secrets/rendered/frittata-env`, owned by
`frittata`, and is sourced from `programs.zsh.interactiveShellInit` (defined in
`modules/hosts/calcolatore/configuration.nix`). `pi` picks up
`DEEPSEEK_API_KEY`, and `gh` picks up `GH_TOKEN`.

To add another secret:

```nix
sops.secrets."my_token".owner = "frittata";
# then reference ${config.sops.placeholder."my_token"} in a sops.templates content
```

For a secret needed during user creation (e.g. a password hash), use
`neededForUsers` and a `*File` option:

```nix
sops.secrets."user01/password".neededForUsers = true;
users.users.user01.hashedPasswordFile = config.sops.secrets."user01/password".path;
```

Generate a hash with: `mkpasswd -m sha-512` (from `pkgs.mkpasswd`).

## Inventory of remaining secret candidates

| Candidate | Where | Suggested wiring |
|---|---|---|
| `server` `user01` password | `modules/hosts/server/configuration.nix` (`initialPassword = "qwer"`) | `hashedPasswordFile` |
| `frittata` password | `modules/hosts/calcolatore/configuration.nix` (sudo requires a password, but none is set) | `hashedPasswordFile` |
| Future server service secrets | services you add to `server` | `sops.secrets` + the module's `*File` option |

Done already: `gh_token` (GitHub CLI) and `deepseek_api_key` (`pi`).

Not secrets (do not manage here): SSH **authorized** keys (public), the host's
own SSH host keys (generated locally), Wi-Fi passwords (NetworkManager
keyring), app session data (Telegram/Signal/Brave profiles). The `hotspot` zsh
script prompts for its password interactively and stores nothing.

## Alternative: per-host SSH host keys

Instead of a copied key file, each host can decrypt with its own SSH host key.
Remove `sops.age.keyFile` from `modules/system/secrets`, then on each host:

```bash
sudo ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub   # add to .sops.yaml
sops updatekeys secrets/<host>.yaml
```

This gives per-host separation at the cost of more setup.
