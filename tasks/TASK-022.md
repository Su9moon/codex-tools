# TASK-022 — 在 Web 工单页面显示 Token events 差值

Status: 已完成
Started: 2026-07-24T04:19:10.1740821+08:00
Completed: 2026-07-24T04:36:46.1816477+08:00
Duration minutes: 18
Outcome: 已完成并发布到 Su9moon/Tokdash
Priority: P1
Objective: 编写
Rework count: 0
Negative rating count: 0
Tokdash session IDs: 019f8eac-5d70-7de0-9655-819c2855f1b2
Tokdash start tokens: 82182559
Tokdash start cost: 40.7869565
Tokdash start token events: 630
Tokdash end tokens: 87901308
Tokdash end cost: 43.628401
Tokdash end token events: 680

## Objective details

仅在 Web 工单列表增加 Token events 显示；按同一会话的开始/结束快照计算差值；不新增复杂执行轮次，不分析每轮对话。

## 执行步骤

- [ ] 快照脚本记录开始/结束 token_events
- [ ] 后端计算工单 token_events 差值
- [ ] Web 工单表增加 Token events 列
- [x] 验证缺失值显示 `-`、真实零值显示 `0`
- [x] 手动刷新清除项目缓存，不启用自动刷新

## Acceptance checks

- 页面只新增 Token events 显示，不改变现有 Token/成本口径。
- 差值来自同一会话的开始和结束快照。
- 没有快照显示 `-`，快照相同显示 `0`。
- 完成前不执行正式结束快照，等待用户认可。
- 手动刷新使用 `refresh=true` 清理项目/会话缓存，不需要重启 Tokdash。



