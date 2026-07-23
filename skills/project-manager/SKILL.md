---
name: project-manager
description: Run a lightweight, file-backed workflow for starting, continuing, checking status of, and closing development tasks in a Git project. Use when Codex needs to create a task record, recover project context with `/status`, capture a durable decision, generate a task report, or keep project documentation and Git evidence aligned while minimizing token use.
---

# Project manager

Keep project work recoverable without treating chat history as memory. Prefer deterministic scripts for Git facts and concise files for durable context.

## Lightweight rules

- Read only files required by the action. Never load every report or the full Git log by default.
- Treat `PROJECT_CONTEXT.md`, `TASKS.md`, `DECISION_LOG.md`, and Git as sources of truth; do not duplicate their contents.
- Keep `TASKS.md` as an index. Store completed-task detail in `reports/TASK-xxx.md`.
- Record only decisions that change scope, architecture, constraints, or a meaningful trade-off.
- Obtain Git state with `scripts/status.ps1`; never infer it from a previous turn.
- Do not estimate token usage. Append only values exposed by the runtime or an integrated tool; otherwise record `unavailable`.

## File convention

| File | Read for |
| --- | --- |
| `PROJECT_CONTEXT.md` | project purpose, constraints, architecture |
| `TASKS.md` | task index and current task |
| `DECISION_LOG.md` | a decision affecting current work |
| `CHANGELOG.md` | user-facing completed changes |
| `reports/TASK-xxx.md` | one completed task only |
| `logs/token-usage.jsonl` | append-only usage records |

## Start or continue a task

1. Run `scripts/status.ps1` from the project root.
2. Read `PROJECT_CONTEXT.md` and the active row in `TASKS.md`. Read `DECISION_LOG.md` only if it can affect the task.
3. For a new task, allocate the next zero-padded identifier, add one concise row to `TASKS.md`, and create `tasks/TASK-xxx.md` from `templates/task.md`.
4. Record the objective, start time, baseline Git state, acceptance checks, and only blocking questions.
5. Before modifying files, state the task scope and unresolved material choices.

## `/status`

Run `scripts/status.ps1` and read only the active task record. Return: active task, Git summary, blockers, next action, and latest available token record. Do not rewrite history or scan archived reports.

## Close a task

1. Run relevant tests and capture exact commands/results.
2. Run `scripts/status.ps1`; inspect the actual changed-file list and diff as needed.
3. Create `reports/TASK-xxx.md` from `templates/task-report.md`. Include a commit hash only after a commit exists; never commit automatically.
4. Update the task row, `CHANGELOG.md` where user-visible, and `DECISION_LOG.md` only for a qualifying decision.
5. Append a JSON line to `logs/token-usage.jsonl` only when measured usage is available.

## Token log schema

Use one JSON object per line with `timestamp`, `project`, `task_id`, `session_id`, `model`, `input_tokens`, `output_tokens`, `total_tokens`, `cost`, and `source`. Use `null` for unavailable numeric values and identify the source, such as `codex-runtime` or `tokdash`.

## Templates

Use the project-level `templates/` directory. Do not load a template until creating its corresponding artifact.
