# 用户管理接口 API

## 概述

用户管理模块提供用户的增删改查功能，以及用户角色分配。所有接口都需要相应的权限验证。

**所需权限：**
- 查看用户: `user:read`
- 创建用户: `user:create`
- 更新用户: `user:update`
- 删除用户: `user:delete`

## 接口列表

### 获取用户列表
**GET** `/api/users`

获取系统中所有用户的分页列表。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**查询参数：**
```
?page=1&per_page=20
```

**参数说明：**
- `page` (可选): 页码，默认为1，范围1-100
- `per_page` (可选): 每页数量，默认为20，范围1-100

**响应示例：**
```json
{
  "data": [
    {
      "id": 1,
      "username": "admin",
      "email": "admin@example.com",
      "is_active": true,
      "roles": ["super_admin"],
      "permissions": ["user:read", "user:create", "user:update", "user:delete"]
    }
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 20,
    "total": 50,
    "total_pages": 3,
    "has_next": true,
    "has_prev": false
  }
}
```

---

### 获取用户详情
**GET** `/api/users/:id`

获取指定用户的详细信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 用户ID

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

---

### 创建用户
**POST** `/api/users`

创建新用户账户。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**请求参数：**
```json
{
  "username": "newuser",
  "email": "newuser@example.com",
  "password": "password123"
}
```

**参数说明：**
- `username` (必填): 用户名，3-50个字符，唯一
- `email` (必填): 邮箱地址，必须是有效格式，唯一
- `password` (必填): 密码，至少6个字符

**响应示例：**
```json
{
  "message": "用户创建成功",
  "user": {
    "id": 5,
    "username": "newuser",
    "email": "newuser@example.com"
  }
}
```

---

### 更新用户
**PUT** `/api/users/:id`

更新用户信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 用户ID

**请求参数：**
```json
{
  "email": "updated@example.com",
  "is_active": true
}
```

**参数说明：**
- `email` (可选): 新邮箱地址
- `is_active` (可选): 用户激活状态
- `password` (可选): 新密码

**响应示例：**
```json
{
  "message": "用户更新成功",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "updated@example.com",
    "is_active": true
  }
}
```

---

### 删除用户
**DELETE** `/api/users/:id`

删除指定用户。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 用户ID

**响应示例：**
```json
{
  "message": "用户删除成功"
}
```

**注意事项：**
- 不能删除当前登录用户
- 删除用户会同时清理相关的角色关联

---

### 为用户分配角色
**POST** `/api/users/:id/roles`

为指定用户分配角色。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 用户ID

**请求参数：**
```json
{
  "role_id": 2
}
```

**参数说明：**
- `role_id` (必填): 角色ID

**响应示例：**
```json
{
  "message": "角色分配成功"
}
```

---

### 移除用户角色
**DELETE** `/api/users/:id/roles`

移除用户的指定角色。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 用户ID

**请求参数：**
```json
{
  "role_id": 2
}
```

**响应示例：**
```json
{
  "message": "角色移除成功"
}
```

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

### 401 Unauthorized - 未认证
```json
{
  "error": "未提供有效的认证令牌"
}
```

### 403 Forbidden - 权限不足
```json
{
  "error": "权限不足",
  "required": "user:create"
}
```

### 404 Not Found - 用户不存在
```json
{
  "error": "用户不存在"
}
```

### 409 Conflict - 资源冲突
```json
{
  "error": "用户名已存在"
}
```

## 使用示例

### 1. 获取用户列表
```bash
curl -X GET http://localhost:3000/api/users?page=1&per_page=10 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 2. 创建用户
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'
```

### 3. 更新用户
```bash
curl -X PUT http://localhost:3000/api/users/5 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "updated@example.com",
    "is_active": false
  }'
```

### 4. 为用户分配角色
```bash
curl -X POST http://localhost:3000/api/users/5/roles \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "role_id": 2
  }'
```

### 5. 删除用户
```bash
curl -X DELETE http://localhost:3000/api/users/5 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 业务规则

1. **用户名唯一性**: 用户名在系统中必须唯一
2. **邮箱唯一性**: 邮箱地址在系统中必须唯一
3. **密码安全**: 密码使用bcrypt进行哈希存储
4. **角色继承**: 用户通过角色获得权限
5. **软删除**: 建议使用is_active字段进行软删除而非物理删除
6. **权限检查**: 所有操作都需要相应的权限验证
