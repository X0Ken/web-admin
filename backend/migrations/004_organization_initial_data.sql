-- 插入示例部门数据
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

-- 为现有用户分配部门（假设已有用户ID为1的管理员）
-- 注意：这里需要根据实际的用户ID进行调整
-- INSERT INTO user_departments (user_id, department_id, position, is_primary) VALUES
-- (1, 1, '系统管理员', true);
