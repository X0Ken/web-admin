# 通用说明文档

## 通用错误响应

所有API接口都遵循统一的错误响应格式，帮助客户端正确处理各种异常情况。

### 400 Bad Request - 请求参数错误
当请求参数验证失败时返回此错误。

**参数验证失败：**
```json
{
  "error": "验证失败",
  "details": {
    "username": ["用户名长度必须在3-50个字符之间"],
    "email": ["邮箱格式不正确"]
  }
}
```

**分页参数验证失败：**
```json
{
  "error": "分页参数验证失败",
  "details": {
    "page": ["页码必须在1-100之间"],
    "per_page": ["每页数量必须在1-100之间"]
  }
}
```

### 401 Unauthorized - 认证失败
当未提供认证令牌或令牌无效时返回此错误。

```json
{
  "error": "未提供有效的认证令牌"
}
```

**令牌过期：**
```json
{
  "error": "认证令牌已过期"
}
```

### 403 Forbidden - 权限不足
当用户没有执行特定操作的权限时返回此错误。

```json
{
  "error": "权限不足",
  "required": "user:create"
}
```

### 404 Not Found - 资源不存在
当请求的资源不存在时返回此错误。

```json
{
  "error": "用户不存在"
}
```

### 409 Conflict - 资源冲突
当资源存在冲突（如重复的唯一字段）时返回此错误。

```json
{
  "error": "用户名已存在"
}
```

### 422 Unprocessable Entity - 业务规则冲突
当请求在语法上正确，但违反业务规则时返回此错误。

```json
{
  "error": "无法删除角色，仍有用户使用该角色"
}
```

### 500 Internal Server Error - 服务器内部错误
当服务器发生意外错误时返回此错误。

```json
{
  "error": "数据库错误",
  "message": "详细错误信息"
}
```

---

## 权限系统说明

### 权限格式
权限采用 `资源:操作` 的格式：

**基础权限：**
- `user:read` - 用户查看权限
- `user:create` - 用户创建权限
- `user:update` - 用户更新权限
- `user:delete` - 用户删除权限
- `role:read` - 角色查看权限
- `role:create` - 角色创建权限
- `role:update` - 角色更新权限
- `role:delete` - 角色删除权限
- `permission:read` - 权限查看权限
- `permission:create` - 权限创建权限
- `permission:update` - 权限更新权限
- `permission:delete` - 权限删除权限

**组织架构权限：**
- `department:read` - 部门查看权限
- `department:create` - 部门创建权限
- `department:update` - 部门更新权限
- `department:delete` - 部门删除权限
- `user_department:read` - 用户部门关联查看权限
- `user_department:create` - 用户部门关联创建权限
- `user_department:update` - 用户部门关联更新权限
- `user_department:delete` - 用户部门关联删除权限

### 默认角色权限
- **超级管理员 (super_admin)**: 拥有所有权限
- **管理员 (admin)**: 拥有用户、角色和部门管理权限
- **普通用户 (user)**: 拥有基本查看权限

### 权限检查机制
1. **认证流程**: 客户端在请求头中提供JWT令牌：`Authorization: Bearer <token>`
2. **权限验证**: 系统检查用户是否拥有执行特定操作所需的权限
3. **角色继承**: 用户通过角色获得权限，一个用户可以拥有多个角色

---

## 分页功能说明

### 分页参数
所有列表接口都支持分页功能，通过查询参数控制：

- `page`: 页码，从1开始，默认为1，范围1-100
- `per_page`: 每页数量，默认为20，范围1-100

### 分页响应格式
分页接口的响应包含两个部分：
- `data`: 当前页的数据列表
- `pagination`: 分页信息

```json
{
  "data": [
    // 数据列表
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 20,
    "total": 100,
    "total_pages": 5,
    "has_next": true,
    "has_prev": false
  }
}
```

### 分页信息字段
- `current_page`: 当前页码
- `per_page`: 每页数量
- `total`: 总记录数
- `total_pages`: 总页数
- `has_next`: 是否有下一页
- `has_prev`: 是否有上一页

### 使用示例
```bash
# 获取第2页数据，每页10条记录
GET /api/users?page=2&per_page=10

# 使用默认分页参数
GET /api/users
```

---

## 请求头规范

### 必需的请求头
对于需要认证的接口：
```
Authorization: Bearer YOUR_JWT_TOKEN
```

对于发送JSON数据的接口：
```
Content-Type: application/json
```

### 完整示例
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'
```

---

## 响应格式规范

### 成功响应
**单个资源：**
```json
{
  "message": "操作成功",
  "user": {
    "id": 1,
    "username": "admin"
  }
}
```

**资源列表：**
```json
{
  "data": [
    // 资源数组
  ],
  "pagination": {
    // 分页信息
  }
}
```

### 错误响应
```json
{
  "error": "错误描述",
  "details": {
    // 详细错误信息（可选）
  }
}
```

---

## 数据验证规则

### 通用字段验证
- **ID字段**: 正整数
- **名称字段**: 通常3-50个字符
- **描述字段**: 通常最大255个字符
- **邮箱字段**: 必须符合邮箱格式
- **密码字段**: 至少6个字符
- **布尔字段**: true或false

### 自定义验证
某些字段可能有特殊的验证规则，具体见各接口文档。

---

## 安全说明

### 认证安全
1. JWT令牌默认24小时有效
2. 令牌过期后需要重新登录
3. 建议在生产环境中使用HTTPS

### 密码安全
1. 密码使用bcrypt进行哈希存储
2. 建议设置密码复杂度要求
3. 支持密码强度验证

### 请求限制
1. 建议对登录接口实施频率限制
2. 可以设置API调用频率限制
3. 大批量操作建议分批处理

### CORS设置
开发环境下允许跨域请求，生产环境建议配置适当的CORS策略。
