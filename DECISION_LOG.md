# Decision log

## 2026-07-23 — D-001: Keep the first release lightweight

Use concise, file-backed records and a small status script. Defer token-meter implementation and integrate an existing tool such as Tokdash later.

## 2026-07-23 — D-002: Develop the Skill locally first

The Skill was initially developed locally before global installation.

## 2026-07-23 — D-003: Use Tokdash as the single token-statistics provider

Query Tokdash's local indexed API only for status and task-close snapshots. Do not independently reparse Codex sessions or claim aggregate usage as task-exclusive.

## 2026-07-23 — D-004: Rename the Skill to save-tokens

Use `save-tokens` as the global Skill name to make its primary value explicit: reducing repeated context and observing measured local Token usage.
