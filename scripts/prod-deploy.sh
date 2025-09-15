#!/bin/bash

# Web Admin 生产环境部署脚本
# 用于生产环境的自动化部署

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 配置变量
PROJECT_NAME="web-admin"
COMPOSE_FILE="docker-compose.prod.yml"
BACKUP_DIR="backups"
LOG_FILE="deploy.log"

# 进入项目根目录
cd "$(dirname "$0")/.."

# 记录日志
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 显示帮助信息
show_help() {
    echo "Web Admin 生产环境部署工具"
    echo ""
    echo "用法: $0 [命令] [选项]"
    echo ""
    echo "命令:"
    echo "  deploy             - 部署到生产环境"
    echo "  update             - 更新应用 (零停机时间)"
    echo "  rollback [version] - 回滚到指定版本"
    echo "  status             - 显示服务状态"
    echo "  logs [service]     - 显示服务日志"
    echo "  backup             - 备份数据库"
    echo "  scale <service> <replicas> - 扩缩容服务"
    echo "  health             - 健康检查"
    echo "  help               - 显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 deploy                    # 初次部署"
    echo "  $0 update                    # 更新应用"
    echo "  $0 rollback v1.0.0           # 回滚到指定版本"
    echo "  $0 scale backend 3           # 扩展后端服务到3个实例"
}

# 检查环境
check_environment() {
    print_info "检查部署环境..."

    # 检查 Docker
    if ! command -v docker > /dev/null 2>&1; then
        print_error "Docker 未安装"
        exit 1
    fi

    # 检查 Docker Compose
    if ! command -v docker-compose > /dev/null 2>&1; then
        print_error "Docker Compose 未安装"
        exit 1
    fi

    # 检查生产环境配置文件
    if [ ! -f "$COMPOSE_FILE" ]; then
        print_error "生产环境配置文件不存在: $COMPOSE_FILE"
        exit 1
    fi

    # 检查环境变量文件
    if [ ! -f .env ]; then
        print_error "环境变量文件 .env 不存在"
        print_info "请复制 env.example 为 .env 并配置生产环境变量"
        exit 1
    fi

    # 检查必要的环境变量
    if ! grep -q "JWT_SECRET" .env || ! grep -q "POSTGRES_PASSWORD" .env; then
        print_error "缺少必要的环境变量配置"
        print_info "请确保 .env 文件包含 JWT_SECRET 和 POSTGRES_PASSWORD"
        exit 1
    fi

    print_success "环境检查通过"
}

# 备份数据库
backup_database() {
    local backup_file="backup_$(date +%Y%m%d_%H%M%S).sql"

    print_info "备份数据库..."

    # 确保备份目录存在
    mkdir -p "$BACKUP_DIR"

    # 检查数据库是否运行
    if docker-compose -f "$COMPOSE_FILE" exec -T postgres pg_isready -U postgres > /dev/null 2>&1; then
        if docker-compose -f "$COMPOSE_FILE" exec -T postgres pg_dump -U postgres rust_web_admin > "$BACKUP_DIR/$backup_file"; then
            print_success "数据库备份完成: $BACKUP_DIR/$backup_file"
            log "Database backup created: $backup_file"
        else
            print_error "数据库备份失败"
            exit 1
        fi
    else
        print_warning "数据库未运行，跳过备份"
    fi
}

# 部署应用
deploy() {
    print_info "开始生产环境部署..."
    log "Starting production deployment"

    check_environment

    # 创建备份
    backup_database

    # 拉取最新镜像
    print_info "拉取最新镜像..."
    docker-compose -f "$COMPOSE_FILE" pull

    # 构建镜像
    print_info "构建应用镜像..."
    docker-compose -f "$COMPOSE_FILE" build

    # 启动服务
    print_info "启动服务..."
    docker-compose -f "$COMPOSE_FILE" up -d

    # 等待服务启动
    wait_for_services

    # 健康检查
    if health_check; then
        print_success "部署完成！"
        log "Deployment completed successfully"
        show_service_info
    else
        print_error "部署失败，服务健康检查未通过"
        log "Deployment failed - health check failed"
        exit 1
    fi
}

# 更新应用 (零停机时间)
update() {
    print_info "开始应用更新 (零停机时间)..."
    log "Starting zero-downtime update"

    check_environment

    # 创建备份
    backup_database

    # 拉取最新镜像
    print_info "拉取最新镜像..."
    docker-compose -f "$COMPOSE_FILE" pull

    # 重新构建镜像
    print_info "重新构建镜像..."
    docker-compose -f "$COMPOSE_FILE" build

    # 滚动更新服务
    print_info "滚动更新服务..."
    docker-compose -f "$COMPOSE_FILE" up -d --force-recreate --no-deps backend frontend

    # 等待服务启动
    wait_for_services

    # 健康检查
    if health_check; then
        print_success "更新完成！"
        log "Update completed successfully"

        # 清理旧镜像
        print_info "清理未使用的镜像..."
        docker image prune -f
    else
        print_error "更新失败，请检查服务状态"
        log "Update failed - health check failed"
        exit 1
    fi
}

