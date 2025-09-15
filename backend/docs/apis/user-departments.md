# 用户部门关联接口 API

## 概述

用户部门关联模块管理用户与部门之间的关系，支持用户分配到多个部门、设置主要部门、批量操作等功能。

**所需权限：**
- 查看用户部门关联: `user_department:read`
- 创建用户部门关联: `user_department:create`
- 更新用户部门关联: `user_department:update`
- 删除用户部门关联: `user_department:delete`

## 接口列表

### 为用户分配部门
**POST** `/api/user-departments/assign`

为指定用户分配到部门，可以设置职位和是否为主要部门。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**请求参数：**
```json
{
  "user_id": 5,
  "department_id": 2,
  "position": "高级开发工程师",
  "is_primary": true
}
```

**参数说明：**
- `user_id` (必填): 用户ID
- `department_id` (必填): 部门ID
- `position` (可选): 在该部门的职位，最大100个字符
- `is_primary` (可选): 是否为主要部门，默认false

**响应示例：**
```json
{
  "message": "用户部门分配成功",
  "data": {
    "id": 10,
    "user_id": 5,
    "department_id": 2,
    "position": "高级开发工程师",
    "is_primary": true,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

---

### 批量分配用户到部门
**POST** `/api/user-departments/batch-assign`

将多个用户批量分配到同一个部门。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**请求参数：**
```json
{
  "user_ids": [3, 4, 5],
  "department_id": 3,
  "position": "市场专员"
}
```

**参数说明：**
- `user_ids` (必填): 用户ID数组
- `department_id` (必填): 部门ID
- `position` (可选): 职位名称

**响应示例：**
```json
{
  "message": "批量分配成功",
  "data": {
    "assigned_count": 3,
    "skipped_count": 0,
    "assignments": [
      {
        "id": 11,
        "user_id": 3,
        "department_id": 3,
        "position": "市场专员",
        "is_primary": false
      }
    ]
  }
}
```

---

### 获取用户部门关联详情
**GET** `/api/user-departments/:id`

获取指定用户部门关联的详细信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 用户部门关联ID

**响应示例：**
```json
{
  "data": {
    "id": 10,
    "user_id": 5,
    "department_id": 2,
    "position": "高级开发工程师",
    "is_primary": true,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z",
    "user": {
      "id": 5,
      "username": "zhang.san",
      "email": "zhang.san@company.com"
    },
    "department": {
      "id": 2,
      "name": "技术部",
      "description": "负责技术开发"
    }
  }
}
```

---

### 更新用户部门信息
**PUT** `/api/user-departments/:id`

更新用户在部门中的信息，如职位、主要部门设置等。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 用户部门关联ID

**请求参数：**
```json
{
  "position": "资深开发工程师",
  "is_primary": true
}
```

**参数说明：**
- `position` (可选): 职位名称
- `is_primary` (可选): 是否为主要部门

**响应示例：**
```json
{
  "message": "用户部门信息更新成功",
  "data": {
    "id": 10,
    "user_id": 5,
    "department_id": 2,
    "position": "资深开发工程师",
    "is_primary": true,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-02T00:00:00Z"
  }
}
```

---

### 移除用户部门关联
**DELETE** `/api/user-departments/:id`

移除用户与部门的关联关系。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 用户部门关联ID

**响应示例：**
```json
{
  "message": "用户部门关联移除成功"
}
```

---

### 获取用户的所有部门
**GET** `/api/user-departments/user/:user_id`

获取指定用户所属的所有部门信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `user_id`: 用户ID

**响应示例：**
```json
{
  "data": [
    {
      "id": 10,
      "user_id": 5,
      "department_id": 2,
      "position": "高级开发工程师",
      "is_primary": true,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z",
      "user": {
        "id": 5,
        "username": "zhang.san",
        "email": "zhang.san@company.com"
      },
      "department": {
        "id": 2,
        "name": "技术部",
        "description": "负责技术开发"
      }
    },
    {
      "id": 11,
      "user_id": 5,
      "department_id": 4,
      "position": "技术专家",
      "is_primary": false,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z",
      "user": {
        "id": 5,
        "username": "zhang.san",
        "email": "zhang.san@company.com"
      },
      "department": {
        "id": 4,
        "name": "后端开发组",
        "description": "负责后端开发"
      }
    }
  ]
}
```

---

### 获取用户的主要部门
**GET** `/api/user-departments/user/:user_id/primary`

获取指定用户的主要部门信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `user_id`: 用户ID

**响应示例：**
```json
{
  "data": {
    "id": 10,
    "user_id": 5,
    "department_id": 2,
    "position": "高级开发工程师",
    "is_primary": true,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z",
    "user": {
      "id": 5,
      "username": "zhang.san",
      "email": "zhang.san@company.com"
    },
    "department": {
      "id": 2,
      "name": "技术部",
      "description": "负责技术开发"
    }
  }
}
```

---

### 获取部门的所有用户
**GET** `/api/user-departments/department/:department_id`

获取指定部门下的所有用户信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `department_id`: 部门ID

**响应示例：**
```json
{
  "data": [
    {
      "id": 10,
      "user_id": 5,
      "department_id": 2,
      "position": "高级开发工程师",
      "is_primary": true,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z",
      "user": {
        "id": 5,
        "username": "zhang.san",
        "email": "zhang.san@company.com"
      },
      "department": {
        "id": 2,
        "name": "技术部",
        "description": "负责技术开发"
      }
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
    "user_id": ["用户ID不能为空"],
    "department_id": ["部门ID不能为空"]
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
  "required": "user_department:create"
}
```

### 404 Not Found - 资源不存在
```json
{
  "error": "用户不存在"
}
```

```json
{
  "error": "部门不存在"
}
```

```json
{
  "error": "用户部门关联不存在"
}
```

### 409 Conflict - 资源冲突
```json
{
  "error": "用户已在该部门中"
}
```

## 使用示例

### 1. 为用户分配部门
```bash
curl -X POST http://localhost:3000/api/user-departments/assign \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 5,
    "department_id": 2,
    "position": "高级开发工程师",
    "is_primary": true
  }'
```

### 2. 批量分配用户
```bash
curl -X POST http://localhost:3000/api/user-departments/batch-assign \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_ids": [3, 4, 5],
    "department_id": 3,
    "position": "市场专员"
  }'
