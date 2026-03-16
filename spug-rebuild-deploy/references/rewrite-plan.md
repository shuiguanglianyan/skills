# Spug 重写计划模板（MVP 优先）

> 若用户给出了目标仓库（例如 `git@github.com:shuiguanglianyan/skills.git`），请在计划开头补充：
>
> - 目标仓库与分支：`main` / `feat/spug-mvp`（示例）
> - 目录建议：`backend/`、`frontend/`、`deploy/`、`docs/`
> - 提交策略：按“鉴权、主机、执行、审计、部署”拆分 5~8 个可回滚提交

## 1. 功能映射表

| 领域 | 子能力 | MVP 是否实现 | 说明 |
|---|---|---|---|
| IAM | 登录/登出、JWT、RBAC | 是 | 仅保留基础角色（admin/operator/viewer） |
| 资源管理 | 主机、分组、凭据 | 是 | 凭据先支持 SSH Key |
| 任务执行 | 即时命令、执行记录 | 是 | 异步执行，日志落库 |
| 发布管理 | 发布单、回滚 | 部分 | 第一版仅保留脚本发布 |
| 审计通知 | 审计日志、Webhook | 部分 | 先做审计日志 |

## 2. 数据模型最小集

- users(id, username, password_hash, role, created_at)
- hosts(id, name, ip, port, auth_type, credential_ref, created_at)
- tasks(id, name, command, creator_id, created_at)
- task_runs(id, task_id, host_id, status, output, started_at, ended_at)
- audit_logs(id, actor_id, action, target_type, target_id, detail, created_at)

## 3. API 最小集

- `POST /api/auth/login`
- `GET /api/auth/me`
- `POST /api/hosts`
- `GET /api/hosts`
- `POST /api/tasks/run`
- `GET /api/task-runs/{id}`
- `GET /api/audit-logs`
- `GET /health`

## 4. 里程碑建议

1. Day 1-2：鉴权、用户、基础项目结构
2. Day 3-4：主机管理 + SSH 执行链路
3. Day 5：日志与审计
4. Day 6：前端页面打通
5. Day 7：容器化与部署验收

## 4.1 仓库落位建议（适用于指定 Git 仓库）

- `backend/app/`：API、模型、迁移、任务队列
- `frontend/src/`：登录、主机、任务、审计页面
- `deploy/docker-compose.yml`：单机部署编排
- `deploy/.env.example`：环境变量模板
- `docs/mvp-scope.md`：当前范围与后续增量清单

## 5. 风险与应对

- SSH 兼容性问题：先限制 OpenSSH + key 登录。
- 命令执行阻塞：统一进入 worker 异步执行。
- 日志过大：限制单次输出长度并分页。
