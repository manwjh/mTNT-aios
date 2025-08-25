# mTNT OS 博客

这是 mTNT OS 项目的 Jekyll 博客，位于 `blog/` 目录中。

## 📁 博客结构

```
blog/
├── _config.yml              # Jekyll 配置文件
├── Gemfile                   # Ruby 依赖文件
├── README.md                # 博客使用说明
├── _posts/                  # 博客文章
│   └── 2025-08-27-mtnt-os-v1-1-0-released.md
└── assets/                  # 静态资源
    ├── images/             # 图片文件
    └── css/                # CSS 样式
```

## 🚀 快速开始

### 本地运行

1. **进入博客目录**
   ```bash
   cd blog
   ```

2. **安装依赖**
   ```bash
   bundle install
   ```

3. **启动本地服务器**
   ```bash
   bundle exec jekyll serve
   ```

4. **访问博客**
   打开浏览器访问: http://localhost:4000/mTNT-aios/

## ✍️ 添加新文章

在 `blog/_posts/` 目录下创建新的Markdown文件：

```markdown
---
title: "文章标题"
date: YYYY-MM-DD
categories:
  - 分类
tags:
  - 标签
---

# 文章内容
```

## 📦 部署

推送到GitHub后，博客将自动部署到 https://manwjh.github.io/mTNT-aios/

## 📚 更多信息

详细的使用说明请查看 `blog/README.md` 文件。

---

*最后更新: 2025-08-27*
