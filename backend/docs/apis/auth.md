# 认证接口 API

## 概述

认证模块提供用户注册、登录和获取当前用户信息的功能。所有需要认证的接口都需要在请求头中提供有效的JWT令牌。

## 接口列表

### 用户注册
**POST** `/api/auth/register`

注册新用户账户。

**请求参数：**
```json
{
  "username": "testuser1",
  "email": "test1@example.com",
  "password": "password123"
}
```

**参数说明：**
- `username` (必填): 用户名，3-50个字符
- `email` (必填): 邮箱地址，必须是有效的邮箱格式
- `password` (必填): 密码，至少6个字符

**响应示例：**
```json
{
  "message": "用户创建成功",
  "user": {
    "id": 4,
    "username": "testuser1",
    "email": "test1@example.com"
  }
}
```

**错误响应：**
```json
{
  "error": "用户名已存在"
}
```

---

### 用户登录
**POST** `/api/auth/login`

用户登录获取访问令牌。

**请求参数：**
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**参数说明：**
- `username` (必填): 用户名或邮箱
- `password` (必填): 密码

**响应示例：**
```json
{
  "message": "登录成功",
  "auth": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "token_type": "Bearer",
    "expires_in": 86400
  }
}
```

**响应字段说明：**
- `token`: JWT访问令牌
- `token_type`: 令牌类型，固定为"Bearer"
- `expires_in`: 令牌有效期，单位为秒

**错误响应：**
```json
{
  "error": "用户名或密码错误"
}
```

---

### 刷新访问令牌
**POST** `/api/auth/refresh`

刷新当前用户的访问令牌，延长会话时间。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**请求参数：**
无需请求体参数

**响应示例：**
```json
{
  "message": "令牌刷新成功",
  "auth": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "token_type": "Bearer",
    "expires_in": 86400
  }
}
```

**响应字段说明：**
- `token`: 新的JWT访问令牌
- `token_type`: 令牌类型，固定为"Bearer"
- `expires_in`: 令牌有效期，单位为秒

**错误响应：**
```json
{
  "error": "未提供有效的认证令牌"
}
```

**使用场景：**
- 当前端检测到token即将过期时自动调用
- 用户长时间使用应用时保持登录状态
- 避免用户频繁重新登录

---

### 获取当前用户信息
**GET** `/api/auth/me`

获取当前登录用户的详细信息，包括角色和权限。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**响应示例：**
```json
{
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    "is_active": true,
    "roles": ["super_admin"],
    "permissions": ["user:read", "user:create", "user:update", "user:delete"]
  }
}
```

**响应字段说明：**
- `id`: 用户ID
- `username`: 用户名
- `email`: 邮箱地址
- `is_active`: 用户是否激活
- `roles`: 用户拥有的角色列表
- `permissions`: 用户拥有的权限列表

## 常见错误

### 400 Bad Request - 参数验证失败
```json
{
  "error": "验证失败",
  "details": {
    "username": ["用户名长度必须在3-50个字符之间"],
    "email": ["邮箱格式不正确"]
  }
}
```

### 401 Unauthorized - 认证失败
```json
{
  "error": "未提供有效的认证令牌"
}
```

### 409 Conflict - 资源冲突
```json
{
  "error": "用户名已存在"
}
```

## 使用示例

### 1. 注册新用户
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "email": "newuser@example.com",
    "password": "password123"
  }'
```

### 2. 用户登录
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "password": "password123"
  }'
```

### 3. 刷新访问令牌
```bash
curl -X POST http://localhost:3000/api/auth/refresh \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 4. 获取用户信息
```bash
curl -X GET http://localhost:3000/api/auth/me \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 安全说明

1. **密码安全**: 密码使用bcrypt进行哈希存储
2. **JWT安全**: 令牌包含用户ID和过期时间，使用HMAC SHA256签名
3. **令牌过期**: 默认24小时过期，需要重新登录获取新令牌
4. **请求限制**: 建议对登录接口实施频率限制
