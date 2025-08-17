# 使用官方的轻量化镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器中
COPY . /app

# 安装依赖（如果有 requirements.txt）
RUN pip install --no-cache-dir -r requirements.txt || true

# 设置容器启动命令
CMD ["python", "app.py"]
