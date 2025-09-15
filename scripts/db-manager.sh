#!/bin/bash

# Web Admin 数据库管理脚本
# 用于数据库的备份、恢复、重置等操作

set -e

# 进入项目根目录
cd "$(dirname "$0")/.."

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

# 检查 Docker Compose 是否可用
check_docker() {
    if ! command -v docker-compose > /dev/null 2>&1; then
        print_error "docker-compose 未安装"
        exit 1
    fi

    if ! docker-compose ps > /dev/null 2>&1; then
        print_error "无法连接到 Docker Compose 服务"
        exit 1
    fi
}

# 检查数据库是否运行
check_database() {
    if ! docker-compose exec -T postgres pg_isready -U postgres -d rust_web_admin > /dev/null 2>&1; then
        print_error "数据库未运行或无法连接"
        print_info "请先启动服务: docker-compose up -d postgres"
        exit 1
    fi
}

# 显示帮助信息
show_help() {
    echo "Web Admin 数据库管理工具"
    echo ""
    echo "用法: $0 [命令] [选项]"
    echo ""
    echo "命令:"
    echo "  backup [文件名]    - 备份数据库到指定文件 (默认: backup_YYYYMMDD_HHMMSS.sql)"
    echo "  restore <文件名>   - 从备份文件恢复数据库"
    echo "  reset              - 重置数据库到初始状态"
    echo "  status             - 显示数据库状态"
    echo "  connect            - 连接到数据库 shell"
    echo "  logs               - 显示数据库日志"
    echo "  size               - 显示数据库大小"
    echo "  tables             - 列出所有表"
    echo "  help               - 显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 backup                    # 使用默认文件名备份"
    echo "  $0 backup my_backup.sql      # 备份到指定文件"
    echo "  $0 restore my_backup.sql     # 从备份文件恢复"
    echo "  $0 reset                     # 重置数据库"
}

# 备份数据库
backup_database() {
    local backup_file=${1:-"backup_$(date +%Y%m%d_%H%M%S).sql"}

    print_info "备份数据库到文件: $backup_file"

    # 确保备份目录存在
    mkdir -p backups

    # 执行备份
    if docker-compose exec -T postgres pg_dump -U postgres rust_web_admin > "backups/$backup_file"; then
        print_success "数据库备份完成: backups/$backup_file"

        # 显示备份文件大小
        local file_size=$(du -h "backups/$backup_file" | cut -f1)
        print_info "备份文件大小: $file_size"
    else
        print_error "数据库备份失败"
        exit 1
    fi
}

# 恢复数据库
restore_database() {
    local backup_file=$1

    if [ -z "$backup_file" ]; then
        print_error "请指定备份文件名"
        echo "用法: $0 restore <备份文件名>"
        exit 1
    fi

    if [ ! -f "backups/$backup_file" ] && [ ! -f "$backup_file" ]; then
        print_error "备份文件不存在: $backup_file"
        exit 1
    fi

    # 确定文件路径
    if [ -f "backups/$backup_file" ]; then
        backup_file="backups/$backup_file"
    fi

    print_warning "这将删除当前所有数据并从备份恢复"
    read -p "确定要继续吗? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "操作已取消"
        exit 0
    fi

    print_info "从备份文件恢复数据库: $backup_file"

    # 删除现有数据库并重新创建
    docker-compose exec -T postgres psql -U postgres -c "DROP DATABASE IF EXISTS rust_web_admin;"
    docker-compose exec -T postgres psql -U postgres -c "CREATE DATABASE rust_web_admin;"

    # 恢复数据
    if docker-compose exec -T postgres psql -U postgres rust_web_admin < "$backup_file"; then
        print_success "数据库恢复完成"
    else
        print_error "数据库恢复失败"
        exit 1
    fi
}

# 重置数据库
reset_database() {
    print_warning "这将删除所有数据并重置数据库到初始状态"
    read -p "确定要继续吗? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "操作已取消"
        exit 0
    fi

    print_info "重置数据库..."

    # 删除并重新创建数据库
    docker-compose exec -T postgres psql -U postgres -c "DROP DATABASE IF EXISTS rust_web_admin;"
    docker-compose exec -T postgres psql -U postgres -c "CREATE DATABASE rust_web_admin;"

    # 运行初始化脚本
    if [ -f "backend/migrations/001_initial_schema.sql" ]; then
        print_info "运行数据库架构迁移..."
        docker-compose exec -T postgres psql -U postgres rust_web_admin < backend/migrations/001_initial_schema.sql
    fi

    if [ -f "backend/migrations/002_initial_data.sql" ]; then
        print_info "插入初始数据..."
        docker-compose exec -T postgres psql -U postgres rust_web_admin < backend/migrations/002_initial_data.sql
    fi

    print_success "数据库重置完成"
}

# 显示数据库状态
show_status() {
    print_info "数据库状态信息:"
    echo ""

    # 连接状态
    if docker-compose exec -T postgres pg_isready -U postgres -d rust_web_admin > /dev/null 2>&1; then
        print_success "数据库连接正常"
    else
        print_error "数据库连接失败"
        return 1
    fi

    # 数据库大小
    local db_size=$(docker-compose exec -T postgres psql -U postgres -d rust_web_admin -t -c "SELECT pg_size_pretty(pg_database_size('rust_web_admin'));" | xargs)
    echo "数据库大小: $db_size"

    # 连接数
    local connections=$(docker-compose exec -T postgres psql -U postgres -d rust_web_admin -t -c "SELECT count(*) FROM pg_stat_activity WHERE datname='rust_web_admin';" | xargs)
    echo "当前连接数: $connections"

    # 表数量
    local table_count=$(docker-compose exec -T postgres psql -U postgres -d rust_web_admin -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';" | xargs)
    echo "表数量: $table_count"
}

# 连接到数据库
connect_database() {
    print_info "连接到数据库 shell..."
    print_info "使用 \\q 退出"
    docker-compose exec postgres psql -U postgres rust_web_admin
}

# 显示数据库日志
show_logs() {
    print_info "显示数据库日志 (按 Ctrl+C 退出):"
    docker-compose logs -f postgres
}

# 显示数据库大小
show_size() {
    print_info "数据库大小统计:"
    docker-compose exec -T postgres psql -U postgres -d rust_web_admin -c "
        SELECT
            schemaname,
            tablename,
            pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
        FROM pg_tables
        WHERE schemaname = 'public'
        ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
    "
}

# 列出所有表
list_tables() {
    print_info "数据库表列表:"
    docker-compose exec -T postgres psql -U postgres -d rust_web_admin -c "
        SELECT
            tablename,
            schemaname
        FROM pg_tables
        WHERE schemaname = 'public'
        ORDER BY tablename;
    "
}

# 主函数
main() {
    local command=${1:-help}

    case $command in
        backup)
            check_docker
            check_database
            backup_database "$2"
            ;;
        restore)
            check_docker
            check_database
            restore_database "$2"
            ;;
        reset)
            check_docker
            check_database
            reset_database
            ;;
        status)
            check_docker
            check_database
            show_status
            ;;
        connect)
            check_docker
            check_database
            connect_database
            ;;
        logs)
            check_docker
            show_logs
            ;;
        size)
            check_docker
            check_database
            show_size
            ;;
        tables)
            check_docker
            check_database
            list_tables
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
