---
name: spug-rebuild-deploy
description: 用于在用户要求“重写/二次开发/精简替代 Spug（openspug/spug）并快速部署”时，提供从需求裁剪、技术选型、代码骨架生成、容器化到一键部署验收的标准流程与模板。
---

# Spug Rebuild Deploy

## Overview

按“先可用、再完善”的策略重写 Spug：优先交付可部署的最小可用版本（MVP），并提供可直接执行的部署步骤与验收清单。

## Workflow

### 1) 明确目标与边界

先和用户确认 5 件事：

1. 是否要 **100% 功能对齐**（通常不建议第一版就做）
2. 第一版必须保留哪些能力（建议仅保留：主机管理、任务执行、发布记录、基础权限）
3. 部署环境（单机 Docker / Kubernetes / 离线环境）
4. 成功标准（如：30 分钟内可部署、可登录、可执行命令、可回滚）
5. 是否指定了“参考仓库/目标仓库”（例如 `git@github.com:shuiguanglianyan/skills.git`）

若用户未说明，默认选择：

- 架构：`backend + worker + frontend + mysql + redis`
- 部署：单机 `docker compose`
- 版本策略：MVP（20% 核心能力）

若用户给出 Git 仓库地址，默认要求：

- 在方案和命令中显式使用该仓库地址；
- 输出“基于该仓库的目录落位建议与分支策略”；
- 部署步骤中优先给出 `git clone + docker compose` 的最短路径。

### 2) 生成“重写而非照搬”的实施方案

按下列模块拆分并建立映射：

- IAM（用户/角色/Token）
- 资源域（主机、分组、凭据）
- 执行域（任务模板、执行记录、日志）
- 发布域（应用、环境、发布单、回滚）
- 平台域（审计、通知、系统设置）

使用 `references/rewrite-plan.md` 的模板给出：

- 每个模块第一版是否实现
- API 契约（REST）
- 数据模型（最小字段集）
- 风险与替代策略

### 3) 搭建最小工程骨架

建议默认技术栈（可替换）：

- Backend: FastAPI + SQLAlchemy + Alembic + Redis
- Worker: Celery
- Frontend: Vue3 + Vite + Element Plus
- DB: MySQL 8
- Gateway: Nginx

要求：

- 所有配置来自环境变量
- 提供 `docker-compose.yml`
- 提供初始化命令（迁移 + 创建管理员）
- 提供 `health` 接口用于探活

### 4) 优先做“可部署闭环”

第一轮开发必须打通：

1. 登录
2. 新建主机
3. 执行一条远程命令
4. 查看执行日志
5. 保存审计记录

缺失功能以“占位 API + 明确 TODO”交付，避免阻塞上线。

### 5) 部署与验收

优先使用 `assets/docker-compose.minimal.yml`。

执行步骤见 `references/deploy-steps.md`，并按以下验收：

- 容器全部 `healthy` 或 `running`
- 前端可访问登录页
- 登录后可执行一次命令并看到日志
- 数据库存在初始管理员

## Execution rules

- 对“大而全重写”请求，先降级为“两阶段计划”：`MVP -> 增量补齐`。
- 每次输出都包含：
  - 当前范围（做什么/不做什么）
  - 部署命令（可复制）
  - 回滚方案（至少一个）
  - 若有指定仓库：仓库地址、分支名、提交粒度建议
- 若用户只要“尽快跑起来”，优先交付 Docker Compose 单机方案。

## Resources

- `references/rewrite-plan.md`：模块拆解与优先级模板。
- `references/deploy-steps.md`：最简部署、验证、排障、回滚步骤。
- `assets/docker-compose.minimal.yml`：MVP 部署模板。
- `scripts/render_env.sh`：生成 `.env` 与部署前检查。
