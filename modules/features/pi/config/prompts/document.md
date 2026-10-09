---
description: Update this repo's docs (README/AGENTS/CHANGELOG/feature READMEs) for the current changes
argument-hint: "[what changed]"
---
Update the documentation for the current changes in this repository. $@

Use the `repo-documentation` skill. Inspect `git status --short` and `git diff`
(and `git diff --cached`), then update only the affected docs:
`README.md`, `AGENTS.md`, `CHANGELOG.md` (under `## [Unreleased]`), and any
`modules/features/<name>/README.md`. Keep it concise and accurate, `git add`
the edited docs, and report which files you updated and why.
