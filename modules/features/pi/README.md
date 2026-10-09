# pi

Declarative setup for the [pi](https://pi.dev) coding harness.

The wrapped binary is `perSystem.packages.pi`; `flake.nixosModules.pi` installs it
and stages the managed config into each normal user's `~/.pi/agent/`.

## How it is delivered

`perSystem.packages.pi-config` builds the config tree in the Nix store:

```
config/
  settings.json          model, theme, compaction, telemetry
  APPEND_SYSTEM.md       global working agreement
  extensions/            safety-gate, git-tracked, nix-check-hook, repo-status
  prompts/               /verify /feature /secret /eval /review
  skills/                nixos-module-authoring, sops-secrets, disko-and-hardware,
                         repo-documentation
  themes/tokyonight.json generated from modules/system/theme/_theme.nix
```

The NixOS module then, per normal user:

- creates `~/.pi/agent` (writable — it holds `auth.json`, sessions, and npm/git
  packages);
- installs `settings.json` via an activation script (always overwrites, so the
  managed settings stay authoritative — local edits are reverted on switch);
- symlinks the read-only resources (`extensions`, `skills`, `prompts`, `themes`,
  `APPEND_SYSTEM.md`) into `~/.pi/agent` with `systemd-tmpfiles`.

The wrapper sets `PI_TELEMETRY=0` and `PI_SKIP_VERSION_CHECK=1`.

## Extensions

- `safety-gate.ts` — confirms destructive/system commands (`nh os switch`,
  `nixos-rebuild`, reboot, `format.bash`, disko, `sops`, `rm -rf`, force-push) and
  blocks writes to `secrets/**.yaml`, `.sops.yaml`, `.git/`.
- `git-tracked.ts` — `git add -N` for new `.nix` files (flakes only see tracked
  files).
- `nix-check-hook.ts` — `nix-instantiate --parse` after `.nix` writes, surfacing
  syntax errors inline.
- `repo-status.ts` — hostname, git branch, and dirty marker in the footer.
- `deepseek-peak-hours.ts` — warns during DeepSeek peak pricing hours
  (00:30–16:30 UTC) and shows the off-peak window in the footer (`/deepseek-hours`).
- `auto-document.ts` — on an approval reply (`ok`, `lgtm`, `ship it`, ...) with
  uncommitted changes, asks the model to run the `repo-documentation` skill.

## Changing the config

Edit files under `modules/features/pi/config/`, `git add` them, then run the
`/verify` checklist (`nix flake check` + host eval). Changes take effect after
`nh os switch` (do not activate unless asked).
