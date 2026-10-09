# nixos

A personal NixOS configuration for two machines, built as a **dendritic** flake: the
filesystem mirrors the module tree, every file is a module, and application
configuration is baked into wrapped executables instead of being managed by
home-manager.

- [`flake-parts`](https://flake.parts) — flake/module framework
- [`import-tree`](https://github.com/vic/import-tree) — auto-import `modules/**`
- [`nix-wrapper-modules`](https://github.com/BirdeeHub/nix-wrapper-modules) — configured executables
- [`disko`](https://github.com/nix-community/disko) — declarative disk layout
- [`sops-nix`](https://github.com/Mic92/sops-nix) — secrets

There is **no home-manager** and **no stylix**. Application config is either
compiled into a wrapper (`nix run .#kitty` gives you *your* kitty) or placed in a
fixed path with `systemd-tmpfiles`.

Agent working instructions live in [`AGENTS.md`](AGENTS.md); secret handling in
[`secrets/README.md`](secrets/README.md).

## Layout

```
flake.nix                     inputs and the flake-parts entrypoint
modules/
  parts.nix                   flake-parts `systems` + the perSystem `pkgs`
  _template.nix               copy to start a new feature
  _lib/
    wrap.nix                  wrap one binary with flags/env
    userfile.nix              place a file in a user's home via tmpfiles
  features/                   one app per directory: package + NixOS module
  attrs/                      named bundles of features (development, gaming, ...)
  system/                     plain NixOS modules (core, audio, network, desktop, ...)
  hosts/                      one directory per machine
secrets/                      sops-encrypted files and their docs
static/                       images referenced by config (wallpaper)
format.bash                   format a host's disks using its disko config
CHANGELOG.md                  notable changes (see modules/features/pi for the
                              auto-documentation that maintains it)
```

`import-tree` imports every `**/*.nix` under `modules/` as a flake-parts module.
Any path containing `/_` is skipped, which is how helper files (`_lib/`) and
host-local files (`_hardware-configuration.nix`, `_disko.nix`) are kept out of the
module tree.

## How the pattern works

There are three kinds of module.

**Feature** — one app, self-contained, in `modules/features/<name>/default.nix`.
It exposes a runnable package *and* a NixOS module that installs it:

```nix
{ inputs, moduleWithSystem, ... }: {
  flake.nixosModules.kitty = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.kitty ];
  });

  perSystem = { pkgs, ... }: {
    packages.kitty = inputs.wrappers.wrappers.kitty.wrap {
      inherit pkgs;
      settings = { font_family = "JetBrains Mono"; };
    };
  };
}
```

`nix run .#kitty` runs the configured binary; importing `flake.nixosModules.kitty`
installs it system-wide. Because the configuration lives in the derivation, the
binary and its config can never drift apart.

**Attr** — a named bundle in `modules/attrs/<name>/` that imports features and
adds loose packages (e.g. `development`, `creative`, `gaming`). Hosts pick a set
of attrs.

**System** — plain NixOS config in `modules/system/...`, with no feature packages:
`core` (boot, nix, locale, hardware), `audio`, `network`, `fonts`, `theme`,
`docker`, `nh`, `drivers/nvidia`, `secrets`, and `desktop` (which composes the
window-manager stack). Nothing here is imported unless a host asks for it.

A host composes all three:

```nix
flake.nixosConfigurations.calcolatore = inputs.nixpkgs.lib.nixosSystem {
  modules = [ inputs.disko.nixosModules.disko ] ++ (with self.nixosModules; [
    desktop nvidiaDrivers development creative gaming multimedia comms
    desktopApps calcolatoreConfiguration
  ]);
};
```

## Hosts

| Host | User | Profile |
|------|------|---------|
| `calcolatore` | `frittata` | Hyprland (UWSM, started by greetd), NVIDIA PRIME offload, desktop attrs |
| `server` | `user01` | `core` + `network` + openssh; no desktop |

Each `modules/hosts/<host>/` holds:

- `default.nix` — `flake.nixosConfigurations.<host>` and `flake.diskoConfigurations.<host>`
- `configuration.nix` — `flake.nixosModules.<host>Configuration` (hostname, users, services)
- `_hardware-configuration.nix`, `_disko.nix` — hardware/disk, underscore-skipped

## Commands

```bash
# system
nh os switch --flake ~/nixos#calcolatore   # build + activate + set boot default
nh os boot                                 # build + set boot default, no activation
nh os test                                 # build + activate, does NOT set boot default
nixos-rebuild switch --flake ~/nixos#calcolatore   # same, without nh

# a single configured app
nix run .#kitty
nix build --no-link --print-out-paths .#waybar

# validation
nix flake check

# disks (destructive)
./format.bash calcolatore
```

Use `switch` or `boot`. `test` activates without advancing the boot generation,
which is how you end up rebooting into an old system.

## Adding an app

1. Create `modules/features/<name>/default.nix` (copy `modules/_template.nix` or an
   existing feature).
2. Build the package in `perSystem.packages.<name>`:
   - `inputs.wrappers.wrappers.<name>.wrap { inherit pkgs; ... }` if a wrapper exists;
   - otherwise `import ../../_lib/wrap.nix { inherit pkgs; lib = pkgs.lib; } { ... }`
     to wrap a binary with flags/env;
   - otherwise install the plain package and place its config with `_lib/userfile.nix`.
3. Export `flake.nixosModules.<name>` installing `self'.packages.<name>`.
4. Add the feature to an attr, or to `system/desktop` if it belongs to the desktop.
5. `git add` the new files (flakes only see tracked files), then
   `nix run .#<name>` and `nix flake check`.

## Adding a host

1. Copy `modules/hosts/server/` to `modules/hosts/<host>/`.
2. Replace `_hardware-configuration.nix` with `nixos-generate-config` output and
   set the disk in `_disko.nix`.
3. Edit `configuration.nix` (hostname, users, services).
4. Register the host in `modules/hosts/<host>/default.nix`.

## Secrets

Encrypted with sops and committed under `secrets/`. At activation each host
decrypts using `/var/lib/sops-nix/key.txt`. Values are rendered to
`/run/secrets/...` and `sops.templates` can compose them into config files.
Bootstrap, editing, and the current secret inventory are in
[`secrets/README.md`](secrets/README.md). Never commit plaintext.

## Theming

No stylix. The palette and a few layout values are plain Nix in
`modules/system/theme/_theme.nix`, importable from both `perSystem` wrappers and
NixOS modules, so colours are resolved at build time without a module-system
dependency. System-level cursor, icon, GTK and Qt settings are in
`modules/system/theme/default.nix`.

## Conventions and gotchas

- **Underscore rule.** Every non-underscore `.nix` under `modules/` is evaluated
  as a flake-parts module. Helpers and non-module files must be prefixed with `_`.
- **Flakes only see git-tracked files.** `git add` new files before evaluating, or
  Nix reports the module tree is missing.
- **`moduleWithSystem` pkgs are perSystem pkgs**, not the NixOS module's. They are
  aligned in `modules/parts.nix` (unfree allowed, `pkgs.unstable` overlay present).
  Use `self'.packages.<name>` for perSystem outputs.
- **Don't mix `options`/`config` with plain attributes** at the top level of a
  module; wrap config in `config = { ... }` if you define options.
- **Hyprland config is delivered through `HYPRLAND_CONFIG`** (`features/hyprland`),
  with a tmpfiles symlink as fallback. Editing it requires a session restart.
- **No home-manager.** Per-user files use `_lib/userfile.nix` (tmpfiles) or a
  wrapper. Do not target `~/.nix-profile`.
- `~/.nix-profile` may still exist but is empty; system binaries come from
  `/run/current-system/sw`.

## Maintenance

```bash
nix flake update
nh os switch --update
nh clean all --keep 3
```
