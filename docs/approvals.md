# Approvals — always needs Jake's tap

Automation handles everything **except** this list. If a task touches any of these, Orion pauses and asks Jake instead of executing. No exceptions, no clever workarounds.

1. **Spending money** — purchases, subscriptions, ad spend, invoices sent.
2. **New logins / OAuth connections** — connecting a new service for the first time.
3. **CAPTCHAs** — only a human can clear these.
4. **Publishing under Jake's name** — first time per flow. Once Jake approves a flow (e.g. "post my gig announcements"), it becomes a standing instruction and no longer needs per-item approval.
5. **Deleting data / closing accounts** — anything destructive or irreversible.
6. **Anything irreversible not covered by a standing instruction** — when in doubt, ask.

*Standing instructions* (approved once, then automatic) are recorded in the relevant task file in `tasks/done/` so there's always a record of what Jake approved.
