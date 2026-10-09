---
description: Edit or add a sops-encrypted secret safely
argument-hint: "<secret-name>"
---
Work with the sops secret `$1` in `secrets/`. $@

Rules:
- Never write plaintext secrets to disk and never commit them.
- Edit the encrypted file with sops:
  `sops secrets/<host>.yaml` (or `sops -e -i` on a temporary plaintext file you
  delete afterwards).
- Consume secrets declaratively via `sops.secrets."<name>"` or
  `sops.templates."<name>"` in the relevant host/module; never hardcode values.
- Check ownership/group (`owner`, `group`, `mode`) match the consuming user.
- Read `secrets/README.md` for the inventory and bootstrap details.
- Verify with a host eval (see `/verify`); do not activate.
