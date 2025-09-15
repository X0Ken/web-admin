# 快速开始指南

本指南将帮助你在 5 分钟内快速部署和运行 Web Admin 管理系统。

## 前置要求

确保你的系统已安装以下软件：

- **Docker** (版本 20.0+)
- **Docker Compose** (版本 2.0+)
- **Git**

### 安装 Docker (如果未安装)

**Windows/macOS**:
下载并安装 [Docker Desktop](https://www.docker.com/products/docker-desktop)

**Linux (Ubuntu/Debian)**:
```bash
# 更新包索引
sudo apt update

# 安装必要的包
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release

# 添加 Docker 官方 GPG 密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加 Docker 仓库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动并启用 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 将用户添加到 docker 组
sudo usermod -aG docker $USER
```

## 🚀 一键部署

### 1. 克隆项目

```bash
git clone <your-repository-url>
cd web-admin
```

### 2. 配置环境变量 (可选)

复制环境变量示例文件：

```bash
cp env.example .env
```

编辑 `.env` 文件，修改必要的配置（如密码等）：

```bash
# 示例配置，请根据实际需要修改
POSTGRES_PASSWORD=your_strong_password
JWT_SECRET=your-super-secret-jwt-key
```

> 💡 **提示**: 对于快速体验，可以直接使用默认配置，系统会自动生成开发环境的默认密码。

### 3. 启动服务

```bash
# 启动所有服务
docker-compose up -d

# 查看启动状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 4. 等待服务就绪

系统需要几分钟时间来：
- 下载和构建镜像
- 初始化数据库
- 启动所有服务

你可以通过以下命令监控启动进度：

```bash
# 监控所有服务日志
docker-compose logs -f

# 或者只监控特定服务
docker-compose logs -f backend
```

### 5. 访问系统

服务启动完成后，你可以访问：

- **前端应用**: [http://localhost](http://localhost)
- **后端 API**: [http://localhost:3000](http://localhost:3000)
- **数据库管理** (可选): [http://localhost:5050](http://localhost:5050)

## 🔑 默认账户

系统初始化后会自动创建默认管理员账户：

- **用户名**: `admin`
- **密码**: `admin123`

> ⚠️ **安全提醒**: 生产环境中请立即修改默认密码！

## 📱 使用系统

### 登录系统

1. 打开浏览器访问 [http://localhost](http://localhost)
2. 使用默认账户登录：
   - 用户名: `admin`
   - 密码: `admin123`
3. 登录成功后将进入系统仪表盘

### 基本功能体验

**用户管理**:
- 点击侧边栏 "用户管理"
- 查看、创建、编辑、删除用户
- 为用户分配角色

**角色管理**:
- 点击侧边栏 "角色管理"
- 管理系统角色
- 为角色分配权限

**权限管理**:
- 点击侧边栏 "权限管理"
- 查看系统权限列表
- 管理资源权限

**系统设置**:
- 点击侧边栏 "系统设置"
- 配置系统参数
- 修改安全设置

## 🛠️ 常用命令

### 服务管理

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 重建并启动
docker-compose up -d --build

# 查看服务状态
docker-compose ps

# 查看资源使用情况
docker-compose top
```

### 日志查看

```bash
# 查看所有服务日志
docker-compose logs

# 实时跟踪日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs backend
docker-compose logs frontend
docker-compose logs postgres

# 查看最近50行日志
docker-compose logs --tail=50
```

### 数据管理

```bash
# 进入数据库容器
docker-compose exec postgres psql -U postgres -d rust_web_admin

# 备份数据库
docker-compose exec postgres pg_dump -U postgres rust_web_admin > backup.sql

# 恢复数据库
docker-compose exec -T postgres psql -U postgres rust_web_admin < backup.sql

# 查看数据库大小
docker-compose exec postgres psql -U postgres -c "SELECT pg_size_pretty(pg_database_size('rust_web_admin'));"
```

## 🔧 故障排除

### 常见问题

**1. 端口已被占用**

```bash
# 检查端口占用
netstat -tlnp | grep :80
netstat -tlnp | grep :3000

# 修改端口配置
# 编辑 docker-compose.yml 文件，修改端口映射
```

**2. 容器启动失败**

```bash
# 查看详细错误信息
docker-compose logs [service-name]

# 重新构建镜像
docker-compose build --no-cache

# 清理并重新启动
docker-compose down -v
docker-compose up -d
```

**3. 数据库连接失败**

```bash
# 检查数据库状态
docker-compose exec postgres pg_isready -U postgres

# 重置数据库
docker-compose down -v
docker-compose up -d postgres
# 等待数据库启动完成后
docker-compose up -d
```

**4. 前端无法访问后端**

检查网络配置和 CORS 设置：

```bash
# 检查后端健康状态
curl http://localhost:3000/health

# 检查容器网络
docker network ls
docker network inspect web-admin-network
```

### 获取帮助

如果遇到问题，可以通过以下方式获取帮助：

1. **查看完整日志**: `docker-compose logs`
2. **检查系统资源**: `docker system df`
3. **重置环境**: `docker-compose down -v && docker-compose up -d`
4. **提交 Issue**: [GitHub Issues](https://github.com/your-repo/issues)

## 📚 下一步

恭喜！你已经成功部署了 Web Admin 系统。接下来你可以：

- 📖 阅读 [API 文档](../api/) 了解接口详情
- 🏗️ 查看 [架构文档](../architecture/) 了解系统设计
- 💻 参考 [开发指南](../development/) 进行二次开发
- 🚀 查看 [生产部署](./production.md) 了解生产环境配置

---

*如有问题，请查看 [故障排除指南](./troubleshooting.md) 或 [联系我们](mailto:admin@yourdomain.com)。*
