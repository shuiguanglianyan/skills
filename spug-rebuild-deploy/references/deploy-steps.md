# 最简部署步骤（Docker Compose）

## 0) 前置条件

- Linux 服务器（2C4G 起步）
- 已安装 Docker 与 Docker Compose Plugin
- 已开放端口：`80`（或你自定义的 Web 端口）

## 1) 准备目录

```bash
mkdir -p /opt/spug-rebuild && cd /opt/spug-rebuild
```

## 2) 放置编排文件与环境变量

```bash
cp docker-compose.minimal.yml docker-compose.yml
cat > .env <<'EOT'
MYSQL_ROOT_PASSWORD=change_me_root
MYSQL_DATABASE=spug
MYSQL_USER=spug
MYSQL_PASSWORD=change_me_db
REDIS_PASSWORD=change_me_redis
APP_SECRET_KEY=change_me_secret
ADMIN_USERNAME=admin
ADMIN_PASSWORD=change_me_admin
WEB_PORT=80
EOT
```

## 3) 启动服务

```bash
docker compose pull
docker compose up -d
```

## 4) 初始化（如镜像未自动初始化）

```bash
docker compose exec backend alembic upgrade head
docker compose exec backend python -m app.bootstrap --admin "$ADMIN_USERNAME" --password "$ADMIN_PASSWORD"
```

## 5) 验证

```bash
docker compose ps
curl -f http://127.0.0.1:${WEB_PORT}/health
```

浏览器访问 `http://<服务器IP>:${WEB_PORT}`，用管理员账号登录。

## 6) 常见排障

- 后端连不上数据库：检查 `MYSQL_*` 变量与数据库容器健康状态。
- 前端 502：检查 `backend` 容器是否启动且 `/health` 正常。
- 执行任务失败：检查 worker 与 redis 连接。

## 7) 回滚

```bash
docker compose down
# 切换到上一个镜像 tag 后重新启动
# docker compose up -d
```
