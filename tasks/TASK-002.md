# TASK-002 — Deploy Tokdash and globally install project-manager

Status: Completed
Started: 2026-07-23

## Objective

Deploy a local, continuously running Tokdash instance and expose its compact usage data through the project-manager Skill installed for all Codex projects.

## Acceptance checks

- Tokdash runs as a user-level scheduled task and responds on localhost.
- The Skill queries the local API without reparsing sessions.
- The Skill is available in the global Codex Skills directory.

## Baseline

Git state: clean at `8b9edff`.

## Blockers / open questions

None.
