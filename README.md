# ⚡ Command Center

Jake's mission control for voice-driven automation.

**How Jake uses it:** he doesn't. He just talks to Orion (voice or text — app, WhatsApp, wherever). Orion does the work; **everything is logged here** so there's always a paper trail: what was asked, what ran, what changed, and what the sites are doing right now.

## How it works

```
Jake speaks  →  Orion creates a task file in tasks/inbox/
             →  Orion executes (code, deploys, emails, checks…)
             →  task moves to tasks/done/, run logged in runs/
             →  dashboard + scheduled workflows keep watch 24/7
```

## What's in here

| Path | What it is |
|---|---|
| `PLAN.md` | The full build plan — vision, architecture, phases |
| `tasks/` | Task queue: `inbox/` → `active/` → `done/` |
| `runs/` | Timestamped log of every automated action |
| `scripts/` | Helper scripts (health checks, etc.) |
| `dashboard/` | Live status board (GitHub Pages) |
| `docs/approvals.md` | The short list of things that always need Jake's tap |
| `docs/connectors.md` | Connected services and their status |
| `.github/workflows/` | Scheduled + on-demand automation |

## Live dashboard

👉 https://herskyott-stack.github.io/command-center/

## Rules

1. **Free-first.** Site edits go through GitHub — Lovable Cloud auto-syncs for free. Never burn Lovable credits from here.
2. **No secrets in this repo.** Tokens, keys, passwords live in Orion's credential store, never in a file.
3. **Approvals are sacred.** Anything in `docs/approvals.md` waits for Jake's tap. No exceptions, no clever workarounds.
4. **Everything reversible.** Every run is logged; every change is a commit.

## Phase 1 (current)

Repo + dashboard + daily site health checks + voice-to-deploy logging. See `PLAN.md`.
