---
name: nixos-module-authoring
description: Author modules in this dendritic NixOS flake (features, attrs, system modules, hosts). Use when adding or changing NixOS configuration in this repo, choosing where a file belongs, or fixing module-evaluation errors.
---

# NixOS module authoring (this repo)

This is a **dendritic** flake: `flake-parts` + `import-tree` auto-import every
non-underscore `modules/**/*.nix` as a flake-parts module. There is **no
home-manager and no stylix**.

## Where things go

- `modules/features/<name>/default.nix` — one app. Exports a runnable package
  (`perSystem.packages.<name>`) and a NixOS module
  (`flake.nixosModules.<name>`) that installs it.
- `modules/attrs/<name>/default.nix` — named bundles of features + loose packages
  (`development`, `gaming`, ...).
- `modules/system/...` — plain NixOS modules with no feature package.
- `modules/hosts/<host>/` — `flake.nixosConfigurations.<host>`,
  `flake.diskoConfigurations.<host>`, and `<host>Configuration`.
- `modules/_lib/wrap.nix` — wrap one binary with flags/env.
- `modules/_lib/userfile.nix` — symlink a store file into a user's home via
  systemd-tmpfiles.

## Hard rules

1. **Every non-underscore `.nix` under `modules/` is a flake-parts module.**
   Helpers and non-module files must be underscore-prefixed (`_foo.nix`) or live
   under `modules/_lib/`.
2. **Flakes only see git-tracked files.** `git add` new files before evaluating,
   or Nix fails with a missing-path error.
3. **Do not mix** top-level `options`/`config` with plain config attributes. If
   you define `options`, put the rest under `config = { ... }`.
4. **`perSystem`/`moduleWithSystem` `pkgs` is the perSystem package set** (aligned
   with NixOS in `modules/parts.nix`; unfree allowed, `pkgs.unstable` overlay).
   Use `self'.packages.<name>` for perSystem outputs.
5. **No home-manager/stylix/nixvim.** Per-user files go through
   `_lib/userfile.nix` or a wrapper.

## Feature template

```nix
{ inputs, moduleWithSystem, ... }: {
  flake.nixosModules.<name> = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.<name> ];
  });
  perSystem = { pkgs, ... }: {
    packages.<name> = inputs.wrappers.wrappers.<name>.wrap {
      inherit pkgs;
    };
  };
}
```

## Checklist

1. Edit; `git add` new files.
2. `nix flake check`.
3. `nix eval --raw ".#nixosConfigurations.<host>.config.system.build.toplevel.drvPath"`.
4. `nix build --no-link .#<feature>` for changed packages.

Never run `nh os switch/test`, `nixos-rebuild`, reboot, or disko commands unless
the user explicitly asked.