# 回滚
rollback() {
    local version=$1

    if [ -z "$version" ]; then
        print_error "请指定回滚版本"
        echo "用法: $0 rollback <version>"
        exit 1
    fi

    print_warning "准备回滚到版本: $version"
    read -p "确定要继续吗? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "回滚操作已取消"
        exit 0
    fi

    print_info "开始回滚到版本: $version"
    log "Starting rollback to version: $version"

    # 这里需要根据实际的版本管理策略实现
    # 例如从镜像仓库拉取指定版本的镜像
    print_warning "回滚功能需要配合 CI/CD 和镜像版本管理实现"
    print_info "请手动指定镜像版本并重新部署"
}

# 等待服务启动
wait_for_services() {
    print_info "等待服务启动..."

    local timeout=300  # 5分钟超时
    local counter=0

    # 等待数据库
    print_info "等待数据库..."
    while ! docker-compose -f "$COMPOSE_FILE" exec -T postgres pg_isready -U postgres > /dev/null 2>&1; do
        sleep 5
        counter=$((counter + 5))
        if [ $counter -ge $timeout ]; then
            print_error "数据库启动超时"
            return 1
        fi
        echo -n "."
    done
    print_success "数据库已就绪"

    # 等待后端服务
    print_info "等待后端服务..."
    counter=0
    while ! curl -s -f http://localhost:3000/health > /dev/null 2>&1; do
        sleep 5
        counter=$((counter + 5))
        if [ $counter -ge $timeout ]; then
            print_error "后端服务启动超时"
            return 1
        fi
        echo -n "."
    done
    print_success "后端服务已就绪"

    # 等待前端服务
    print_info "等待前端服务..."
    counter=0
    while ! curl -s -f http://localhost/health > /dev/null 2>&1; do
        sleep 5
        counter=$((counter + 5))
        if [ $counter -ge $timeout ]; then
            print_error "前端服务启动超时"
            return 1
        fi
        echo -n "."
    done
    print_success "前端服务已就绪"
}

# 健康检查
health_check() {
    print_info "执行健康检查..."

    local healthy=true

    # 检查所有服务状态
    local services=$(docker-compose -f "$COMPOSE_FILE" ps --services)
    for service in $services; do
        local status=$(docker-compose -f "$COMPOSE_FILE" ps -q "$service" | xargs docker inspect --format='{{.State.Health.Status}}' 2>/dev/null || echo "unknown")

        if [ "$status" = "healthy" ] || [ "$status" = "unknown" ]; then
            print_success "$service: 健康"
        else
            print_error "$service: 不健康 (状态: $status)"
            healthy=false
        fi
    done

    # 检查API响应
    if curl -s -f http://localhost:3000/health > /dev/null 2>&1; then
        print_success "后端API: 响应正常"
    else
        print_error "后端API: 无法访问"
        healthy=false
    fi

    if curl -s -f http://localhost/health > /dev/null 2>&1; then
        print_success "前端应用: 响应正常"
    else
        print_error "前端应用: 无法访问"
        healthy=false
    fi

    if [ "$healthy" = true ]; then
        print_success "所有服务健康检查通过"
        return 0
    else
        print_error "健康检查失败"
        return 1
    fi
}

# 显示服务状态
show_status() {
    print_info "服务状态:"
    docker-compose -f "$COMPOSE_FILE" ps

    echo ""
    print_info "资源使用情况:"
    docker-compose -f "$COMPOSE_FILE" top
}

# 显示日志
show_logs() {
    local service=$1

    if [ -n "$service" ]; then
        print_info "显示 $service 服务日志:"
        docker-compose -f "$COMPOSE_FILE" logs -f --tail=100 "$service"
    else
        print_info "显示所有服务日志:"
        docker-compose -f "$COMPOSE_FILE" logs -f --tail=100
    fi
}

# 扩缩容服务
scale_service() {
    local service=$1
    local replicas=$2

    if [ -z "$service" ] || [ -z "$replicas" ]; then
        print_error "请指定服务名称和副本数"
        echo "用法: $0 scale <service> <replicas>"
        exit 1
    fi

    print_info "扩缩容 $service 服务到 $replicas 个实例..."
    docker-compose -f "$COMPOSE_FILE" up -d --scale "$service=$replicas"

    print_success "扩缩容完成"
    show_status
}

# 显示服务信息
show_service_info() {
    echo ""
    print_success "=== 服务信息 ==="
    echo "前端应用: http://localhost"
    echo "后端API: http://localhost:3000"
    echo "数据库: localhost:5432"
    echo ""
    echo "默认登录账户:"
    echo "  用户名: admin"
    echo "  密码: admin123"
    echo ""
    print_warning "请立即修改默认密码！"
}

# 主函数
main() {
    local command=${1:-help}

    case $command in
        deploy)
            deploy
            ;;
        update)
            update
            ;;
        rollback)
            rollback "$2"
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs "$2"
            ;;
        backup)
            backup_database
            ;;
        scale)
            scale_service "$2" "$3"
            ;;
        health)
            health_check
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "未知命令: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"
