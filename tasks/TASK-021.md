# TASK-021 — 统一用户目标工单、内部步骤与整轮快照流程

Status: 已完成
Started: 2026-07-24T04:01:20.5874673+08:00
Completed: 2026-07-24T04:28:22.5318560+08:00
Duration minutes: 27
Outcome: completed
Priority: P0
Objective: 编写
Rework count: 0
Negative rating count: 0
Tokdash session IDs: 019f8eac-5d70-7de0-9655-819c2855f1b2
Tokdash start tokens: 74535267
Tokdash start cost: 38.5043815
Tokdash end tokens: 87176007
Tokdash end cost: 43.3434265

## Objective details

让一个用户开发目标对应一个工单；内部实现步骤记录在工单内，不单独创建任务编号；整轮开发只形成一次开始/结束快照；继续开发、优化和普通讨论沿用原工单，明确返工/修复时增加返工次数，新目标才新建工单。

## 执行步骤

- [x] 更新 save-tokens 的工单粒度规则
- [x] 更新任务模板，加入内部步骤和执行轮次
- [x] 标记 TASK-016 至 TASK-020 为历史内部步骤
- [x] 验证开始快照、状态和页面聚合口径
- [ ] 等待用户认可后执行结束快照并关闭

## Acceptance checks

- 一个用户目标只对应一个主工单。
- 内部步骤不单独进入主工单统计。
- 开始和结束快照在整轮开发边界形成。
- 没有结束快照不能标记为已完成。
- 页面按主工单展示 Token、成本、用时、返工和差评。






