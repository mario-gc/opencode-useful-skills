# Global Agent Catalog

## Primary Agent

| Agent | Purpose |
|-------|---------|
| @architect | Project orchestrator - delivers complete projects |

## Subagents

| Agent | Purpose |
|-------|---------|
| @detective | Research investigation |
| @backend-dev | Backend implementation |
| @frontend-dev | Frontend implementation |
| @devops-eng | Infrastructure |
| @security-eng | Security review |
| @qa-eng | Quality review |
| @tester | Test execution |
| @writer | Documentation |
| @blogger | Content creation |

## Usage

Start with @architect for projects. They coordinate everything.

For research: `@detective Research [topic]`

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