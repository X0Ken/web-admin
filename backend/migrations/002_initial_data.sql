-- 插入默认权限
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

-- 插入默认角色
INSERT INTO roles (name, description) VALUES
('超级管理员', '拥有所有权限的超级管理员'),
('管理员', '拥有大部分管理权限'),
('普通用户', '基本用户权限');

-- 为超级管理员角色分配所有权限
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions;

-- 为管理员角色分配用户和角色管理权限
INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, id FROM permissions WHERE resource IN ('user', 'role');

-- 为普通用户角色分配基本查看权限
INSERT INTO role_permissions (role_id, permission_id)
SELECT 3, id FROM permissions WHERE action = 'read' AND resource = 'user';

-- 创建默认超级管理员用户 (密码: admin123)
INSERT INTO users (username, email, password_hash) VALUES
('admin', 'admin@example.com', '$2b$12$w12rU8A9BZZc5WilBBLs7.QOFB99ubwM8LhGru96AOx0EMweSMnkS');

-- 为默认管理员分配超级管理员角色
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1);
