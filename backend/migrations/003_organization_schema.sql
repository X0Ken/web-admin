-- 创建部门表
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    parent_id INTEGER REFERENCES departments(id) ON DELETE CASCADE,
    level INTEGER NOT NULL DEFAULT 1,
    sort_order INTEGER NOT NULL DEFAULT 0,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 创建用户部门关联表
CREATE TABLE user_departments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    department_id INTEGER NOT NULL REFERENCES departments(id) ON DELETE CASCADE,
    position VARCHAR(100), -- 职位
    is_primary BOOLEAN DEFAULT false, -- 是否主要部门
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, department_id)
);

-- 创建索引
CREATE INDEX idx_departments_parent_id ON departments(parent_id);
CREATE INDEX idx_departments_code ON departments(code);
CREATE INDEX idx_departments_level ON departments(level);
CREATE INDEX idx_user_departments_user_id ON user_departments(user_id);
CREATE INDEX idx_user_departments_department_id ON user_departments(department_id);
CREATE INDEX idx_user_departments_primary ON user_departments(is_primary);

-- 添加触发器更新updated_at字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON departments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_departments_updated_at BEFORE UPDATE ON user_departments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
