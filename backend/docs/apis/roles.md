# 角色管理接口 API

## 概述

角色管理模块提供角色的增删改查功能，以及角色权限的分配和管理。角色是权限的集合，用户通过角色获得相应的权限。

**所需权限：**
- 查看角色: `role:read`
- 创建角色: `role:create`
- 更新角色: `role:update`
- 删除角色: `role:delete`

## 接口列表

### 获取角色列表
**GET** `/api/roles`

获取系统中所有角色的分页列表。

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
      "name": "super_admin",
      "description": "超级管理员",
      "is_active": true,
      "permissions": ["user:read", "user:create", "user:update", "user:delete"]
    }
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 20,
    "total": 15,
    "total_pages": 1,
    "has_next": false,
    "has_prev": false
  }
}
```

---

### 获取角色详情
**GET** `/api/roles/:id`

获取指定角色的详细信息，包括该角色拥有的所有权限。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 角色ID

**响应示例：**
```json
{
  "role": {
    "id": 1,
    "name": "super_admin",
    "description": "超级管理员",
    "is_active": true,
    "permissions": ["user:read", "user:create", "user:update", "user:delete"]
  }
}
```

---

### 创建角色
**POST** `/api/roles`

创建新角色。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**请求参数：**
```json
{
  "name": "editor",
  "description": "内容编辑角色"
}
```

**参数说明：**
- `name` (必填): 角色名称，3-50个字符，唯一
- `description` (可选): 角色描述，最大255个字符
- `is_active` (可选): 角色是否激活，默认为true

**响应示例：**
```json
{
  "message": "角色创建成功",
  "role": {
    "id": 3,
    "name": "editor",
    "description": "内容编辑角色"
  }
}
```

---

### 更新角色
**PUT** `/api/roles/:id`

更新角色信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 角色ID

**请求参数：**
```json
{
  "name": "senior_editor",
  "description": "高级编辑角色",
  "is_active": true
}
```

**参数说明：**
- `name` (可选): 角色名称
- `description` (可选): 角色描述
- `is_active` (可选): 角色激活状态

**响应示例：**
```json
{
  "message": "角色更新成功",
  "role": {
    "id": 3,
    "name": "senior_editor",
    "description": "高级编辑角色",
    "is_active": true
  }
}
```

---

### 删除角色
**DELETE** `/api/roles/:id`

删除指定角色。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 角色ID

**响应示例：**
```json
{
  "message": "角色删除成功"
}
```

**注意事项：**
- 删除角色前会检查是否有用户正在使用该角色
- 如果有用户关联，需要先解除关联或转移用户到其他角色

---

### 为角色分配权限
**POST** `/api/roles/:id/permissions`

为指定角色分配权限。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 角色ID

**请求参数：**
```json
{
  "permission_id": 5
}
```

**参数说明：**
- `permission_id` (必填): 权限ID

**响应示例：**
```json
{
  "message": "权限分配成功"
}
```

---

### 为角色移除权限
**DELETE** `/api/roles/:id/permissions`

移除角色的指定权限。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 角色ID

**请求参数：**
```json
{
  "permission_id": 5
}
```

**参数说明：**
- `permission_id` (必填): 权限ID

**响应示例：**
```json
{
  "message": "权限移除成功"
}
```

---

### 批量分配权限
**POST** `/api/roles/:id/permissions/batch`

为角色批量分配多个权限。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 角色ID

**请求参数：**
```json
{
  "permission_ids": [1, 2, 3, 4]
}
```

**参数说明：**
- `permission_ids` (必填): 权限ID数组

**响应示例：**
```json
{
  "message": "权限批量分配成功",
  "assigned_count": 4
}
```

## 常见错误

### 400 Bad Request - 参数验证失败
```json
{
  "error": "验证失败",
  "details": {
    "name": ["角色名称长度必须在3-50个字符之间"]
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
  "required": "role:create"
}
```

### 404 Not Found - 角色不存在
```json
{
  "error": "角色不存在"
}
```

### 409 Conflict - 资源冲突
```json
{
  "error": "角色名称已存在"
}
```

### 422 Unprocessable Entity - 业务规则冲突
```json
{
  "error": "无法删除角色，仍有用户使用该角色"
}
```

## 使用示例

### 1. 获取角色列表
```bash
curl -X GET http://localhost:3000/api/roles?page=1&per_page=10 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 2. 创建角色
```bash
curl -X POST http://localhost:3000/api/roles \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "content_manager",
    "description": "内容管理员"
  }'
```

### 3. 更新角色
```bash
curl -X PUT http://localhost:3000/api/roles/3 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "senior_manager",
    "description": "高级管理员",
    "is_active": true
  }'
```

### 4. 为角色分配权限
```bash
curl -X POST http://localhost:3000/api/roles/3/permissions \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "permission_id": 5
  }'
```

### 5. 批量分配权限
```bash
curl -X POST http://localhost:3000/api/roles/3/permissions/batch \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "permission_ids": [1, 2, 3, 4, 5]
  }'
```

### 6. 删除角色
```bash
curl -X DELETE http://localhost:3000/api/roles/3 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 预定义角色

系统包含以下预定义角色：

### super_admin - 超级管理员
- **权限**: 拥有所有权限
- **用途**: 系统管理员使用，可以管理所有功能
- **特殊说明**: 不可删除

### admin - 管理员
- **权限**: 用户和角色管理权限
- **用途**: 普通管理员使用，可以管理用户和角色

### user - 普通用户
- **权限**: 基本查看权限
- **用途**: 普通用户的默认角色

## 业务规则

1. **角色名称唯一性**: 角色名称在系统中必须唯一
2. **权限继承**: 用户通过角色获得权限，一个用户可以有多个角色
3. **角色层级**: 建议设计合理的角色层级结构
4. **软删除**: 建议使用is_active字段进行软删除
5. **系统角色**: 某些系统预定义角色不允许删除
6. **权限最小化**: 遵循最小权限原则，只分配必要的权限
