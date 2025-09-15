# 分页功能测试指南

## 测试准备

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

## 分页功能测试

### 测试用户列表分页

#### 1. 获取第一页（默认参数）
```bash
curl -X GET "http://localhost:3000/api/users" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 2. 获取第二页，每页5条记录
```bash
curl -X GET "http://localhost:3000/api/users?page=2&per_page=5" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 3. 测试无效分页参数
```bash
curl -X GET "http://localhost:3000/api/users?page=0&per_page=200" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 测试角色列表分页

#### 1. 获取第一页
```bash
curl -X GET "http://localhost:3000/api/roles" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 2. 获取第二页，每页10条记录
```bash
curl -X GET "http://localhost:3000/api/roles?page=2&per_page=10" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 测试权限列表分页

#### 1. 获取第一页
```bash
curl -X GET "http://localhost:3000/api/permissions" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 2. 获取第二页，每页15条记录
```bash
curl -X GET "http://localhost:3000/api/permissions?page=2&per_page=15" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 预期响应格式

### 成功响应示例
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

### 错误响应示例
```json
{
  "error": "分页参数验证失败",
  "details": {
    "page": ["页码必须在1-100之间"],
    "per_page": ["每页数量必须在1-100之间"]
  }
}
```

## 测试要点

1. **默认参数**: 不传分页参数时，应该使用默认值（page=1, per_page=20）
2. **参数验证**: 页码和每页数量必须在1-100范围内
3. **分页计算**: 确保分页信息计算正确
4. **数据完整性**: 确保返回的数据是当前页的数据
5. **边界情况**: 测试最后一页、空数据等情况

## 性能考虑

- 分页查询使用了数据库的 `LIMIT` 和 `OFFSET` 功能
- 对于大数据量，建议添加适当的索引
- 可以考虑使用游标分页来优化性能
