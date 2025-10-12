-- ====================================
-- 初始数据
-- ====================================

-- ====================================
-- 插入默认权限
-- ====================================
INSERT INTO permissions (name, description, resource, action) VALUES
('用户查看', '查看用户列表和详情', 'user', 'read'),
('用户创建', '创建新用户', 'user', 'create'),
('用户更新', '更新用户信息', 'user', 'update'),
('用户删除', '删除用户', 'user', 'delete'),
('角色查看', '查看角色列表和详情', 'role', 'read'),
('角色创建', '创建新角色', 'role', 'create'),
('角色更新', '更新角色信息', 'role', 'update'),
('角色删除', '删除角色', 'role', 'delete'),
('权限查看', '查看权限列表和详情', 'permission', 'read'),
('权限创建', '创建新权限', 'permission', 'create'),
('权限更新', '更新权限信息', 'permission', 'update'),
('权限删除', '删除权限', 'permission', 'delete');

-- ====================================
-- 插入默认角色
-- ====================================
INSERT INTO roles (name, description) VALUES
('超级管理员', '拥有所有权限的超级管理员'),
('管理员', '拥有大部分管理权限'),
('普通用户', '基本用户权限');

-- ====================================
-- 分配角色权限
-- ====================================

-- 为超级管理员角色分配所有权限
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions;

-- 为管理员角色分配用户和角色管理权限
INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, id FROM permissions WHERE resource IN ('user', 'role');

-- 为普通用户角色分配基本查看权限
INSERT INTO role_permissions (role_id, permission_id)
SELECT 3, id FROM permissions WHERE action = 'read' AND resource = 'user';

-- ====================================
-- 创建默认超级管理员用户
-- ====================================

-- 创建默认超级管理员用户 (用户名: admin, 密码: admin123)
INSERT INTO users (username, email, password_hash) VALUES
('admin', 'admin@example.com', '$2b$12$w12rU8A9BZZc5WilBBLs7.QOFB99ubwM8LhGru96AOx0EMweSMnkS');

-- 为默认管理员分配超级管理员角色
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1);

-- ====================================
-- 插入示例部门数据
-- ====================================
INSERT INTO departments (name, code, parent_id, level, sort_order, description, is_active) VALUES
('总公司', 'HQ', NULL, 1, 1, '公司总部', true),
('技术部', 'TECH', 1, 2, 1, '负责技术研发', true),
('市场部', 'MARKET', 1, 2, 2, '负责市场营销', true),
('人事部', 'HR', 1, 2, 3, '负责人力资源', true),
('财务部', 'FINANCE', 1, 2, 4, '负责财务管理', true),
('前端组', 'FRONTEND', 2, 3, 1, '前端开发团队', true),
('后端组', 'BACKEND', 2, 3, 2, '后端开发团队', true),
('测试组', 'QA', 2, 3, 3, '质量保证团队', true),
('产品组', 'PRODUCT', 2, 3, 4, '产品设计团队', true),
('销售组', 'SALES', 3, 3, 1, '销售团队', true),
('推广组', 'PROMOTION', 3, 3, 2, '市场推广团队', true);

-- ====================================
-- 为默认用户分配部门（可选）
-- ====================================
-- 如果需要为默认管理员用户分配部门，可以取消注释以下语句：
-- INSERT INTO user_departments (user_id, department_id, position, is_primary) VALUES
-- (1, 1, '系统管理员', true);
