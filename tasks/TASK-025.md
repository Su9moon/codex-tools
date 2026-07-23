# TASK-025 — 补齐 save-tokens 可移植闭环并完成冷启动验收

Status: 待用户确认关闭
Started: 2026-07-24T05:59:11.2450214+08:00
Completed: unavailable
Duration minutes: unavailable
Outcome: 本地补齐可移植文件并通过脚本、链接和冷启动安装验证；待用户确认关闭
Priority: P0
Objective: 验证
Rework count: 0
Negative rating count: 0
Tokdash session IDs: 019f8eac-5d70-7de0-9655-819c2855f1b2
Tokdash start tokens: 99464689
Tokdash start cost: 53.569966
Tokdash start token events: 782
Tokdash end tokens: unavailable
Tokdash end cost: unavailable
Tokdash end token events: unavailable

## Objective details

补齐仓库中被 save-tokens 引用的自动化脚本、报告和状态查询能力，区分历史聚合数据与任务独占数据，并在干净目录完成“安装 Skill—建立任务—开始快照—查询状态—用户确认关闭—结束快照—生成报告”的冷启动验收。

## Scope

- 将 task-start、Tokdash session/snapshot/usage、验证脚本纳入可移植仓库结构。
- 统一 Skill 引用路径，确保新项目不依赖本机隐藏文件。
- 补齐 TASK-005 报告及已完成任务的索引/报告一致性检查。
- 增强 status.ps1：Git、活动任务、当前 Session、Tokdash 用量、任务增量和未关闭提醒。
- 为 TASK-001 至 TASK-003 标注历史聚合快照；不伪造独占 Token。
- 建立冷启动验收脚本或明确的手工验收清单。
- 补充中英文 README，说明用途、安装、目录结构、使用示例和发布边界。
- 提供安装/升级脚本，支持从 clone 后安装或更新 Skill 与配套文件。
- 将 templates/task.md、templates/task-report.md 和必要的工作流文件纳入远程仓库。
- 统一根目录 scripts 与 skills/save-tokens/scripts 的路径约定，避免跨电脑调用失败。
- 增加 Tokdash 未运行、API 不可用、权限不足时的明确降级提示。
- 建立干净项目样例、模拟 Tokdash 响应和自动/半自动冷启动验收夹具。
- 为历史任务增加 legacy、aggregate、unavailable 的兼容与迁移规则。
- 将报告生成区分为自动草稿和用户确认后的正式收尾，补齐变更、测试、commit 和下一步字段。
- 在仓库文档中固定 Git 发布规则：本地检查和 commit 可先做，push 必须用户明确确认。

## Acceptance checks

- 在干净目录只使用仓库内容即可完成 Skill 安装和任务生命周期演练。
- task-start/task-close/状态查询脚本可执行，缺失依赖时给出明确错误。
- 任务详情、TASKS.md、报告三者状态一致；不一致时失败而非静默成功。
- 历史聚合用量明确标为 unavailable 或 aggregate，不当作任务独占消耗。
- 只完成本地验证和本地 commit；Git push 必须另行获得用户确认。
- GitHub clone 后可按照 README 独立重建 Skill 工作流，不依赖本机隐藏目录或未跟踪文件。
- 安装、升级、冷启动和 Tokdash 降级路径均有可重复验证结果。

## Verification result

- PowerShell syntax: passed for install and status scripts.
- Task links: 24 valid task detail links.
- Cold-start install: passed in a clean temporary directory; Skill and snapshot helper copied successfully.
- Git push: not performed; requires explicit user confirmation.

## Baseline

Git state: main synchronized with origin before this task; workspace contains unrelated uncommitted historical records and article assets, which must not be silently staged.

## Blockers / open questions

- 需要决定脚本是放在根目录 scripts，还是统一放到 skills/save-tokens/scripts，并同步文档路径。
- 需要定义冷启动测试是否允许使用本机已运行 Tokdash，还是必须验证“Tokdash 不可用时的明确降级提示”。

