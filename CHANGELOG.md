# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `gha-act-workflows` skill for validating and running GitHub Actions workflows locally
  - Two-phase validation: syntax check (`--validate`) then execution
  - Detection commands for modified/new/renamed workflow files
  - act CLI command reference with event types, job targeting, matrix filtering
  - Docker requirement documentation (validation-only needs no Docker)
  - Cleanup instructions for act containers
  - Unsupported features reference (concurrency, step summaries, etc.)

## [1.0.0] - 2026-03-31

### Added
- `opencode-info-skill/` - First skill in the collection
  - Sparse clone of OpenCode repo to `/tmp/opencode-repo`
  - Auto-generated JSON index from MDX frontmatter
  - Auto-update by comparing commit hash vs remote HEAD
  - Forbidden paths documentation (user configs with secrets)
- Root `AGENTS.md` with gitflow protocol and code style rules
- Root `README.md` with skills index and structure documentation
- `scripts/deploy-all.sh` - Deploy all skills to `~/.config/opencode/skills/`
- `LICENSE` - MIT license
- `.gitignore` - Editor, OS, and temp file exclusions
- `.github/` folder with PR and issue templates

### Security
- Explicit documentation forbidding access to user config files containing API keys
- No hardcoded secrets in any scripts
- Clean git history with no sensitive commits