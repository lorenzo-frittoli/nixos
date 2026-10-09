---
description: Evaluate a host's system toplevel derivation path (no activation)
argument-hint: "<host>"
---
Evaluate the NixOS configuration for host `$1` without activating it. $@

Run:
`nix eval --raw ".#nixosConfigurations.$1.config.system.build.toplevel.drvPath"`

Then, if the evaluation succeeded, build it without switching:
`nix build --no-link ".#nixosConfigurations.$1.config.system.build.toplevel"`

Report the resulting store path or the exact error. Do not run
`nh os switch`, `nh os test`, or `nixos-rebuild`.
