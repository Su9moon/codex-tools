---
name: save-tokens
description: 以轻量、文件化方式管理 Git 项目任务并通过 Tokdash 观察真实用量，从而减少重复上下文和 Token 消耗；Use for lightweight, file-backed Git task workflows and local Tokdash usage snapshots that reduce repeated context loading and token use.
---

# 节省 Token / Save tokens

以项目文件而非聊天记录保存可恢复状态。优先使用确定性脚本取得 Git 事实，并保持长期文档精简。

Keep recoverable project state in files, not chat history. Prefer deterministic Git facts and concise durable records.

## 轻量规则 / Lightweight rules

- 只读取当前动作必需的文件；默认不加载全部报告或完整 Git 历史。 Read only files needed for the action; never load all reports or the full Git log by default.
- 以 `PROJECT_CONTEXT.md`、`TASKS.md`、`DECISION_LOG.md` 和 Git 为事实来源，禁止重复抄写。 Treat them and Git as sources of truth; do not duplicate their contents.
- `TASKS.md` 仅作索引；已完成任务详情归档到 `reports/TASK-xxx.md`。 Keep the task index small; archive completed-task detail in reports.
- 仅记录改变范围、架构、约束或关键取舍的决策。 Record only scope, architecture, constraint, or material trade-off decisions.
- 用项目根目录的 `scripts/status.ps1` 获取 Git 状态，不依赖上一轮对话推断。 Get Git state from the script, never from a prior turn.
- 不估算 Token；仅写入运行时或集成工具提供的实测值，否则记为 `unavailable`。 Do not estimate tokens; record measured values only.
- 只在显式查询、`/status` 或任务收尾时访问 Tokdash；使用其已索引的本地 API，不重复解析 Codex 会话。 Query indexed local Tokdash only when needed; do not reparse sessions.
- 新工单先运行 `scripts/task-start.ps1 -TaskFile ...`；执行完成后只汇报并请求用户认可。只有用户明确认可关闭时，才运行 `scripts/task-close.ps1 -UserConfirmed`，形成最终结束快照、计算用时/Token/成本并关闭工单。未认可不得结束快照或改为已完成。历史缺失值保持 `unavailable`。
- 编码前确认闸门：工单可以先建立、讨论和拆分，但没有用户明确确认“开始执行/开始编码”之前，不得修改代码、运行实现脚本或标记为进行中。用户确认后才运行 `task-start.ps1` 并进入编码阶段。
- 建立工单即形成开始快照：用户明确要求“建立工单”时，立即记录开始时间、会话 ID、开始 Token、开始成本和开始 `token_events`。建立前先列出并提醒所有未关闭工单；旧工单未关闭时仍可建立新工单，但必须明确提示待关闭项。开始快照不等于开始编码，编码仍需用户另行确认。

## 文件约定 / File convention

| 文件 / File | 何时读取 / Read for |
| --- | --- |
| `PROJECT_CONTEXT.md` | 项目目的、约束、架构 / purpose, constraints, architecture |
| `TASKS.md` | 任务索引与当前任务 / task index and active task |
| `DECISION_LOG.md` | 影响当前工作的决策 / relevant decisions |
| `CHANGELOG.md` | 面向使用者的已完成变化 / user-visible changes |
| `reports/TASK-xxx.md` | 单个已完成任务 / one completed task |
| `logs/token-usage.jsonl` | 追加式用量记录 / append-only usage records |

## 开始或续接任务 / Start or continue

1. 在项目根目录运行 `scripts/status.ps1`。 Run the status script at the project root.
2. 读取 `PROJECT_CONTEXT.md` 和 `TASKS.md` 的活动行；仅在会影响任务时读取 `DECISION_LOG.md`。 Read project context and the active task row; read decisions only when relevant.
3. 新任务使用下一个零填充编号，在 `TASKS.md` 添加一行，并用 `templates/task.md` 创建 `tasks/TASK-xxx.md`。 For a new task, allocate the next ID and create its compact record.
4. 运行 `scripts/tokdash-current-session.ps1`；若返回 ID，写入 `Tokdash session IDs:`，再运行 `tokdash-session-snapshot.ps1` 并记录开始 Token/成本。 Record the task ID and start snapshot when available.
5. 改文件前说明任务范围与尚未解决的重要选择。 State scope and unresolved material choices before changes.

每个新工单必须记录 `Started`、`Completed`、`Duration minutes`、`Outcome`、`Tokdash session IDs` 及开始/结束快照。`Rework count` 为可选字段，仅在用户明确要求重做、修复或指出结果错误时记录；普通连续对话不判断。`Negative rating count` 为可选字段，仅在用户明确差评、辱骂或表示结果不可接受时记录；不得根据普通质疑推断。历史工单缺失字段时标记为 `unavailable`，不得补造数据。

工单 `Objective` 使用固定工程动作词：`分析`、`编写`、`讨论`、`修复`、`验证`。根据用户请求自动选择最主要的动作；只有无法判断时才向用户询问一次。用户未确认前不要创建正式工单，暂记为待确认。不要为判断目标分析每一轮对话。

Every new task must record `Started`, `Completed`, `Duration minutes`, `Outcome`, `Tokdash session IDs`, and start/end snapshots. `Rework count` is optional and is recorded only when the user explicitly asks for a redo/fix or reports an incorrect result; do not classify ordinary continuation turns. `Negative rating count` is optional and is recorded only for an explicit bad rating, insult, or unacceptable-result statement; do not infer it from ordinary questions. Mark missing historical fields as `unavailable`; never invent values.

## `/status`

运行 `scripts/status.ps1`，只读取活动任务记录；若 Tokdash 可用，运行 `scripts/tokdash-usage.ps1 -Period today` 并返回其简要统计。输出：活动任务、Git 摘要、阻塞项、下一步和最新可用 Token 记录。不要扫描历史报告或重写历史。

Run the status script and only the active task record. If available, query compact Tokdash usage. Return active task, Git summary, blockers, next action, and latest token record; do not scan archived reports or rewrite history.

## 关闭任务 / Close a task

1. 运行相关测试，记录准确命令和结果。 Run relevant tests; capture exact commands/results.
2. 运行 `scripts/status.ps1`，按需检查真实改动文件和 diff。 Inspect actual changed files and diff as needed.
3. 从 `templates/task-report.md` 创建 `reports/TASK-xxx.md`。仅在 commit 已存在时写入哈希；绝不自动 commit。 Create a report; include a commit only after it exists; never commit automatically.
4. 更新任务行；仅在对用户可见时更新 `CHANGELOG.md`，仅在符合条件时更新决策日志。 Update indexes selectively.
5. 对关联 ID 运行 `tokdash-session-snapshot.ps1` 并记录结束 Token/成本；页面以结束减开始显示工单消耗。 Record end snapshots; the page uses end-minus-start deltas.

## Token 日志结构 / Token log schema

每行一个 JSON 对象，字段：`timestamp`、`project`、`task_id`、`session_id`、`model`、`input_tokens`、`output_tokens`、`total_tokens`、`cost`、`source`。不可用数值写 `null`，并注明来源如 `codex-runtime` 或 `tokdash`。

Use one JSON object per line with those fields. Use `null` for unavailable values and identify the source.

## 模板 / Templates

使用项目根目录 `templates/`；仅在创建对应产物时加载模板。 Use project-level templates and load each only when creating its artifact.

