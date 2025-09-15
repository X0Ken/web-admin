# 组织架构测试指南

## 项目状态
✅ 部门管理模块已实现
✅ 用户部门关联模块已实现
✅ 权限检查已集成
✅ 数据库迁移已完成

## 测试概述

本指南涵盖组织架构的完整测试流程，包括：
- 部门管理（创建、查询、更新、删除）
- 用户部门关联（分配、批量分配、主要部门设置）
- 部门树形结构
- 权限验证

## 前置条件

### 1. 启动服务器
```bash
cargo run
```

### 2. 获取认证令牌
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'
```

保存返回的JWT令牌，后续所有测试都需要使用。

## 部门管理API测试

### 1. 创建根部门
```bash
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "总公司",
    "description": "公司根部门",
    "parent_id": null,
    "manager_id": null,
    "sort_order": 1
  }'
```

**预期结果：**
- 状态码：200
- 返回创建的部门信息
- 包含部门ID

### 2. 创建子部门
```bash
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "技术部",
    "description": "负责技术开发",
    "parent_id": 1,
    "manager_id": null,
    "sort_order": 1
  }'
```

```bash
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "市场部",
    "description": "负责市场营销",
    "parent_id": 1,
    "manager_id": null,
    "sort_order": 2
  }'
```

### 3. 创建更深层级的子部门
```bash
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "后端开发组",
    "description": "负责后端开发",
    "parent_id": 2,
    "manager_id": null,
    "sort_order": 1
  }'
```

```bash
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "前端开发组",
    "description": "负责前端开发",
    "parent_id": 2,
    "manager_id": null,
    "sort_order": 2
  }'
```

### 4. 获取部门列表
```bash
curl -X GET http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**预期结果：**
- 返回所有部门的平铺列表
- 包含每个部门的完整信息

### 5. 获取部门树形结构
```bash
curl -X GET http://localhost:3000/api/departments/tree \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**预期结果：**
- 返回层级结构的部门树
- 子部门嵌套在父部门的children字段中
- 按sort_order排序

### 6. 获取单个部门详情
```bash
curl -X GET http://localhost:3000/api/departments/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 7. 更新部门信息
```bash
curl -X PUT http://localhost:3000/api/departments/2 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "技术研发部",
    "description": "负责技术研发和创新",
    "sort_order": 1
  }'
```

### 8. 删除部门
```bash
# 先删除叶子节点
curl -X DELETE http://localhost:3000/api/departments/4 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# 尝试删除有子部门的部门（应该失败）
curl -X DELETE http://localhost:3000/api/departments/2 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**预期结果：**
- 删除叶子节点成功
- 删除有子部门的部门失败，返回错误信息

## 用户部门关联API测试

### 前置条件：创建测试用户
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "zhang.san",
    "email": "zhang.san@company.com",
    "password": "password123"
  }'

curl -X POST http://localhost:3000/api/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "li.si",
    "email": "li.si@company.com",
    "password": "password123"
  }'
```

### 1. 为用户分配部门
```bash
curl -X POST http://localhost:3000/api/user-departments/assign \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 2,
    "department_id": 2,
    "position": "高级开发工程师",
    "is_primary": true
  }'
```

### 2. 为用户分配多个部门
```bash
curl -X POST http://localhost:3000/api/user-departments/assign \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 2,
    "department_id": 4,
    "position": "技术专家",
    "is_primary": false
  }'
```

### 3. 批量分配用户到部门
```bash
curl -X POST http://localhost:3000/api/user-departments/batch-assign \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_ids": [3, 4],
    "department_id": 3,
    "position": "市场专员"
  }'
```

### 4. 获取用户的所有部门
```bash
curl -X GET http://localhost:3000/api/user-departments/user/2 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**预期结果：**
- 返回用户所属的所有部门
- 包含部门信息和职位信息
- 显示主要部门标识

### 5. 获取用户的主要部门
```bash
curl -X GET http://localhost:3000/api/user-departments/user/2/primary \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 6. 获取部门的所有用户
```bash
curl -X GET http://localhost:3000/api/user-departments/department/2 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**预期结果：**
- 返回部门下的所有用户
- 包含用户信息和职位信息

### 7. 更新用户部门信息
```bash
curl -X PUT http://localhost:3000/api/user-departments/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "position": "资深开发工程师",
    "is_primary": true
  }'