```

### 3. 获取用户的所有部门
```bash
curl -X GET http://localhost:3000/api/user-departments/user/5 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 4. 获取用户的主要部门
```bash
curl -X GET http://localhost:3000/api/user-departments/user/5/primary \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 5. 获取部门的所有用户
```bash
curl -X GET http://localhost:3000/api/user-departments/department/2 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 6. 更新用户部门信息
```bash
curl -X PUT http://localhost:3000/api/user-departments/10 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "position": "资深开发工程师",
    "is_primary": true
  }'
```

### 7. 移除用户部门关联
```bash
curl -X DELETE http://localhost:3000/api/user-departments/10 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 业务规则

### 主要部门规则
1. **唯一性**: 每个用户只能有一个主要部门
2. **自动更新**: 设置新的主要部门时，之前的主要部门自动变为非主要
3. **默认值**: 用户的第一个部门可以自动设为主要部门

### 重复分配检查
1. **唯一约束**: 同一用户不能重复分配到同一部门
2. **跳过处理**: 批量分配时会跳过已存在的关联
3. **错误提示**: 单个分配时会返回冲突错误

### 删除限制
1. **级联检查**: 删除用户或部门时需要处理相关关联
2. **主要部门**: 删除主要部门关联时建议用户重新设置主要部门
3. **最后部门**: 用户至少应该属于一个部门

### 职位设置
1. **可选字段**: 职位为可选字段，可以为空
2. **长度限制**: 职位名称最大100个字符
3. **灵活性**: 不同部门可以设置不同的职位

## 数据字段说明

### 基础字段
- `id`: 用户部门关联唯一标识符
- `user_id`: 用户ID
- `department_id`: 部门ID
- `created_at`: 创建时间
- `updated_at`: 更新时间

### 业务字段
- `position`: 用户在该部门的职位
- `is_primary`: 是否为用户的主要部门

### 关联数据
- `user`: 用户基本信息
- `department`: 部门基本信息

## 应用场景

### 典型使用场景
1. **入职分配**: 新员工入职时分配到相应部门
2. **职位调整**: 员工内部调动或职位变更
3. **兼职安排**: 员工在多个部门兼职工作
4. **项目协作**: 临时项目中跨部门协作
5. **组织重构**: 部门调整时的人员重新分配

### 权限建议
1. **HR权限**: HR人员通常需要所有用户部门管理权限
2. **部门经理**: 可以管理本部门的用户分配
3. **自助服务**: 用户可以查看自己的部门信息
4. **批量操作**: 限制批量操作权限给管理员
