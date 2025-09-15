# 权限管理接口 API

## 概述

权限管理模块提供权限的增删改查功能。权限定义了用户可以执行的具体操作，采用`资源:操作`的格式，如`user:read`、`role:create`等。

**所需权限：**
- 查看权限: `permission:read`
- 创建权限: `permission:create`
- 更新权限: `permission:update`
- 删除权限: `permission:delete`

## 接口列表

### 获取权限列表
**GET** `/api/permissions`

获取系统中所有权限的分页列表。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**查询参数：**
```
?page=1&per_page=20&resource=user&action=read
```

**参数说明：**
- `page` (可选): 页码，默认为1，范围1-100
- `per_page` (可选): 每页数量，默认为20，范围1-100
- `resource` (可选): 按资源类型过滤
- `action` (可选): 按操作类型过滤

**响应示例：**
```json
{
  "data": [
    {
      "id": 1,
      "name": "user:read",
      "description": "用户查看权限",
      "resource": "user",
      "action": "read",
      "is_active": true
    }
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 20,
    "total": 25,
    "total_pages": 2,
    "has_next": true,
    "has_prev": false
  }
}
```

---

### 获取权限详情
**GET** `/api/permissions/:id`

获取指定权限的详细信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 权限ID

**响应示例：**
```json
{
  "permission": {
    "id": 1,
    "name": "user:read",
    "description": "用户查看权限",
    "resource": "user",
    "action": "read",
    "is_active": true
  }
}
```

---

### 创建权限
**POST** `/api/permissions`

创建新权限。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**请求参数：**
```json
{
  "name": "article:write",
  "description": "文章写入权限",
  "resource": "article",
  "action": "write"
}
```

**参数说明：**
- `name` (必填): 权限名称，格式为`resource:action`，唯一
- `description` (可选): 权限描述，最大255个字符
- `resource` (必填): 资源名称，如user、role、article等
- `action` (必填): 操作名称，如read、create、update、delete等
- `is_active` (可选): 权限是否激活，默认为true

**响应示例：**
```json
{
  "message": "权限创建成功",
  "permission": {
    "id": 10,
    "name": "article:write",
    "description": "文章写入权限",
    "resource": "article",
    "action": "write"
  }
}
```

---

### 更新权限
**PUT** `/api/permissions/:id`

更新权限信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 权限ID

**请求参数：**
```json
{
  "name": "article:edit",
  "description": "文章编辑权限",
  "resource": "article",
  "action": "edit",
  "is_active": true
}
```

**参数说明：**
- `name` (可选): 权限名称
- `description` (可选): 权限描述
- `resource` (可选): 资源名称
- `action` (可选): 操作名称
- `is_active` (可选): 权限激活状态

**响应示例：**
```json
{
  "message": "权限更新成功",
  "permission": {
    "id": 10,
    "name": "article:edit",
    "description": "文章编辑权限",
    "resource": "article",
    "action": "edit",
    "is_active": true
  }
}
```

---

### 删除权限
**DELETE** `/api/permissions/:id`

删除指定权限。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 权限ID

**响应示例：**
```json
{
  "message": "权限删除成功"
}
```

**注意事项：**
- 删除权限前会检查是否有角色正在使用该权限
- 系统核心权限不允许删除

---

### 按资源分组获取权限
**GET** `/api/permissions/grouped`

按资源类型分组获取权限列表，便于权限管理界面展示。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**响应示例：**
```json
{
  "data": {
    "user": [
      {
        "id": 1,
        "name": "user:read",
        "description": "用户查看权限",
        "action": "read",
        "is_active": true
      },
      {
        "id": 2,
        "name": "user:create",
        "description": "用户创建权限",
        "action": "create",
        "is_active": true
      }
    ],
    "role": [
      {
        "id": 5,
        "name": "role:read",
        "description": "角色查看权限",
        "action": "read",
        "is_active": true
      }
    ]
  }
}
```

---

### 批量创建权限
**POST** `/api/permissions/batch`