```

### 8. 移除用户部门关联
```bash
curl -X DELETE http://localhost:3000/api/user-departments/2 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 边界条件测试

### 1. 循环引用测试
```bash
# 尝试将根部门的父部门设为其子部门（应该失败）
curl -X PUT http://localhost:3000/api/departments/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "parent_id": 2
  }'
```

### 2. 重复分配测试
```bash
# 尝试将同一用户分配到同一部门两次（应该失败）
curl -X POST http://localhost:3000/api/user-departments/assign \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 2,
    "department_id": 2,
    "position": "开发工程师",
    "is_primary": false
  }'
```

### 3. 不存在的资源测试
```bash
# 分配不存在的用户到部门
curl -X POST http://localhost:3000/api/user-departments/assign \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 999,
    "department_id": 2,
    "position": "测试职位",
    "is_primary": false
  }'

# 分配用户到不存在的部门
curl -X POST http://localhost:3000/api/user-departments/assign \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 2,
    "department_id": 999,
    "position": "测试职位",
    "is_primary": false
  }'
```

### 4. 主要部门唯一性测试
```bash
# 设置用户的另一个部门为主要部门，验证之前的主要部门自动变为非主要
curl -X PUT http://localhost:3000/api/user-departments/3 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "is_primary": true
  }'

# 验证用户只有一个主要部门
curl -X GET http://localhost:3000/api/user-departments/user/2 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 权限验证测试

### 1. 无认证访问测试
```bash
# 不提供JWT令牌
curl -X GET http://localhost:3000/api/departments
```

**预期结果：** 401 Unauthorized

### 2. 无效令牌测试
```bash
# 使用无效JWT令牌
curl -X GET http://localhost:3000/api/departments \
  -H "Authorization: Bearer invalid_token"
```

**预期结果：** 401 Unauthorized

### 3. 权限不足测试
```bash
# 使用只有读权限的用户尝试创建部门
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer LIMITED_USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "测试部门",
    "description": "测试描述"
  }'
```

**预期结果：** 403 Forbidden

## 数据验证测试

### 1. 必填字段验证
```bash
# 创建部门时缺少必填字段
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "description": "缺少名称的部门"
  }'
```

**预期结果：** 400 Bad Request，包含验证错误信息

### 2. 字段长度验证
```bash
# 部门名称过长
curl -X POST http://localhost:3000/api/departments \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "这是一个非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常长的部门名称",
    "description": "测试描述"
  }'
```

### 3. 数据类型验证
```bash
# 提供错误的数据类型
curl -X POST http://localhost:3000/api/user-departments/assign \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "not_a_number",
    "department_id": 2,
    "position": "测试职位",
    "is_primary": "not_a_boolean"
  }'
```

## 性能测试建议

### 1. 大量部门的树形结构查询
- 创建100+个部门，测试树形结构查询性能
- 监控内存使用和响应时间

### 2. 批量用户分配
- 批量分配50+用户到同一部门
- 测试事务处理和数据一致性

### 3. 并发操作测试
- 同时进行多个部门创建/更新操作
- 测试数据库锁和并发控制

## 测试数据清理

完成测试后，可以通过以下方式清理测试数据：

```bash
# 删除用户部门关联
curl -X DELETE http://localhost:3000/api/user-departments/{id} \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# 删除部门（从叶子节点开始）
curl -X DELETE http://localhost:3000/api/departments/{id} \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# 删除用户
curl -X DELETE http://localhost:3000/api/users/{id} \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 注意事项

1. **测试顺序**：按照文档顺序执行测试，某些测试依赖前面的数据
2. **数据一致性**：注意验证关联数据的一致性
3. **错误处理**：重点测试各种错误情况的处理
4. **性能监控**：关注复杂查询的性能表现
5. **事务完整性**：验证失败操作不会影响数据完整性

## 常见问题

### 1. 部门树形结构不正确
- 检查parent_id设置是否正确
- 验证是否存在循环引用
- 确认sort_order设置

### 2. 用户部门关联失败
- 确认用户和部门都存在
- 检查是否已存在相同关联
- 验证权限设置

### 3. 主要部门设置异常
- 检查用户是否只有一个主要部门
- 验证更新操作的原子性

### 4. 权限检查失败
- 确认JWT令牌有效
- 检查用户权限配置
- 验证权限中间件正常工作
