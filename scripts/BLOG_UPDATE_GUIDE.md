# Blog 更新脚本使用指南

## 快速使用

### 基本用法
```bash
# 更新blog并提交
./scripts/update_blog.sh "添加新文章: AI摄像头应用开发指南"

# 强制更新（跳过确认）
./scripts/update_blog.sh -f "更新博客配置"
```

### 查看状态
```bash
# 查看blog目录状态
./scripts/update_blog.sh -s

# 查看blog目录的更改
./scripts/update_blog.sh -d

# 测试blog构建
./scripts/update_blog.sh -t
```

### 获取帮助
```bash
./scripts/update_blog.sh -h
```

## 常用场景

### 1. 添加新文章
```bash
# 创建新文章后
./scripts/update_blog.sh "添加新文章: [文章标题]"
```

### 2. 修改配置
```bash
# 修改_config.yml后
./scripts/update_blog.sh "更新博客配置"
```

### 3. 修改样式
```bash
# 修改CSS后
./scripts/update_blog.sh "更新博客样式"
```

### 4. 批量更新
```bash
# 更新整个blog目录
./scripts/update_blog.sh "更新博客内容"
```

## 脚本功能

- ✅ 自动检查blog目录状态
- ✅ 显示详细的更改信息
- ✅ 确认提交（可跳过）
- ✅ 自动构建测试
- ✅ 一键推送到GitHub
- ✅ 彩色日志输出
- ✅ 错误处理和回滚

## 注意事项

1. 确保在项目根目录运行脚本
2. 提交信息要简洁明了
3. 建议先测试构建再提交
4. 推送后需要等待几分钟才能看到更新

---

*最后更新: 2025-08-27*
