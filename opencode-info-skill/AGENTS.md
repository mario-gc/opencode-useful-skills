# opencode-info Skill Development

## Purpose

Provide instant local access to OpenCode official documentation without
URL fetching or web crawling.

## Architecture

```
/tmp/opencode-repo/           # Cloned opencode repo (sparse)
├── .opencode-docs-hash       # Stored commit hash
├── .opencode-docs-index.json # Generated docs index
└── packages/
    ├── web/src/content/docs/ # MDX documentation files
    └── opencode/src/         # Source code (for deep dive)
```

## Key Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Skill definition, usage instructions |
| `scripts/setup.sh` | Clone + update + index generation |

## Development Notes

- Sparse clone minimizes download size
- Index generated from MDX frontmatter (title, description)
- Auto-updates by comparing stored hash vs remote HEAD
- Forbidden: user opencode.json files only