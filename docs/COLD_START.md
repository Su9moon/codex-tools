# Cold-start acceptance

1. Clone the repository into a clean directory.
2. Run `scripts/install-save-tokens.ps1`.
3. Copy `templates/task.md` to a new `tasks/TASK-xxx.md` and add its row to `TASKS.md`.
4. Run `scripts/task-start.ps1 -TaskFile ...` and verify measured start fields or `unavailable`.
5. Run `scripts/status.ps1 -ProjectRoot ...`; verify Git, active task, Session, and snapshot output.
6. Complete the task, report the result, obtain explicit user confirmation, then run `scripts/task-close.ps1 -UserConfirmed`.
7. Run `scripts/validate-task.ps1` and `scripts/validate-task-links.ps1`.
8. Confirm task detail, index, and report show the same final status.

If Tokdash is unavailable, the lifecycle remains usable with `unavailable` snapshots; the installer and status command must state that limitation rather than inventing values.
