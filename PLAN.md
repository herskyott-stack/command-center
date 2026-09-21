# Command Center — Build Plan

## Vision

Jake runs his entire digital life by voice. He says what he wants; Orion (his AI assistant) executes; GitHub is the hands; Lovable Cloud auto-syncs site repos for free. The command center is the **single source of truth**: every task, every automated run, every site status, every connector — visible in one repo, one dashboard.

Goal: Jake never has to "touch his phone" for routine work. ~95% hands-free. The remaining ~5% is the approvals list (money, logins, CAPTCHAs, irreversible actions) — that's by design, not a technical gap.

## Architecture

```
                    ┌─────────────┐
                    │    JAKE     │  voice / text (app, WhatsApp)
                    └──────┬──────┘
                           │ "just say it"
                    ┌──────▼──────┐
                    │    ORION    │  interprets, plans, executes
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
 ┌──────▼──────┐   ┌───────▼────────┐   ┌─────▼──────┐
 │   GitHub    │   │  Connectors    │   │  Schedules │
 │ (the hands) │   │ (Gmail, Cal…)  │   │ (Actions + │
 │ code, tasks │   │ via Orion      │   │  Orion     │
 │ logs, Pages │   │ skills         │   │  crons)    │
 └──────┬──────┘   └────────────────┘   └────────────┘
        │ free sync
 ┌──────▼──────┐
 │   Lovable   │  Cloud auto-syncs site repos from GitHub.
 │   Cloud     │  Zero credits burned. Never prompt Lovable's
 └─────────────┘  AI from automation (credit-costly).
```

**Key flows:**

- **Voice → deploy:** Jake: "change the headline on beatmasterdj." Orion commits to the site repo → pushes → Lovable Cloud syncs live → Orion triggers `deploy-verify` here → confirms "it's live."
- **Scheduled watch:** GitHub Actions runs health checks daily; Orion crons watch leads, bills, inboxes; everything lands in `runs/` and the dashboard.
- **Approvals gate:** anything in `docs/approvals.md` pauses and pings Jake instead of executing.

## Phases

### Phase 1 — Foundation (this build) ✅
- [x] Repo scaffold: tasks queue, run logs, scripts, docs
- [x] Status dashboard on GitHub Pages (dark, mobile-friendly)
- [x] Daily site health checks (hersky.info, beatmasterdj.ca) → `dashboard/status.json` + `incident` issues when down
- [x] Voice-to-deploy logging format (`runs/`, task lifecycle)
- [x] `deploy-verify` stub workflow (Orion triggers after site pushes)

### Phase 2 — Watchers
- **Lead watcher:** poll Supabase leads table (via Orion, credentials in store — never here); notify Jake on new leads; log to `runs/`.
- **Content engine:** draft social posts from gig/event calendar; save drafts for Jake's one-tap approval (publishing = approvals list).
- **Bill watcher:** scan Gmail for new bills/subscriptions; flag unexpected charges; feed the subscription audit.

### Phase 3 — Autonomy
- **Client onboarding flow:** new lead → auto-reply draft → contract draft → deposit invoice draft → calendar hold. Each step logged; money/publishing steps wait for Jake's tap.
- **Deploy self-healing:** if a deploy-verify fails, auto-retry once, then roll back to last good commit and open an `incident` issue. Never silently retry more than once.

## Principles

1. **Free-first:** no paid APIs where a free path exists; Lovable edits via GitHub sync only.
2. **No secrets in the repo.** Ever.
3. **Logged or it didn't happen.** Every automated action gets a `runs/` entry.
4. **Boring technology.** Vanilla HTML/JS dashboard, bash scripts, GitHub Actions. Nothing to maintain.
5. **Jake's tap is law.** The approvals list overrides everything.
