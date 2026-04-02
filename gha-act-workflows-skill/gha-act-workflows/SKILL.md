---
name: gha-act-workflows
description: Validate and run GitHub Actions workflows locally with act CLI before task completion
license: MIT
compatibility: opencode
metadata:
  trigger: workflow-file-change
  tool: act
---

## What I Do

Validate syntax AND run GitHub Actions workflows locally using act CLI before task completion.

## Prerequisites

- **act CLI installed**:
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
  ```
- **Docker running**: Required for workflow execution (validation-only uses `--validate`)

## Detection Commands

### Modified (tracked)
```bash
git diff --name-only HEAD -- '.github/workflows/*.yml' '.github/workflows/*.yaml'
```

### New (untracked)
```bash
git status --porcelain -- '.github/workflows/' | grep '^??' | cut -c4-
```

### Renamed (validate NEW only)
```bash
git diff --name-status HEAD -- '.github/workflows/' | grep '^R' | cut -f3
```

### Deleted (skip - no file to validate)
```bash
git diff --name-status HEAD -- '.github/workflows/' | grep '^D'
```

### No workflows changed
```bash
# If all detection commands return empty, skip validation entirely
```

## Validation Process

### Phase 1: Syntax Validation (No Docker)

```bash
act --validate -W .github/workflows/ci.yml
```

Options:
- `--validate` - Validate workflow syntax only (no execution)
- `--strict` - Use stricter schema validation

### Phase 2: Run Workflows (Needs Docker)

```bash
act -W .github/workflows/ci.yml
```

Options:
- Default event: `push`
- Specify event: `act -W workflow.yml pull_request`
- Specific job: `act -W workflow.yml -j build`
- Matrix filter: `act -W workflow.yml --matrix node:18`
- Dry run: `act --dryrun -W workflow.yml` (no containers)

## Workflow

1. **Detect all changed workflows** (modified + new + renamed)
2. **For EACH workflow**:
   - Validate syntax: `act --validate -W <workflow>`
   - If validation fails → Fix, block completion
   - If validation passes → Run workflow: `act -W <workflow>`
   - If run fails → Fix, re-run, block completion
3. **If ALL pass**: Proceed with task completion

## act CLI Commands

```bash
# Syntax validation (no Docker)
act --validate -W .github/workflows/ci.yml
act --validate --strict -W .github/workflows/ci.yml

# Run workflow (needs Docker)
act -W .github/workflows/ci.yml
act -W .github/workflows/ci.yml push
act -W .github/workflows/ci.yml pull_request

# Target specific job
act -W .github/workflows/ci.yml -j build

# Matrix filtering
act -W .github/workflows/test.yml --matrix node:18 --matrix os:ubuntu

# Dry run (validate execution plan, no containers)
act --dryrun -W .github/workflows/ci.yml

# List workflows/jobs
act -l
act -l pull_request

# Graph visualization
act -g

# With secrets (use placeholder values, never real secrets)
act -W deploy.yml -s MY_SECRET=test_value
act -W deploy.yml -s GITHUB_TOKEN=test_token

# With environment variables
act -W ci.yml --env NODE_ENV=test --env-file .env
```

## Event Types

Common events that trigger workflows:

| Event | Command |
|-------|---------|
| push | `act push` or `act` (default) |
| pull_request | `act pull_request` |
| workflow_dispatch | `act workflow_dispatch` |
| schedule | `act schedule` |
| release | `act release` |

Check workflow triggers with:
```bash
act -l
```

## Edge Cases

### 1. Multiple Changed Workflows
Validate and run each independently. ALL must pass.

```bash
for wf in $changed; do
  act --validate -W "$wf" || exit 1
  act -W "$wf" || exit 1
done
```

### 2. New Workflow (Untracked)
Validate before first commit.

```bash
new=$(git status --porcelain -- '.github/workflows/' | grep '^??' | cut -c4-)
for wf in $new; do
  act --validate -W "$wf"
  act -W "$wf"
done
```

### 3. Renamed Workflow
Validate NEW filename only.

```bash
renamed_new=$(git diff --name-status HEAD -- '.github/workflows/' | grep '^R' | cut -f3)
for wf in $renamed_new; do act -W "$wf"; done
```

### 4. Deleted Workflow
Skip - no file to validate.

### 5. Matrix Strategy (Full Expansion)
Run full matrix - default act behavior.

```bash
act -W .github/workflows/test.yml  # All matrix combos
```

Or filter specific configurations:
```bash
act -W .github/workflows/test.yml --matrix node:18
```

### 6. Secrets Required
Use placeholder values (never commit real secrets).

```bash
act -W deploy.yml -s MY_SECRET=test_value
act -W deploy.yml -s GITHUB_TOKEN="$(gh auth token)"
```

### 7. Docker Unavailable
Use `--validate` or `--dryrun` (no containers needed).

```bash
docker info &>/dev/null || act --validate -W <workflow>
docker info &>/dev/null || act --dryrun -W <workflow>
```

### 8. No Workflows Changed
Skip validation entirely.

### 9. Event-Specific Workflows
Some workflows only trigger on specific events. Check triggers:

```bash
act -l  # List all workflows with their events
act -l pull_request  # List workflows triggered by pull_request
```

Run with correct event:
```bash
act -W .github/workflows/pr-check.yml pull_request
```

### 10. Reusable Workflows / Composite Actions
Validate dependencies first, then caller.

## Common Errors

| Error | Fix |
|-------|-----|
| `workflow not found` | Check YAML syntax, verify path |
| `job 'xxx' not found` | Verify job IDs match |
| `expression evaluation error` | Check `${{ }}` syntax |
| `action not found` | Verify `uses:` path (owner/repo@version) |
| `Docker permission denied` | Ensure Docker daemon running |
| `invalid yaml` | Fix YAML indentation/structure |
| `unknown context` | Check expression context usage |

## Output Format

```
GitHub Actions Validation:
- ci.yml: VALIDATE PASS, RUN PASS
- deploy.yml: VALIDATE PASS, RUN PASS (matrix: 3 combos)
- [failed.yml]: VALIDATE FAIL - [error]
- [failed.yml]: RUN FAIL - [error]
```

## Cleanup

After validation, remove act containers:

```bash
docker ps -a | grep act_ | awk '{print $1}' | xargs -r docker rm -f
```

## Skipping Validation

If workflows should be skipped during act runs:

**Skip job:**
```yaml
jobs:
  deploy:
    if: ${{ !github.event.act }}
```

Run with:
```bash
act -e '{"act": true}'
```

**Skip step:**
```yaml
- name: Some step
  if: ${{ !env.ACT }}
  run: echo "Skipped during act"
```

## Unsupported Features

act does not support:
- `concurrency` group limits
- `run-name`
- Step summaries
- Problem matchers
- Annotations
- `job.environment`
- OpenID Connect

See: https://nektosact.com/not_supported