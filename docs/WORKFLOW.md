# Lightweight workflow

1. Start or continue work with `$project-manager`.
2. Run `scripts/status.ps1` and read only the active task record plus the needed project context.
3. Keep task detail in `tasks/` while work is active; keep the task index to one row per task.
4. At completion, archive evidence in `reports/TASK-xxx.md`; update the index and changelog.
5. Add a token log row only from a measured runtime or Tokdash value.

The workflow deliberately avoids loading completed reports, full Git history, or token data during ordinary task recovery.
