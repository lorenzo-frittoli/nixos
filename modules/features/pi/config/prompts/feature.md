---
description: Scaffold a new feature module following the dendritic repo pattern
argument-hint: "<name> [what it does]"
---
Add a new feature called `$1` to this dendritic NixOS flake. $@

Follow the repo conventions in `AGENTS.md` and `README.md`:

1. Create `modules/features/$1/default.nix` (copy `modules/_template.nix`).
2. Build the runnable package in `perSystem.packages.$1`, choosing in order:
   - `inputs.wrappers.wrappers.$1.wrap { inherit pkgs; ... }` if a wrapper exists;
   - `import ../../_lib/wrap.nix { inherit pkgs; lib = pkgs.lib; } { ... }` to
     wrap a binary with flags/env;
   - otherwise install the plain package and place its config with
     `modules/_lib/userfile.nix`.
3. Export `flake.nixosModules.$1` that installs `self'.packages.$1`.
4. Add `$1` to the appropriate attr in `modules/attrs/`, or to
   `modules/system/desktop` if it belongs to the desktop.
5. `git add` the new files (flakes only see tracked files).
6. Verify: `nix build --no-link .# $1` (no space) and run the `/verify` checklist.

Keep exactly one non-underscore `.nix` file per feature directory; helper files
must be underscore-prefixed. Do not add home-manager, stylix, or nixvim.
