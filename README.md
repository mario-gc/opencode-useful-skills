# OpenCode Useful Skills

Collection of useful skills for OpenCode AI agent.

## Skills Index

| Skill | Description | Location |
|-------|-------------|----------|
| opencode-info | Official OpenCode docs from local repo (no URL fetching) | `opencode-info-skill/` |
| gha-act-workflows | Validate and run GitHub Actions workflows locally with act CLI | `gha-act-workflows-skill/` |

## Deployment

### Deploy Single Skill

```bash
cd opencode-info-skill
./scripts/deploy.sh
```

### Deploy All Skills

```bash
./scripts/deploy-all.sh
```

Skills are copied to `~/.config/opencode/skills/<skill-name>/`.

## Repository Structure

```
opencode-useful-skills/
├── AGENTS.md              # Root agent rules (gitflow, code style)
├── README.md              # This file
├── LICENSE                # MIT
├── scripts/
│   └── deploy-all.sh      # Deploy all skills
│
├── <skill-name>-skill/    # Skill development folder
│   ├── AGENTS.md          # Optional skill-specific rules
│   ├── README.md          # Skill documentation
│   ├── scripts/
│   │   └── deploy.sh      # Deploy this skill
│   └── <skill-name>/      # Actual skill (copied to global)
│       ├── SKILL.md       # Skill definition
│       ├── scripts/       # Skill scripts
│       └── reference/     # Reference files
```

## Adding New Skills

1. Create folder: `<skill-name>-skill/`
2. Add subfolders: `scripts/`, `<skill-name>/`
3. Create `SKILL.md` with required frontmatter:
   ```yaml
   ---
   name: <skill-name>
   description: Brief description (1-1024 chars)
   license: MIT
   compatibility: opencode
   ---
   ```
4. Add `deploy.sh` in skill scripts
5. Update root README.md skills index

## Skill Development Guidelines

- Each skill is self-contained
- Skills should not depend on other skills
- Use `scripts/` for setup/maintenance scripts
- Use `reference/` for templates, examples, schemas
- Document in skill-level README.md

## License

MIT