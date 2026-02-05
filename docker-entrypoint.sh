#!/bin/sh
set -eu

# 1) Railway 会注入 PORT；本地没有的话默认 8080
PORT="${PORT:-8080}"

# 2) 你的持久化目录（默认放在你挂载的 volume 下）
OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-/home/node/data/.openclaw}"
OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-/home/node/data/workspace}"

# 3) 创建目录（如果还不存在）
mkdir -p "$OPENCLAW_STATE_DIR" "$OPENCLAW_WORKSPACE_DIR"

# 4) 修权限：把 /home/node/data 整个交给 node 用户写
#    这一步是解决 Permission denied 的关键
chown -R node:node /home/node/data || true

# 5) 以 node 身份启动（安全），并绑定到外网可访问的地址
exec gosu node node dist/index.js gateway --allow-unconfigured --bind lan --port "$PORT"
