# codex-tools / save-tokens

Lightweight, file-backed task tracking for Codex projects with local Tokdash usage snapshots.

## What it provides

- Project context, task index, task detail, reports, and decision records.
- Start/end snapshots for measured Tokens, cost, and Token events.
- User-confirmed task close with synchronized detail, index, and report records.
- Tokdash session and project linkage without reparsing sessions in ordinary recovery.

## Install

Run `scripts/install-save-tokens.ps1` from this repository. It copies the Skill to the local Codex skills directory and reports whether the local Tokdash API is reachable. The script does not overwrite existing project records.

## Use

1. Copy the templates and create a task detail under `tasks/`.
2. Run `scripts/task-start.ps1 -TaskFile <path>` when execution is authorized.
3. Use `scripts/status.ps1 -ProjectRoot <project>` for a compact status.
4. Report the result and obtain user confirmation before running `scripts/task-close.ps1 -UserConfirmed`.

Missing historical values remain `unavailable`; aggregate snapshots are never treated as task-exclusive usage. Git commits may be made locally, but `git push` requires explicit user confirmation.

## Layout

`skills/save-tokens/` contains the Skill and Tokdash helpers. Root `scripts/` contains project lifecycle and validation helpers. `templates/` contains task and report templates. `tasks/` is active detail; `reports/` is completed evidence.

## License

See `LICENSE` in the related Tokdash repository for Tokdash licensing. Project workflow files are provided for personal use.
