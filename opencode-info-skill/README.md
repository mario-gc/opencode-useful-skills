# opencode-info Skill

Instant local access to OpenCode official documentation without URL fetching.

## How It Works

1. **Sparse Clone**: Clones opencode repo to `/tmp/opencode-repo` with only
   needed paths (`packages/web/src/content/docs`, `packages/opencode/src`)
2. **Index Generation**: Parses MDX frontmatter → JSON index with title,
   description, and path for each doc
3. **Auto-Update**: Compares stored commit hash vs remote HEAD. Auto-pulls
   and regenerates index if stale
4. **Agent Access**: Agent reads index → reads specific docs by path

## Benefits

| Before | After |
|--------|-------|
| URL fetch per doc | Local file read |
| Network dependency | Offline access |
| Crawl delays | Instant read |
| Stale cached docs | Auto-updated |

## Files

```
opencode-info/
├── SKILL.md                 # Skill definition
├── scripts/
│   └── setup.sh             # Clone + update + index
└── reference/
    └── index-template.json  # Index format reference
```

## Deployment

```bash
./scripts/deploy.sh
```

Copies `opencode-info/` to `~/.config/opencode/skills/opencode-info/`.

## Usage

When skill is loaded, agent receives:
- Index path: `/tmp/opencode-repo/.opencode-docs-index.json`
- Instructions: `read()` index → `read()` relevant docs

## Auto-Update Logic

```
skill(opencode-info) called
  → Check /tmp/opencode-repo exists
  → If NO: clone + generate index
  → If YES: compare .opencode-docs-hash vs git ls-remote HEAD
  → If stale: git pull + regenerate index (silent)
  → Skill content loaded with index path
```

## Forbidden Paths

Agent is instructed to NEVER read:
- `~/.config/opencode/opencode.json` (user global config)
- `<project>/.opencode/opencode.json` (project config)

These contain sensitive API keys and credentials.

Repo configs (`/tmp/opencode-repo/.opencode/*`) are NOT forbidden.

## Deep Dive

For understanding OpenCode internals, agent can explore:
`/tmp/opencode-repo/packages/opencode/src`

Use `@explore` subagent for fast codebase search.

## Index Format

See `reference/index-template.json` for structure:
```json
{
  "commitHash": "...",
  "generatedAt": "...",
  "docs": [
    {
      "file": "agents.mdx",
      "path": "/tmp/opencode-repo/packages/web/src/content/docs/agents.mdx",
      "title": "Agents",
      "description": "Configure and use specialized agents."
    }
  ]
}
```

## License

MIT