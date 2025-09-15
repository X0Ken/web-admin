# 角色权限移除功能测试指南

## 功能概述

新增了为角色移除权限的接口，允许管理员从指定角色中移除特定权限。

## API接口

### 移除权限接口
**DELETE** `/api/roles/:id/permissions`

**请求头：**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**请求参数：**
```json
{
  "permission_id": 5
}
```

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

### 3. 查看角色当前权限
```bash
curl -X GET "http://localhost:3000/api/roles/2" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 4. 为角色分配权限（如果还没有）
```bash
curl -X POST "http://localhost:3000/api/roles/2/permissions" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "permission_id": 5
  }'
```

### 5. 移除权限
```bash
curl -X DELETE "http://localhost:3000/api/roles/2/permissions" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "permission_id": 5
  }'
```

### 6. 验证权限已移除
```bash
curl -X GET "http://localhost:3000/api/roles/2" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 预期响应

### 成功响应
```json
{
  "message": "权限移除成功"
}
```

### 错误响应示例

#### 权限不足
```json
{
  "error": "权限不足",
  "required": "role:update"
}
```

#### 角色不存在
```json
{
  "error": "移除权限失败",
  "message": "角色不存在"
}
```

#### 权限不存在
```json
{
  "error": "移除权限失败",
  "message": "权限不足"
}
```

#### 缺少参数
```json
{
  "error": "缺少permission_id参数"
}
```

## 测试场景

### 1. 正常移除权限
- 为角色分配一个权限
- 移除该权限
- 验证权限已从角色中移除

### 2. 移除不存在的权限关联
- 尝试移除一个角色从未拥有的权限
- 应该成功（幂等操作）

### 3. 权限验证
- 使用没有 `role:update` 权限的用户尝试移除权限
- 应该返回权限不足错误

### 4. 参数验证
- 不提供 `permission_id` 参数
- 应该返回参数错误

## 实现细节

### RBAC服务方法
```rust
pub async fn remove_permission_from_role(
    db: &DatabaseConnection,
    role_id: i32,
    permission_id: i32,
) -> Result<(), RbacError>
```

### 路由处理
- 路径：`DELETE /api/roles/:id/permissions`
- 权限要求：`role:update`
- 参数：`permission_id` (JSON body)

### 数据库操作
- 检查角色和权限是否存在
- 查找角色权限关联记录
- 删除关联记录（如果存在）

## 注意事项

1. **幂等性**: 多次移除同一个权限不会报错
2. **权限检查**: 需要 `role:update` 权限才能执行此操作
3. **数据完整性**: 移除权限后，相关用户的权限会立即失效
4. **级联影响**: 移除权限会影响所有拥有该角色的用户
