# Connectors

| Service | How it's connected | Status | Notes |
|---|---|---|---|
| Orion (Muse) | Voice/text chat — the command layer | ✅ Active | Jake just says it; Orion executes |
| GitHub | Stored credential (`custom.github`), API via `api.github.com` | ✅ Active | The hands: code, tasks, logs, Pages |
| Lovable Cloud | GitHub sync on site repos | ✅ Active | **Free** — edits via git, never Lovable credits |
| Gmail / Calendar | Orion skills | ✅ Active | Bill watcher + scheduling (Phase 2) |
| Supabase | Orion skill, credentials in Orion's store (never in this repo) | 🔶 Planned | Lead watcher (Phase 2) |
| Lovable API / MCP | Public API + MCP server (early/research release) | ⛔ Avoid for now | Works, but burns Lovable credits when its AI builds — use GitHub sync instead |

**Rule:** credentials live in Orion's credential store or GitHub Actions secrets. They are **never** committed to this repo.
