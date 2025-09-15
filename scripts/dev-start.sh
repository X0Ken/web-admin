#!/bin/bash

# Web Admin 开发环境启动脚本
# 此脚本用于快速启动开发环境

set -e

echo "🚀 启动 Web Admin 开发环境..."

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ 错误: Docker 未运行，请先启动 Docker"
    exit 1
fi

# 检查 Docker Compose 是否可用
if ! command -v docker-compose > /dev/null 2>&1; then
    echo "❌ 错误: docker-compose 未安装"
    exit 1
fi

# 进入项目根目录
cd "$(dirname "$0")/.."

# 检查环境变量文件
if [ ! -f .env ]; then
    echo "📋 创建环境变量文件..."
    if [ -f env.example ]; then
        cp env.example .env
        echo "✅ 已从 env.example 创建 .env 文件"
        echo "💡 提示: 你可以编辑 .env 文件来自定义配置"
    else
        echo "⚠️  警告: 未找到 env.example 文件，将使用默认配置"
    fi
fi

# 停止可能正在运行的服务
echo "🛑 停止现有服务..."
docker-compose down > /dev/null 2>&1 || true

# 拉取最新镜像
echo "📦 拉取依赖镜像..."
docker-compose pull postgres

# 构建并启动服务
echo "🔨 构建并启动服务..."
docker-compose up -d --build

# 等待服务启动
echo "⏳ 等待服务启动..."

# 等待数据库准备就绪
echo "🗄️  等待数据库启动..."
timeout=60
counter=0
while ! docker-compose exec -T postgres pg_isready -U postgres -d rust_web_admin > /dev/null 2>&1; do
    sleep 2
    counter=$((counter + 2))
    if [ $counter -ge $timeout ]; then
        echo "❌ 数据库启动超时"
        docker-compose logs postgres
        exit 1
    fi
    echo -n "."
done
echo "✅ 数据库已就绪"

# 等待后端服务启动
echo "🔧 等待后端服务启动..."
timeout=120
counter=0
while ! curl -s -f http://localhost:3000/health > /dev/null 2>&1; do
    sleep 3
    counter=$((counter + 3))
    if [ $counter -ge $timeout ]; then
        echo "❌ 后端服务启动超时"
        docker-compose logs backend
        exit 1
    fi
    echo -n "."
done
echo "✅ 后端服务已就绪"

# 等待前端服务启动
echo "🌐 等待前端服务启动..."
timeout=60
counter=0
while ! curl -s -f http://localhost/health > /dev/null 2>&1; do
    sleep 2
    counter=$((counter + 2))
    if [ $counter -ge $timeout ]; then
        echo "❌ 前端服务启动超时"
        docker-compose logs frontend
        exit 1
    fi
    echo -n "."
done
echo "✅ 前端服务已就绪"

echo ""
echo "🎉 开发环境启动成功！"
echo ""
echo "📱 应用访问地址:"
echo "   前端应用: http://localhost"
echo "   后端 API: http://localhost:3000"
echo "   数据库管理: http://localhost:5050 (可选)"
echo ""
echo "🔑 默认登录账户:"
echo "   用户名: admin"
echo "   密码: admin123"
echo ""
echo "🛠️  常用命令:"
echo "   查看日志: docker-compose logs -f"
echo "   停止服务: docker-compose down"
echo "   重启服务: docker-compose restart"
echo ""
echo "📖 更多信息请查看: docs/deployment/quick-start.md"
