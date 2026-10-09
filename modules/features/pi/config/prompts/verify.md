---
description: Run the nixos repo verification checklist without activating anything
argument-hint: "[host]"
---
Verify the current work in this repository (`/home/frittata/nixos`) following its
change checklist. **Do not activate anything**: never run `nh os switch`,
`nh os test`, `nixos-rebuild`, reboot, or disko commands.

1. Check for new files and stage them — flakes only see git-tracked files:
   `git status --short`; `git add` anything new.
2. Run `nix flake check`.
3. Evaluate each affected host's toplevel:
   `nix eval --raw ".#nixosConfigurations.<host>.config.system.build.toplevel.drvPath"`.
   If no host was given, infer affected hosts from the files changed
   (`git status --short`), and default to both `calcolatore` and `server`.
4. For changed features/packages, run `nix build --no-link .#<name>`.
5. Report the exact commands used and their results, plus anything you did not run.
