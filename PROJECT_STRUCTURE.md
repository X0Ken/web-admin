# 项目结构说明

本文档描述了 Web Admin 项目重组后的目录结构和文件组织方式。

## 📁 项目结构

```
web-admin/                          # 项目根目录
├── README.md                       # 项目主文档 (新增)
├── .gitignore                     # 统一的忽略规则 (新增)
├── env.example                     # 环境变量示例 (新增)
│
├── docker-compose.yml             # 开发环境编排配置 (新增)
├── docker-compose.prod.yml        # 生产环境编排配置 (新增)
├── Dockerfile.backend             # 后端 Docker 镜像 (新增)
├── Dockerfile.frontend            # 前端 Docker 镜像 (新增)
│
├── docs/                          # 项目文档目录 (新增)
│   ├── README.md                  # 文档索引
│   ├── api/                       # API 接口文档
│   ├── architecture/              # 系统架构文档
│   │   └── overview.md            # 架构概览
│   ├── deployment/                # 部署相关文档
│   │   └── quick-start.md         # 快速开始指南
│   └── development/               # 开发指南文档
│
├── scripts/                       # 运维脚本目录 (新增)
│   ├── README.md                  # 脚本使用说明
│   ├── dev-start.sh              # 开发环境启动脚本
│   ├── db-manager.sh             # 数据库管理脚本
│   └── prod-deploy.sh            # 生产环境部署脚本
│
├── backend/                       # Rust 后端
│   ├── src/                      # 源代码
│   ├── migrations/               # 数据库迁移
│   ├── docs/                     # 后端专用文档
│   │   ├── apis/                 # API 实现文档
│   │   └── tests/                # 测试文档
│   ├── Cargo.toml               # Rust 依赖配置
│   └── Cargo.lock              # 依赖锁定文件
│
└── frontend/                      # Angular 前端
    ├── src/                      # 源代码
    ├── docs/                     # 前端专用文档
    │   └── apis/                 # API 使用文档
    ├── package.json             # Node.js 依赖配置
    ├── package-lock.json        # 依赖锁定文件
    ├── angular.json             # Angular 配置
    ├── tsconfig.json           # TypeScript 配置
    └── 其他前端配置文件...
```

## 🔄 重组变更

### 新增的根目录文件

1. **README.md** - 项目主文档，整合了前后端信息
2. **.gitignore** - 统一的 Git 忽略规则，合并前后端规则
3. **env.example** - 环境变量配置示例
4. **docker-compose.yml** - 开发环境 Docker 编排
5. **docker-compose.prod.yml** - 生产环境 Docker 编排
6. **Dockerfile.backend** - 后端容器镜像构建文件
7. **Dockerfile.frontend** - 前端容器镜像构建文件
8. **PROJECT_STRUCTURE.md** - 本文档

### 新增的目录

1. **docs/** - 统一的项目文档目录
   - 架构设计文档
   - 部署指南
   - API 文档
   - 开发指南

2. **scripts/** - 运维和开发脚本
   - 开发环境启动脚本
   - 数据库管理工具
   - 生产环境部署脚本

### 删除的重复文件

1. **frontend/README.md** - 已整合到根目录 README.md
2. **backend/README.md** - 已整合到根目录 README.md
3. **frontend/.gitignore** - 已整合到根目录 .gitignore (如果存在)
4. **backend/.gitignore** - 已整合到根目录 .gitignore (如果存在)

### 保留的目录结构

- **backend/docs/** - 保留后端专用技术文档
- **frontend/docs/** - 保留前端专用技术文档
- **backend/src/** - 后端源代码
- **frontend/src/** - 前端源代码
- **backend/migrations/** - 数据库迁移脚本

## 🎯 重组目标

### 统一管理
- 项目文档集中在根目录 `docs/`
- 配置文件统一在根目录
- 部署脚本集中在 `scripts/`

### 简化部署
- Docker 配置文件在根目录
- 一键启动脚本
- 生产环境自动化部署

### 清晰分工
- 根目录：项目级别的配置和文档
- 子目录：模块专用的代码和文档

## 📝 使用指南

### 快速开始

```bash
# 1. 克隆项目
git clone <repository-url>
cd web-admin

# 2. 启动开发环境
./scripts/dev-start.sh

# 3. 访问应用
# 前端: http://localhost
# 后端: http://localhost:3000
```

### 开发工作流

```bash
# 查看项目文档
ls docs/

# 启动开发环境
./scripts/dev-start.sh

# 管理数据库
./scripts/db-manager.sh help

# 查看日志
docker-compose logs -f
```

### 生产部署

```bash
# 配置环境变量
cp env.example .env
# 编辑 .env 文件

# 部署到生产环境
./scripts/prod-deploy.sh deploy
```

## 🔍 文件定位指南

| 需要查找的内容 | 位置 |
|---|---|
| 项目介绍和快速开始 | `README.md` |
| 系统架构设计 | `docs/architecture/` |
| 部署和运维指南 | `docs/deployment/` |
| API 接口文档 | `docs/api/` |
| 开发环境配置 | `docs/development/` |
| 运维脚本 | `scripts/` |
| 后端代码 | `backend/src/` |
| 前端代码 | `frontend/src/` |
| 数据库迁移 | `backend/migrations/` |
| 环境变量配置 | `env.example` → `.env` |
| 容器配置 | `docker-compose*.yml` |

## 💡 最佳实践

### 文档维护
- 保持根目录 README.md 为项目主入口
- 技术细节放在 `docs/` 对应子目录
- 模块专用文档保留在各自目录

### 配置管理
- 敏感配置通过环境变量传递
- 配置模板放在 `env.example`
- 不同环境使用不同的 docker-compose 文件

### 脚本使用
- 日常开发使用 `scripts/dev-start.sh`
- 数据库操作使用 `scripts/db-manager.sh`
- 生产部署使用 `scripts/prod-deploy.sh`

---

*此文档将随着项目发展持续更新。如有疑问或建议，请提交 Issue 或 PR。*
