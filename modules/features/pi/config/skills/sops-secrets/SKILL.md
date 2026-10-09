---
name: sops-secrets
description: Handle sops-nix secrets in this repo safely (edit, add, consume, rotate). Use for anything touching secrets/, .sops.yaml, sops.secrets, or sops.templates.
---

# sops-nix secrets

Secrets are encrypted with sops and committed under `secrets/`. Never write,
print, log, or commit plaintext secret values.

## Reading the inventory

See `secrets/README.md` for the current secret inventory, bootstrap, and key
handling. `/var/lib/sops-nix/key.txt` is the host age key used at activation.

## Editing or adding a secret

```bash
sops secrets/<host>.yaml          # opens $EDITOR on the decrypted view
```

Adding a new key: edit the file, insert the key, save. Keep the sops metadata
(`sops:` block) intact. To encrypt a whole file non-interactively:

```bash
sops -e /tmp/plain.yaml > secrets/<host>.yaml
rm -f /tmp/plain.yaml             # always delete the plaintext copy
```

## Consuming a secret

```nix
sops.secrets."name".owner = "<user>";
# rendered to /run/secrets/name

sops.templates."name-env" = {
  owner = "<user>";
  content = "export FOO=${config.sops.placeholder."name"}";
};
```

Prefer `sops.templates` when a program needs the value in an environment or
config file; never hardcode the value.

## Rules

- Do not add secrets to `environment.systemPackages`, shell history, or commits.
- Do not set `sops.validateSopsFiles = false` to work around parse errors.
- Verify with a host eval (`/verify`); never activate to test secrets.
