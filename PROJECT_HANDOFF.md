# Codex Tools 项目 Handoff

## 项目名称

Codex Tools

---

## 项目背景

随着 Codex 使用频率增加，需要建立一套项目化管理体系，用于管理多个 AI 辅助开发项目。

当前项目目录：

```
F:\OneDrive\4 mindcc迈思\00 codex mission
```

目标：

将 Codex 从单纯代码生成工具，升级为可管理的软件开发工作流。

---

# 项目目标

建立一个 Codex 项目管理工具体系：

核心能力：

1. 项目初始化管理
2. Task任务管理
3. Git版本管理
4. Token使用统计
5. 开发过程记录
6. 自动生成交付报告

---

# 设计原则

## 1. 项目文件作为长期记忆

不依赖聊天历史。

项目状态通过文件保存：

```
README.md
PROJECT_CONTEXT.md
TASKS.md
DECISION_LOG.md
CHANGELOG.md
```

Codex每次进入项目时读取这些文件。

---

## 2. Git作为代码状态记录

每个项目独立Git仓库。

推荐：

```
projects
 |
 ├── project-a
 │    └── .git
 |
 ├── project-b
 │    └── .git
```

不建议整个：

```
00 codex mission
```

作为单一Git仓库。

---

# 第一阶段目标

创建：

## project-manager Skill

目录：

```
codex-tools

├── skills
│   └── project-manager
│
├── templates
│
├── scripts
│
└── docs
```

---

# project-manager Skill 功能设计

## Task开始

自动完成：

- 创建任务记录
- 记录项目名称
- 记录任务目标
- 记录开始时间
- 检查Git状态
- 创建任务编号


示例：

```
TASK-001

项目：
xxx

任务：
新增招聘需求模块

开始时间：
2026-07-23
```

---

## Task结束

生成：

```
TASK_REPORT.md
```

包含：

```
任务名称：

完成内容：

修改文件：

Git Commit：

测试结果：

Token消耗：

Input Token:

Output Token:

总Token:

成本:

下一步:
```

---

# Token统计设计

参考：

Tokdash

目标：

统计：

- 项目Token
- Task Token
- Session Token
- 模型消耗
- 成本

第一阶段：

先实现日志结构。

不要急于接入复杂API。

---

# 后续扩展方向

## 自动项目初始化

执行：

```
create-project
```

自动生成：

```
README.md
PROJECT_CONTEXT.md
TASKS.md
```

---

## 自动Git流程

任务完成：

```
git status

git diff

git commit

生成报告
```

---

## Dashboard

后续建立：

AI开发成本看板：

统计：

项目：

- Token
- 时间
- Commit数量
- 修改文件
- AI成本

---

# 当前任务

Task 001:

## 创建 Codex 项目管理体系

当前阶段：

需求设计完成。

下一步：

1. 分析当前目录
2. 设计项目结构
3. 创建基础文件
4. 创建 project-manager skill

---

# Codex执行要求

当前阶段：

不要直接大规模编码。

先：

1. 阅读 PROJECT_HANDOFF.md
2. 分析需求
3. 提出技术方案
4. 等确认后再实现

---

# 当前环境

Codex目录：

```
F:\OneDrive\4 mindcc迈思\00 codex mission\codex-tools
```

模型：

gpt-5.6-terra

目标：

建立个人长期 Codex 开发管理体系。

注意：Token统计不自行开发，优先集成 GitHub 上已有工具 Tokdash。本项目重点开发 project-manager Skill 和项目管理流程。