# Changelog

All notable changes to this NixOS configuration are documented here. The format
loosely follows [Keep a Changelog](https://keepachangelog.com/); new entries go
under `## [Unreleased]`.

## [Unreleased]

### Added

- `modules/features/pi`: declarative wrapper and managed config for the
  [pi](https://pi.dev) coding harness — settings, a theme generated from the
  shared Tokyo Night palette, prompt templates, and skills.
- pi extensions: `safety-gate` (confirms destructive commands, blocks secret
  writes), `git-tracked` (`git add -N` for new `.nix` files), `nix-check-hook`
  (inline parse check), `repo-status` (host/branch footer),
  `deepseek-peak-hours` (peak/off-peak API price warning), and `auto-document`
  (document the repo when changes are approved).
- pi skills: `nixos-module-authoring`, `sops-secrets`, `disko-and-hardware`, and
  `repo-documentation`; prompt templates `/verify`, `/feature`, `/secret`,
  `/eval`, `/review`, and `/document`.
- `CHANGELOG.md`.
