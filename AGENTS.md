# Git Flow Protocol

## Branch Structure
- `main` - Production releases only
- `develop` - Integration branch for features
- `feature/*` - Feature branches (branch from develop, merge back to develop)

## Rules
- Never commit directly to `main` or `develop`
- Create feature branches: `feature/descriptive-name`
- Complete features via pull requests
- Use conventional commit messages

# Code Style

- NO comments unless asked
- Minimal output (<4 lines)
- No emojis unless requested

# Documentation Standards

## Required Documentation
- `README.md` - Project overview, setup, usage
- `AGENTS.md` - Agent/project rules

## Best Practices
- Follow existing project documentation patterns
- Write for the end user (clear, concise, actionable)