批量创建多个权限，常用于为新资源快速创建CRUD权限。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**请求参数：**
```json
{
  "resource": "article",
  "permissions": [
    {
      "action": "read",
      "description": "文章查看权限"
    },
    {
      "action": "create",
      "description": "文章创建权限"
    },
    {
      "action": "update",
      "description": "文章更新权限"
    },
    {
      "action": "delete",
      "description": "文章删除权限"
    }
  ]
}
```

**响应示例：**
```json
{
  "message": "权限批量创建成功",
  "created_count": 4,
  "permissions": [
    {
      "id": 10,
      "name": "article:read",
      "description": "文章查看权限"
    }
  ]
}
```

## 常见错误

### 400 Bad Request - 参数验证失败
```json
{
  "error": "验证失败",
  "details": {
    "name": ["权限名称格式错误，应为resource:action格式"],
    "resource": ["资源名称不能为空"]
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
  "required": "permission:create"
}
```

### 404 Not Found - 权限不存在
```json
{
  "error": "权限不存在"
}
```

### 409 Conflict - 资源冲突
```json
{
  "error": "权限名称已存在"
}
```

### 422 Unprocessable Entity - 业务规则冲突
```json
{
  "error": "无法删除权限，仍有角色使用该权限"
}
```

## 使用示例

### 1. 获取权限列表
```bash
curl -X GET http://localhost:3000/api/permissions?page=1&per_page=10 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 2. 按资源过滤权限
```bash
curl -X GET http://localhost:3000/api/permissions?resource=user \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 3. 创建权限
```bash
curl -X POST http://localhost:3000/api/permissions \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "content:publish",
    "description": "内容发布权限",
    "resource": "content",
    "action": "publish"
  }'
```

### 4. 批量创建权限
```bash
curl -X POST http://localhost:3000/api/permissions/batch \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "resource": "order",
    "permissions": [
      {
        "action": "read",
        "description": "订单查看权限"
      },
      {
        "action": "create",
        "description": "订单创建权限"
      }
    ]
  }'
```

### 5. 更新权限
```bash
curl -X PUT http://localhost:3000/api/permissions/10 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "description": "内容发布和编辑权限",
    "is_active": true
  }'
```

### 6. 删除权限
```bash
curl -X DELETE http://localhost:3000/api/permissions/10 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 权限命名规范

### 格式规则
权限名称采用`resource:action`格式：
- `resource`: 资源名称，使用小写字母和下划线
- `action`: 操作名称，使用小写字母

### 标准操作
- `read`: 查看/读取操作
- `create`: 创建操作
- `update`: 更新操作
- `delete`: 删除操作
- `list`: 列表操作（可选，通常包含在read中）

### 扩展操作
根据业务需要可以定义扩展操作：
- `publish`: 发布操作
- `approve`: 审批操作
- `export`: 导出操作
- `import`: 导入操作

### 示例
```
user:read          # 用户查看权限
user:create        # 用户创建权限
article:publish    # 文章发布权限
order:approve      # 订单审批权限
data:export        # 数据导出权限
```

## 预定义权限

系统包含以下核心权限：

### 用户管理权限
- `user:read` - 用户查看权限
- `user:create` - 用户创建权限
- `user:update` - 用户更新权限
- `user:delete` - 用户删除权限

### 角色管理权限
- `role:read` - 角色查看权限
- `role:create` - 角色创建权限
- `role:update` - 角色更新权限
- `role:delete` - 角色删除权限

### 权限管理权限
- `permission:read` - 权限查看权限
- `permission:create` - 权限创建权限
- `permission:update` - 权限更新权限
- `permission:delete` - 权限删除权限

## 业务规则

1. **权限名称唯一性**: 权限名称在系统中必须唯一
2. **命名格式**: 必须符合`resource:action`格式
3. **权限粒度**: 建议设计合适的权限粒度，既要保证安全性，又要避免过于复杂
4. **软删除**: 建议使用is_active字段进行软删除
5. **系统权限**: 核心系统权限不允许删除
6. **权限分组**: 相关权限按资源进行分组管理
