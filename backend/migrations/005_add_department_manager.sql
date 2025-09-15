-- 添加部门经理字段
ALTER TABLE departments ADD COLUMN manager_id INTEGER REFERENCES users(id) ON DELETE SET NULL;

-- 创建索引
CREATE INDEX idx_departments_manager_id ON departments(manager_id);

-- 添加注释
COMMENT ON COLUMN departments.manager_id IS '部门经理用户ID';
