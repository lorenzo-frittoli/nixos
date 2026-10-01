# Dendritic NixOS Config

A [dendritic](https://github.com/mightyiam/dendritic) NixOS configuration built with
[flake-parts](https://flake.parts), [import-tree](https://github.com/vic/import-tree)
and [nix-wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules).

There is **no home-manager** and **no stylix**. Application configuration is baked
into wrapped binaries, so `nix run .#<app>` gives you *your* configured app.

## Structure

```
modules/
├── features/   # one self-contained app per folder: wrapped binary + its config
├── attrs/      # groupings of features (development, creative, gaming, ...)
├── system/     # plain NixOS modules, no binaries (core, audio, network, desktop, drivers)
├── hosts/      # one folder per machine
├── parts.nix   # flake-parts `systems` and perSystem pkgs
└── _template.nix, _lib/   # helpers (underscore-prefixed => ignored by import-tree)
```

Every `modules/**/default.nix` is a flake-parts module. Features export both a
`packages.<name>` (runnable via `nix run .#<name>`) and a `flake.nixosModules.<name>`
that installs it system-wide. Non-module helper files must be prefixed with `_` so
`import-tree` skips them.

## Hosts

| Host | User | Description |
|------|------|-------------|
| `calcolatore` | `frittata` | Desktop (Hyprland, NVIDIA prime offload, GUI apps) |
| `server` | `user01` | Minimal headless server (placeholder hardware config) |

## Usage

```bash
# Build / switch the desktop
sudo nixos-rebuild switch --flake .#calcolatore

# Build the server
sudo nixos-rebuild switch --flake .#server

# Run a configured app without switching
nix run .#kitty
nix run .#waybar
nix run .#neovim

# Format a host's disks (destructive)
./format.bash calcolatore
```

## Notes

- Theming uses a plain palette in `modules/system/theme/_theme.nix`, imported by
  both the wrappers and the NixOS modules. No external theme framework.
- Wrapped apps: `kitty`, `waybar`, `zathura`, `yazi`, `starship`, `hyprlock`,
  `wofi`, `swaync`, `rmpc`, `neovim`.
- Hyprland/Hyprpaper/Hypridle configs are placed into `~/.config/hypr` via
  `systemd-tmpfiles` (helper: `modules/_lib/userfile.nix`).
- Neovim uses a plain Lua + lazy.nvim config in `modules/features/neovim/config`.
- `modules/hosts/server/_hardware-configuration.nix` is a placeholder; replace it
  with the real `nixos-generate-config` output for the server.
- `modules/hosts/server/_disko.nix` contains a placeholder disk device.
