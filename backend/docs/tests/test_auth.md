# 认证和权限检查测试指南

## 项目状态
✅ 认证中间件已实现
✅ 权限检查功能已实现
✅ 所有受保护的路由已添加权限检查
✅ 公共权限检查函数已提取到utils模块

## 测试步骤

### 1. 启动服务器
```bash
cargo run
```

### 2. 登录获取JWT令牌
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'
```

### 3. 测试受保护的API端点

#### 用户管理API
```bash
# 获取用户列表（需要user:read权限）
curl -X GET http://localhost:3000/api/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# 创建用户（需要user:create权限）
curl -X POST http://localhost:3000/api/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'
```

#### 角色管理API
```bash
# 获取角色列表（需要role:read权限）
curl -X GET http://localhost:3000/api/roles \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# 创建角色（需要role:create权限）
curl -X POST http://localhost:3000/api/roles \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "editor",
    "description": "内容编辑角色"
  }'
```

#### 权限管理API
```bash
# 获取权限列表（需要permission:read权限）
curl -X GET http://localhost:3000/api/permissions \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# 创建权限（需要permission:create权限）
curl -X POST http://localhost:3000/api/permissions \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "article:write",
    "description": "文章写入权限",
    "resource": "article",
    "action": "write"
  }'
```

## 权限检查机制

### 1. 认证流程
- 客户端在请求头中提供JWT令牌：`Authorization: Bearer <token>`
- 认证中间件验证JWT令牌并提取用户信息
- 用户信息存储在请求扩展中

### 2. 权限检查流程
- 每个受保护的路由函数接收`AuthUser(claims): AuthUser`参数
- 使用`utils::check_permission`函数检查用户权限
- 权限格式：`resource:action`（如：`user:read`, `role:create`）

### 3. 错误处理
- 401 Unauthorized：未提供有效JWT令牌
- 403 Forbidden：权限不足
- 500 Internal Server Error：权限检查失败

## 默认权限配置

### 超级管理员用户
- 用户名：admin
- 密码：admin123
- 角色：super_admin
- 权限：所有权限

### 默认权限
- user:read, user:create, user:update, user:delete
- role:read, role:create, role:update, role:delete
- permission:read, permission:create, permission:update, permission:delete

## 代码结构

### 核心文件
- `src/middleware.rs`：认证中间件
- `src/extractors.rs`：认证提取器
- `src/utils.rs`：公共权限检查函数
- `src/rbac.rs`：RBAC服务实现

### 路由文件
- `src/routes/user.rs`：用户管理API（已添加权限检查）
- `src/routes/role.rs`：角色管理API（已添加权限检查）
- `src/routes/permission.rs`：权限管理API（已添加权限检查）

## 下一步改进
1. 添加更细粒度的权限控制
2. 实现权限缓存机制
3. 添加权限审计日志
4. 实现动态权限配置
5. 添加单元测试和集成测试
