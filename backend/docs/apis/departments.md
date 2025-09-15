# 部门管理接口 API

## 概述

部门管理模块提供企业组织架构中部门的完整管理功能，包括部门的增删改查、树形结构管理等。支持多级部门层次结构。

**所需权限：**
- 查看部门: `department:read`
- 创建部门: `department:create`
- 更新部门: `department:update`
- 删除部门: `department:delete`

## 接口列表

### 获取部门列表
**GET** `/api/departments`

获取系统中所有部门的平铺列表。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**响应示例：**
```json
{
  "data": [
    {
      "id": 1,
      "name": "总公司",
      "description": "公司根部门",
      "parent_id": null,
      "manager_id": null,
      "sort_order": 1,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    },
    {
      "id": 2,
      "name": "技术部",
      "description": "负责技术开发",
      "parent_id": 1,
      "manager_id": 5,
      "sort_order": 1,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

### 获取部门树形结构
**GET** `/api/departments/tree`

获取部门的层级树形结构，便于组织架构展示。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**响应示例：**
```json
{
  "data": [
    {
      "id": 1,
      "name": "总公司",
      "description": "公司根部门",
      "parent_id": null,
      "manager_id": null,
      "sort_order": 1,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z",
      "children": [
        {
          "id": 2,
          "name": "技术部",
          "description": "负责技术开发",
          "parent_id": 1,
          "manager_id": 5,
          "sort_order": 1,
          "created_at": "2024-01-01T00:00:00Z",
          "updated_at": "2024-01-01T00:00:00Z",
          "children": [
            {
              "id": 4,
              "name": "后端开发组",
              "description": "负责后端开发",
              "parent_id": 2,
              "manager_id": null,
              "sort_order": 1,
              "created_at": "2024-01-01T00:00:00Z",
              "updated_at": "2024-01-01T00:00:00Z",
              "children": []
            }
          ]
        }
      ]
    }
  ]
}
```

---

### 获取部门详情
**GET** `/api/departments/:id`

获取指定部门的详细信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 部门ID

**响应示例：**
```json
{
  "data": {
    "id": 2,
    "name": "技术部",
    "description": "负责技术开发",
    "parent_id": 1,
    "manager_id": 5,
    "sort_order": 1,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

---

### 创建部门
**POST** `/api/departments`

创建新部门。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**请求参数：**
```json
{
  "name": "技术部",
  "description": "负责技术开发",
  "parent_id": 1,
  "manager_id": 5,
  "sort_order": 1
}
```

**参数说明：**
- `name` (必填): 部门名称，2-100个字符
- `description` (可选): 部门描述，最大500个字符
- `parent_id` (可选): 父部门ID，null表示根部门
- `manager_id` (可选): 部门经理用户ID
- `sort_order` (可选): 排序序号，默认为0

**响应示例：**
```json
{
  "message": "部门创建成功",
  "data": {
    "id": 6,
    "name": "技术部",
    "description": "负责技术开发",
    "parent_id": 1,
    "manager_id": 5,
    "sort_order": 1,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
}
```

---

### 更新部门
**PUT** `/api/departments/:id`

更新部门信息。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**路径参数：**
- `id`: 部门ID

**请求参数：**
```json
{
  "name": "技术研发部",
  "description": "负责技术研发和创新",
  "manager_id": 6,
  "sort_order": 2
}
```

**参数说明：**
- `name` (可选): 部门名称
- `description` (可选): 部门描述
- `parent_id` (可选): 父部门ID
- `manager_id` (可选): 部门经理用户ID
- `sort_order` (可选): 排序序号

**响应示例：**
```json
{
  "message": "部门更新成功",
  "data": {
    "id": 2,
    "name": "技术研发部",
    "description": "负责技术研发和创新",
    "parent_id": 1,
    "manager_id": 6,
    "sort_order": 2,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-02T00:00:00Z"
  }
}
```

---

### 删除部门
**DELETE** `/api/departments/:id`

删除指定部门。

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**路径参数：**
- `id`: 部门ID

**响应示例：**
```json
{
  "message": "部门删除成功"
}
```

**注意事项：**
- 只能删除没有子部门的部门（叶子节点）
- 删除前会检查是否有用户关联到该部门
- 建议先将部门下的用户转移到其他部门

## 常见错误

### 400 Bad Request - 参数验证失败
```json
{
  "error": "验证失败",
  "details": {
    "name": ["部门名称长度必须在2-100个字符之间"]
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
  "required": "department:create"
}
```

### 404 Not Found - 部门不存在
```json
{
  "error": "部门不存在"
}
```

### 409 Conflict - 业务规则冲突
```json
{
  "error": "部门名称在同一父部门下已存在"
}
```

### 422 Unprocessable Entity - 业务规则冲突
```json
{
  "error": "无法删除部门，该部门下还有子部门"
}
```

```json
{
  "error": "无法删除部门，该部门下还有用户"
}
```

```json
{
  "error": "无法设置父部门，会造成循环引用"
}
```

## 使用示例

### 1. 获取部门列表
```bash
curl -X GET http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 2. 获取部门树形结构
```bash
curl -X GET http://localhost:3000/api/departments/tree \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 3. 创建根部门
```bash
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "总公司",
    "description": "公司根部门",
    "parent_id": null,
    "sort_order": 1
  }'
```

### 4. 创建子部门
```bash
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "技术部",
    "description": "负责技术开发",
    "parent_id": 1,
    "manager_id": 5,
    "sort_order": 1
  }'
```

### 5. 更新部门信息
```bash
curl -X PUT http://localhost:3000/api/departments/2 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "技术研发部",
    "description": "负责技术研发和创新"
  }'
```

### 6. 删除部门
```bash
curl -X DELETE http://localhost:3000/api/departments/6 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 业务规则

### 层级结构
1. **根部门**: parent_id为null的部门为根部门
2. **子部门**: 通过parent_id关联到父部门
3. **深度限制**: 建议部门层级不超过5级
4. **循环检查**: 系统会防止创建循环引用的部门结构

### 命名规则
1. **唯一性**: 在同一父部门下，部门名称必须唯一
2. **长度限制**: 部门名称2-100个字符
3. **特殊字符**: 可以包含中文、英文、数字和常见符号

### 排序规则
1. **同级排序**: 同一父部门下的子部门按sort_order排序
2. **默认值**: 新创建的部门sort_order默认为0
3. **手动调整**: 可以通过更新接口调整排序

### 删除规则
1. **叶子节点**: 只能删除没有子部门的部门
2. **用户检查**: 删除前检查是否有用户关联
3. **级联操作**: 建议先处理关联数据再删除部门

### 经理设置
1. **可选字段**: manager_id为可选字段
2. **用户验证**: 设置的经理必须是系统中存在的用户
3. **权限建议**: 部门经理通常需要相应的管理权限

## 数据字段说明

### 基础字段
- `id`: 部门唯一标识符
- `name`: 部门名称
- `description`: 部门描述
- `created_at`: 创建时间
- `updated_at`: 更新时间

### 关联字段
- `parent_id`: 父部门ID，null表示根部门
- `manager_id`: 部门经理用户ID，可以为null

### 扩展字段
- `sort_order`: 排序序号，用于同级部门排序
- `children`: 在树形结构中表示子部门列表
