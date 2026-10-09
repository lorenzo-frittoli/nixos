---
description: Review staged git changes for bugs, security, and Nix conventions
---
Review the staged changes (`git diff --cached`) and, if nothing is staged, the
working-tree changes (`git diff`). Focus on:

- Correctness and logic errors.
- Security issues, especially secrets or destructive commands.
- NixOS/flake conventions from `AGENTS.md`: underscore rule, no mixed
  `options`/`config`, perSystem vs NixOS `pkgs`, no home-manager/stylix.
- Flake tracking: any new `.nix` files staged? (`git status --short`)
- Whether the change was verified (`nix flake check`, host eval) — call out if not.

Be concrete: cite file and line, and suggest a fix.
