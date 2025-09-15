# Scripts 脚本工具集

本目录包含了 Web Admin 项目的各种实用脚本，用于简化开发、部署和维护工作。

## 📋 脚本列表

### 🚀 dev-start.sh
**开发环境快速启动脚本**

用于快速启动开发环境，包括所有必要的服务。

```bash
# 启动开发环境
./scripts/dev-start.sh
```

**功能特性:**
- ✅ 自动检查 Docker 环境
- ✅ 创建默认环境变量文件
- ✅ 启动所有服务 (数据库、后端、前端)
- ✅ 等待服务就绪
- ✅ 显示访问地址和默认账户

### 🗄️ db-manager.sh
**数据库管理工具**

提供数据库的备份、恢复、重置等功能。

```bash
# 查看帮助
./scripts/db-manager.sh help

# 备份数据库
./scripts/db-manager.sh backup

# 恢复数据库
./scripts/db-manager.sh restore backup_20241201_120000.sql

# 重置数据库
./scripts/db-manager.sh reset

# 查看数据库状态
./scripts/db-manager.sh status

# 连接数据库
./scripts/db-manager.sh connect
```

**功能特性:**
- ✅ 数据库备份/恢复
- ✅ 数据库重置到初始状态
- ✅ 实时状态监控
- ✅ 直接数据库连接
- ✅ 表结构和大小统计

### 🚀 prod-deploy.sh
**生产环境部署脚本**

用于生产环境的自动化部署和管理。

```bash
# 初次部署
./scripts/prod-deploy.sh deploy

# 零停机更新
./scripts/prod-deploy.sh update

# 查看服务状态
./scripts/prod-deploy.sh status

# 健康检查
./scripts/prod-deploy.sh health

# 服务扩容
./scripts/prod-deploy.sh scale backend 3
```

**功能特性:**
- ✅ 环境检查和验证
- ✅ 自动数据备份
- ✅ 零停机部署
- ✅ 健康检查
- ✅ 服务扩缩容
- ✅ 日志管理

## 🛠️ 使用指南

### 前置要求

确保你的系统已安装：
- **Docker** (20.0+)
- **Docker Compose** (2.0+)
- **Bash** (4.0+)
- **curl** (用于健康检查)

### 权限设置

所有脚本都已设置执行权限。如果需要重新设置：

```bash
chmod +x scripts/*.sh
```

### 日志记录

生产部署脚本会自动创建日志文件：
- `deploy.log` - 部署操作日志

数据库管理脚本会在 `backups/` 目录创建备份文件。

## 📖 常用工作流

### 开发环境

```bash
# 1. 启动开发环境
./scripts/dev-start.sh

# 2. 查看日志
docker-compose logs -f

# 3. 重置数据库（如需要）
./scripts/db-manager.sh reset

# 4. 停止服务
docker-compose down
```

### 生产部署

```bash
# 1. 首次部署
./scripts/prod-deploy.sh deploy

# 2. 代码更新
git pull
./scripts/prod-deploy.sh update

# 3. 健康检查
./scripts/prod-deploy.sh health

# 4. 备份数据
./scripts/db-manager.sh backup
```

### 数据库维护

```bash
# 定期备份
./scripts/db-manager.sh backup

# 查看数据库大小
./scripts/db-manager.sh size

# 检查连接状态
./scripts/db-manager.sh status

# 紧急恢复
./scripts/db-manager.sh restore backup_file.sql
```

## 🔧 自定义配置

### 环境变量

脚本会读取项目根目录的 `.env` 文件。确保配置了必要的环境变量：

```env
# 必需配置
POSTGRES_PASSWORD=your_password
JWT_SECRET=your_jwt_secret

# 可选配置
BACKUP_RETENTION_DAYS=7
HEALTH_CHECK_TIMEOUT=300
```

### 脚本配置

可以通过修改脚本开头的配置变量来自定义行为：

```bash
# 在 prod-deploy.sh 中
PROJECT_NAME="web-admin"
COMPOSE_FILE="docker-compose.prod.yml"
BACKUP_DIR="backups"
LOG_FILE="deploy.log"
```

## ⚠️ 注意事项

### 安全提醒

1. **生产环境密码**: 务必修改 `.env` 文件中的默认密码
2. **备份安全**: 备份文件可能包含敏感数据，请妥善保管
3. **权限控制**: 确保脚本执行权限仅授予可信用户

### 故障排除

**脚本执行失败**:
```bash
# 检查 Docker 状态
docker info

# 检查权限
ls -la scripts/

# 查看详细错误
bash -x ./scripts/script-name.sh
```

**服务启动失败**:
```bash
# 查看服务日志
docker-compose logs

# 检查端口占用
netstat -tlnp | grep :80
netstat -tlnp | grep :3000
```

**数据库连接失败**:
```bash
# 检查数据库状态
./scripts/db-manager.sh status

# 重启数据库服务
docker-compose restart postgres
```

## 📚 扩展脚本

### 添加新脚本

1. 在 `scripts/` 目录创建新的 `.sh` 文件
2. 添加执行权限: `chmod +x scripts/new-script.sh`
3. 遵循现有脚本的代码风格和错误处理模式
4. 更新本 README 文档

### 脚本模板

```bash
#!/bin/bash

# 脚本名称和描述
# 脚本功能说明

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 工具函数
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

# 主逻辑
main() {
    print_info "脚本开始执行..."
    # 你的代码逻辑
    print_success "脚本执行完成"
}

# 执行主函数
main "$@"
```

## 📞 获取帮助

如果在使用脚本过程中遇到问题：

1. 查看脚本的帮助信息: `./scripts/script-name.sh help`
2. 检查项目文档: [docs/deployment/](../docs/deployment/)
3. 查看项目 Issues: [GitHub Issues](https://github.com/your-repo/issues)
4. 联系维护团队: admin@yourdomain.com

---

*这些脚本旨在简化日常运维工作，如有改进建议欢迎提交 PR！*
