# Project context

## Purpose

Build a lightweight, file-backed toolkit that improves Codex development habits, reduces repeated context loading, and keeps project work auditable.

## First release constraints

- Build and validate `skills/project-manager` inside this repository before global installation.
- Use one immutable report per completed task under `reports/`.
- Keep token tracking to an append-only log schema; prioritize Tokdash integration later rather than building a meter now.
- Never make Git commits automatically.

## Current architecture

- `skills/project-manager`: workflow instructions and deterministic status helper.
- `templates/`: compact task and task-report templates.
- Root Markdown files: durable project context, index, decisions, and changelog.
