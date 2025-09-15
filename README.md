# Web Admin 管理系统

一个基于 Rust (Axum) 后端和 Angular 前端的现代化 Web 管理系统，提供完整的用户认证、RBAC 权限管理和管理界面。

## 项目概览

本项目采用前后端分离架构：
- **后端**: 使用 Rust + Axum 框架，提供 RESTful API 服务
- **前端**: 使用 Angular 20 + ng-zorro-antd，提供现代化管理界面

## 功能特性

### 🔐 认证系统
- JWT 令牌认证
- 用户注册与登录
- 密码加密存储 (bcrypt)
- 自动 token 管理

### 🛡️ 权限管理 (RBAC)
- 基于角色的访问控制
- 用户、角色、权限三级管理
- 灵活的权限分配机制
- 路由级别的权限保护

### 📊 管理功能
- 用户管理：创建、编辑、删除、状态管理
- 角色管理：角色分配、权限绑定
- 权限管理：细粒度权限控制
- 系统仪表盘：数据统计展示
- 系统日志：操作记录追踪
- 个人信息：用户资料管理
- 系统设置：参数配置管理

## 技术栈

### 后端技术
- **框架**: Axum (Rust 异步 Web 框架)
- **数据库**: PostgreSQL + SeaORM
- **认证**: JWT + bcrypt
- **序列化**: Serde
- **验证**: Validator
- **日志**: Tracing
- **异步**: Tokio

### 前端技术
- **框架**: Angular 20
- **UI 组件**: ng-zorro-antd 20.1.3
- **语言**: TypeScript
- **样式**: SCSS
- **状态管理**: Angular Services
- **HTTP 客户端**: Angular HttpClient

## 快速开始

### 环境要求

**后端**:
- Rust 1.70+
- PostgreSQL 12+
- Cargo

**前端**:
- Node.js 18+
- npm 或 yarn
- Angular CLI

### 1. 克隆项目

```bash
git clone <repository-url>
cd web-admin
```

### 2. 后端设置

```bash
# 进入后端目录
cd backend

# 安装依赖
cargo build

# 创建数据库
createdb rust_web_admin

# 运行数据库迁移
psql -d rust_web_admin -f migrations/001_initial_schema.sql
psql -d rust_web_admin -f migrations/002_initial_data.sql

# 创建环境配置文件
cp env.example .env
# 编辑 .env 文件，配置数据库连接和 JWT 密钥

# 启动后端服务
cargo run
```

后端服务将在 `http://localhost:3000` 启动。

### 3. 前端设置

```bash
# 进入前端目录
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm start
```

前端应用将在 `http://localhost:4200` 启动。

### 4. 使用 Docker (推荐)

```bash
# 构建并启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f
```

## 项目结构

```
web-admin/
├── backend/                 # Rust 后端
│   ├── src/
│   │   ├── auth.rs         # 认证模块
│   │   ├── database.rs     # 数据库连接
│   │   ├── models/         # 数据模型
│   │   ├── routes/         # API 路由
│   │   ├── rbac.rs         # 权限管理
│   │   └── main.rs         # 程序入口
│   ├── migrations/         # 数据库迁移
│   ├── Cargo.toml          # Rust 依赖配置
│   └── .env.example        # 环境变量示例
├── frontend/               # Angular 前端
│   ├── src/
│   │   ├── app/
│   │   │   ├── pages/      # 页面组件
│   │   │   ├── services/   # 服务层
│   │   │   ├── guards/     # 路由守卫
│   │   │   └── interceptors/ # HTTP 拦截器
│   │   └── assets/         # 静态资源
│   ├── package.json        # Node.js 依赖配置
│   └── angular.json        # Angular 配置
├── docs/                   # 项目文档
├── scripts/                # 常用脚本
├── docker-compose.yml      # Docker 编排配置
├── Dockerfile.backend      # 后端 Docker 镜像
├── Dockerfile.frontend     # 前端 Docker 镜像
└── README.md              # 项目说明
```


## 默认账户

系统初始化后会创建默认超级管理员账户：

- **用户名**: admin
- **密码**: admin123
- **角色**: 超级管理员

## 开发指南

### 后端开发

1. **添加新的 API 接口**:
   - 在 `src/models/` 中定义数据模型
   - 在 `src/routes/` 中实现路由处理
   - 在 `src/main.rs` 中注册路由

2. **数据库迁移**:
   ```bash
   # 创建新迁移文件
   # 在 migrations/ 目录下创建 SQL 文件
   ```

### 前端开发

1. **添加新页面**:
   - 在 `src/app/pages/` 创建组件
   - 在 `app.routes.ts` 配置路由
   - 使用 `AuthGuard` 保护需要认证的路由

2. **添加新服务**:
   - 在 `src/app/services/` 创建服务
   - 注入到需要的组件中

## 部署

### 生产环境部署

1. **使用 Docker Compose** (推荐):
   ```bash
   # 生产环境启动
   docker-compose -f docker-compose.prod.yml up -d
   ```

2. **手动部署**:
   ```bash
   # 构建后端
   cd backend && cargo build --release

   # 构建前端
   cd frontend && npm run build --prod

   # 部署到服务器
   ```

### 环境配置

生产环境需要设置以下环境变量：

```env
# 数据库配置
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# JWT 配置
JWT_SECRET=your-strong-jwt-secret-key
JWT_EXPIRATION=24h

# 日志级别
RUST_LOG=info
```

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 支持

如有问题，请查看 [docs/](./docs/) 目录下的详细文档或创建 Issue。
