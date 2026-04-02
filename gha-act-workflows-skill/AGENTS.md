# gha-act-workflows Skill Development

## Purpose

Validate syntax AND run GitHub Actions workflows locally with act CLI before task completion.

## Architecture

```
Workflow:
1. Detect changed .github/workflows/*.yml files
2. Phase 1: Syntax validation (--validate, no Docker)
3. Phase 2: Run workflows (needs Docker)
4. Block completion if ANY fail
```

## Key Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Skill definition with validation workflow |

## Development Notes

- act installation: `curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash`
- Docker required for workflow execution only
- `--validate` flag for syntax-only checks
- Reference: https://github.com/nektos/act