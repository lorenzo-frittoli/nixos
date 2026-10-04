# AGENTS.md

Operating instructions for coding agents working in this repository. Human docs
are in `README.md`; secrets are in `secrets/README.md`.

## What this is

A dendritic NixOS flake (`flake-parts` + `import-tree` + `nix-wrapper-modules` +
`disko` + `sops-nix`). No home-manager, no stylix. Two hosts: `calcolatore`
(desktop, Hyprland/UWSM/NVIDIA) and `server` (headless).

## Commands

Run from the repo root.

```bash
# evaluate / build a host (safe, non-activating)
nix eval --raw ".#nixosConfigurations.<host>.config.system.build.toplevel.drvPath"
nix build --no-link ".#nixosConfigurations.<host>.config.system.build.toplevel"

# modules + packages
nix flake check
nix build --no-link --print-out-paths .#<feature>
nix run .#<feature> -- --version
```

**Do not run these unless the user explicitly asks** (they activate the system,
touch hardware, or expose secrets):

- `nh os switch`, `nh os test`, `nixos-rebuild ...`
- `sudo reboot`
- `./format.bash` / any `disko` format command
- anything that writes `/run/secrets` or decrypts secrets

Never state that a switch/reboot happened unless you actually ran it. Report what
you verified and what you did not.

## Hard rules

1. **Auto-import.** Every non-underscore `.nix` under `modules/` is imported by
   `import-tree` as a flake-parts module. Non-module files must be underscore
   prefixed (`_foo.nix`) or live under `modules/_lib/`. Host-local files are
   `_hardware-configuration.nix` and `_disko.nix` for this reason.
2. **Flakes see only git-tracked files.** After creating files, `git add` them
   before evaluating, or Nix fails with a missing-path error.
3. **Module shape.** A module may not mix top-level `options`/`config` with plain
   config attributes. If you define `options`, put the rest under `config = { ... }`.
4. **perSystem pkgs.** Inside `moduleWithSystem` (and `perSystem`), `pkgs` is the
   *perSystem* package set, aligned with the NixOS one in `modules/parts.nix`
   (unfree allowed, `pkgs.unstable` overlay). Use `self'.packages.<name>` for
   perSystem outputs; do not assume the NixOS `pkgs`.
5. **No home-manager / no stylix.** Per-user files go through
   `modules/_lib/userfile.nix` (systemd-tmpfiles) or a wrapper. Theme colours come
   from `modules/system/theme/_theme.nix` (plain Nix, usable from both `perSystem`
   and NixOS modules). Do not reintroduce `home-manager`, `stylix`, or `nixvim`.
6. **Secrets.** sops-nix only. Never write plaintext secrets or commit them. Edit
   `secrets/<host>.yaml` with `sops`; consume via `sops.secrets` / `sops.templates`.
7. **Hyprland config** is delivered through the `HYPRLAND_CONFIG` env var
   (`modules/features/hyprland`), with a tmpfiles symlink as fallback. Changes are
   only observable after a session restart.

## Structure

- `modules/features/<name>/default.nix` — exports `flake.nixosModules.<name>`
  (installs the app) and `perSystem.packages.<name>` (the runnable binary).
- `modules/attrs/<name>/` — bundles features and loose packages for hosts.
- `modules/system/...` — plain NixOS modules, no feature packages.
- `modules/hosts/<host>/` — `flake.nixosConfigurations.<host>`,
  `flake.diskoConfigurations.<host>`, and `flake.nixosModules.<host>Configuration`.
- `modules/parts.nix` — `systems` and the perSystem `pkgs`.
- `modules/_lib/wrap.nix` — wrap one binary with CLI flags/env vars.
- `modules/_lib/userfile.nix` — symlink a store file into a user's home.

## Preferred way to configure an app

1. Use `inputs.wrappers.wrappers.<name>.wrap { inherit pkgs; ... }` if a wrapper
   exists (kitty, waybar, zathura, yazi, starship, git, btop, ...).
2. Otherwise wrap the binary yourself with `modules/_lib/wrap.nix`
   (e.g. `wofi`, `swaync`, `rmpc`, `hyprlock`).
3. Otherwise install the plain package and place its config with
   `modules/_lib/userfile.nix` (e.g. hyprpaper, hypridle).

## Change checklist

1. Make the edit.
2. `git add` any new files.
3. `nix flake check`.
4. `nix eval --raw ".#nixosConfigurations.<host>.config.system.build.toplevel.drvPath"`
   for each affected host.
5. `nix build` for changed packages/features; `nix build --no-link ".#nixosConfigurations.<host>...toplevel"` if the change is package-level.
6. Report the result and the exact commands used.

## Do not

- Add `home-manager`, `stylix`, or `nixvim` back.
- Reference `~/.nix-profile` (it is empty; system packages are in
  `/run/current-system/sw`).
- Run activation, reboot, or disko commands without an explicit request.
- Commit plaintext secrets.
- Add a non-module `.nix` file without an underscore prefix.
