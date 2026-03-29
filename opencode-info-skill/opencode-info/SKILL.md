---
name: opencode-info
description: Official OpenCode documentation from local repo (instant access, no URL fetching)
license: MIT
compatibility: opencode
metadata:
  audience: developers
  type: reference
---

## What I Do

Provide instant OpenCode docs access from locally cloned repo. No URL fetching,
no web crawling, no network delays.

## Setup

Run this on first use or if `/tmp/opencode-repo` is missing:

```bash
bash /tmp/opencode-repo-setup.sh
```

Or use the skill's bundled script:

```bash
bash ~/.config/opencode/skills/opencode-info/scripts/setup.sh
```

This will:
1. Sparse clone opencode repo to `/tmp/opencode-repo`
2. Generate JSON index from MDX frontmatter
3. Store commit hash for update tracking

## Index Location

```
/tmp/opencode-repo/.opencode-docs-index.json
```

Read this file to discover all available documentation with titles,
descriptions, and paths.

## How to Use

1. **Discover docs**: `read()` the index file
2. **Read specific doc**: `read()` path from index (e.g., 
   `/tmp/opencode-repo/packages/web/src/content/docs/agents.mdx`)
3. **Search docs**: `grep()` or `glob()` in `/tmp/opencode-repo/packages/web/src/content/docs/`

## Auto-Update

The setup script compares stored hash vs remote HEAD:
- If matching: use existing index
- If stale: `git pull` + regenerate index (silent)

Run setup script periodically to ensure fresh docs.

## Available Documentation

| Topic | File |
|-------|------|
| Agents | `agents.mdx` |
| CLI | `cli.mdx` |
| Commands | `commands.mdx` |
| Config | `config.mdx` |
| Custom Tools | `custom-tools.mdx` |
| Skills | `skills.mdx` |
| Tools | `tools.mdx` |
| Permissions | `permissions.mdx` |
| Providers | `providers.mdx` |
| Rules (AGENTS.md) | `rules.mdx` |
| MCP Servers | `mcp-servers.mdx` |
| Models | `models.mdx` |
| LSP | `lsp.mdx` |
| Keybinds | `keybinds.mdx` |
| TUI | `tui.mdx` |
| Server | `server.mdx` |
| SDK | `sdk.mdx` |
| Share | `share.mdx` |
| Plugins | `plugins.mdx` |
| Themes | `themes.mdx` |
| Enterprise | `enterprise.mdx` |
| Zen | `zen.mdx` |
| Network | `network.mdx` |
| IDE | `ide.mdx` |
| GitHub | `github.mdx` |
| GitLab | `gitlab.mdx` |
| Formatters | `formatters.mdx` |
| Troubleshooting | `troubleshooting.mdx` |
| Windows/WSL | `windows-wsl.mdx` |
| ACP | `acp.mdx` |

All located in: `/tmp/opencode-repo/packages/web/src/content/docs/`

## Deep Dive

For understanding OpenCode internals, explore source code:

```
/tmp/opencode-repo/packages/opencode/src/
```

Use `@explore` subagent for fast codebase search:
- Find files by pattern
- Search code for keywords
- Understand architecture

## Forbidden

**NEVER read these files** - They contain sensitive user configuration
including API keys and provider credentials:

- `~/.config/opencode/opencode.json` (user global config)
- `<project>/.opencode/opencode.json` (project config)

**Repo configs are NOT forbidden**:
- `/tmp/opencode-repo/.opencode/opencode.jsonc` (OpenCode's own config)
- `/tmp/opencode-repo/.opencode/tui.json` (OpenCode's TUI config)

These are public development files, not user secrets.

## Quick Reference

```bash
# Setup repo
bash ~/.config/opencode/skills/opencode-info/scripts/setup.sh

# View index
cat /tmp/opencode-repo/.opencode-docs-index.json

# Read a doc
cat /tmp/opencode-repo/packages/web/src/content/docs/agents.mdx

# Search docs
grep -r "topic" /tmp/opencode-repo/packages/web/src/content/docs/

# Update docs
cd /tmp/opencode-repo && git pull
```

## Source

Cloned from: https://github.com/anomalyco/opencode
Branch: `dev`
Paths: `packages/web/src/content/docs`, `packages/opencode/src`