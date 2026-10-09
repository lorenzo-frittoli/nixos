---
name: repo-documentation
description: Update this dendritic NixOS repository's documentation to match code changes. Use after a change is approved, when asked to document, or before finishing work that alters structure, features, hosts, commands, conventions, or secrets.
---

# Repository documentation

Keep the docs in sync with the code. Document **what changed**, not a roadmap.

## Documentation map

| File | What it covers |
|------|----------------|
| `README.md` | Overview, module layout, hosts table, commands, adding an app/host, theming, conventions |
| `AGENTS.md` | Operating instructions for coding agents (commands, hard rules, structure, checklist) |
| `CHANGELOG.md` | Human-readable change log (Keep a Changelog; add under `## [Unreleased]`) |
| `modules/features/<name>/README.md` | Per-feature delivery and configuration notes |
| `secrets/README.md` | Secret inventory and sops workflow |

## Process

1. Inspect the change: `git status --short`, `git diff`, `git diff --cached`.
2. Pick the affected docs from the map. Touch only those.
3. Update minimally and accurately:
   - `README.md` layout tree / hosts table / commands when structure changes.
   - `AGENTS.md` when commands, hard rules, or conventions change.
   - `CHANGELOG.md` under `## [Unreleased]` with `### Added|Changed|Fixed|Removed`.
   - `modules/features/<name>/README.md` when a feature's package, config, or
     delivery changes.
4. Do not document aspirations, guessed APIs, or commands you did not verify.
5. `git add` every doc file you changed (flakes only see git-tracked files).
6. Run the `/verify` checklist if the change affected Nix evaluation.

## CHANGELOG format

```markdown
# Changelog

## [Unreleased]

### Added
- ...
```

Newest entry first; keep each bullet one line and user-facing.
