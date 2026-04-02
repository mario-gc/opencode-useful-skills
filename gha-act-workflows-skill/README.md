# gha-act-workflows Skill

Validate syntax AND run GitHub Actions workflows locally with act CLI before task completion.

## How It Works

1. **Detect**: Find changed `.github/workflows/*.yml` files
2. **Validate**: Check syntax with `act --validate` (no Docker)
3. **Run**: Execute workflows with `act` (needs Docker)
4. **Block**: Prevent completion if validation or execution fails

## Benefits

| Before | After |
|--------|-------|
| Push → CI fails → Fix → Push → Wait | Validate locally → Fix → Run locally → Push with confidence |
| 10+ minute CI cycles | Seconds to validate, minutes to run locally |
| Catch errors after push | Catch errors before push |

## Docker Requirement

**Syntax validation (`--validate`):**
- No Docker required
- Validates YAML structure and schema
- Catches syntax errors, expression errors, invalid actions

**Running workflows:**
- Docker required
- Pulls/builds action images
- Runs containers simulating GitHub runner environment

**Dry run (`--dryrun`):**
- No Docker required
- Validates execution plan
- Shows what would run without containers

### Docker Not Available?

Use `--validate` or `--dryrun`:
```bash
docker info &>/dev/null || act --validate -W .github/workflows/ci.yml
```

## Prerequisites

1. **act CLI installed**:
   ```bash
   # macOS
   brew install act
   
   # Linux (curl)
   curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
   
   # Windows
   choco install act-cli
   scoop install act
   ```

2. **Docker running** (for workflow execution):
   ```bash
   docker info
   ```

## Files

```
gha-act-workflows/
└── SKILL.md          # Skill definition with validation workflow
```

## Deployment

```bash
./scripts/deploy.sh
```

Copies `gha-act-workflows/` to `~/.config/opencode/skills/gha-act-workflows/`.

## Usage

When skill is loaded, agent receives:
- Detection commands for changed workflows
- Two-phase validation workflow (syntax → run)
- act CLI commands reference
- Error handling patterns
- Cleanup instructions

## Validation Workflow

```
Task modifies .github/workflows/ci.yml
  → Skill detects change
  → Phase 1: act --validate -W ci.yml
  → If FAIL: Fix, re-validate, block completion
  → Phase 2: act -W ci.yml
  → If FAIL: Fix, re-run, block completion
  → If PASS: Proceed with task completion
```

## Example Commands

```bash
# Syntax check (fast, no Docker)
act --validate -W .github/workflows/ci.yml

# Run workflow (needs Docker)
act -W .github/workflows/ci.yml

# Run with event
act -W .github/workflows/pr-check.yml pull_request

# Run specific job
act -W .github/workflows/ci.yml -j test

# Matrix filtering
act -W .github/workflows/test.yml --matrix node:18
```

## Unsupported Features

act cannot run:
- `concurrency` group limits
- Step summaries
- Problem matchers
- Annotations
- Environment deployment gating

See: https://nektosact.com/not_supported

## License

MIT

## Reference

- act: https://github.com/nektos/act
- act docs: https://nektosact.com