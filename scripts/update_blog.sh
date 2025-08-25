#!/bin/bash

# 文件创建日期: 2025-08-27
# File creation date: 2025-08-27
# Blog更新脚本 / Blog update script

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示帮助信息
show_help() {
    echo "mTNT OS Blog 更新脚本"
    echo ""
    echo "用法: $0 [选项] [提交信息]"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -s, --status   显示blog目录状态"
    echo "  -d, --diff     显示blog目录的更改"
    echo "  -t, --test     测试blog构建"
    echo "  -f, --force    强制提交（跳过确认）"
    echo ""
    echo "示例:"
    echo "  $0 \"添加新文章: AI摄像头应用开发指南\""
    echo "  $0 -s"
    echo "  $0 -d"
    echo "  $0 -t"
    echo "  $0 -f \"更新博客配置\""
}

# 检查blog目录是否存在
check_blog_dir() {
    if [ ! -d "blog" ]; then
        log_error "blog目录不存在！"
        exit 1
    fi
}

# 显示blog状态
show_status() {
    log_info "检查blog目录状态..."
    echo ""
    git status blog/
    echo ""
    
    # 显示未跟踪的文件
    untracked=$(git status --porcelain blog/ | grep "^??" | wc -l)
    if [ $untracked -gt 0 ]; then
        log_warning "发现 $untracked 个未跟踪的文件"
    fi
    
    # 显示已修改的文件
    modified=$(git status --porcelain blog/ | grep "^ M" | wc -l)
    if [ $modified -gt 0 ]; then
        log_warning "发现 $modified 个已修改的文件"
    fi
    
    # 显示已暂存的文件
    staged=$(git status --porcelain blog/ | grep "^M " | wc -l)
    if [ $staged -gt 0 ]; then
        log_success "发现 $staged 个已暂存的文件"
    fi
}

# 显示blog更改
show_diff() {
    log_info "显示blog目录的更改..."
    echo ""
    git diff blog/
    echo ""
    
    # 显示暂存区的更改
    if git diff --cached --name-only | grep -q "^blog/"; then
        log_info "暂存区的更改:"
        git diff --cached blog/
    fi
}

# 测试blog构建
test_build() {
    log_info "测试blog构建..."
    
    # 检查是否在blog目录中
    if [ ! -f "blog/Gemfile" ]; then
        log_error "未找到blog/Gemfile，请确保在正确的目录中运行"
        exit 1
    fi
    
    # 进入blog目录
    cd blog
    
    # 检查Ruby和Jekyll
    if ! command -v ruby &> /dev/null; then
        log_error "Ruby未安装，请先安装Ruby"
        exit 1
    fi
    
    if ! command -v bundle &> /dev/null; then
        log_error "Bundler未安装，请运行: gem install bundler"
        exit 1
    fi
    
    # 安装依赖
    log_info "安装依赖..."
    bundle install --quiet
    
    # 构建blog
    log_info "构建blog..."
    if bundle exec jekyll build --quiet; then
        log_success "Blog构建成功！"
        
        # 显示构建信息
        if [ -d "_site" ]; then
            site_size=$(du -sh _site | cut -f1)
            log_info "构建的网站大小: $site_size"
        fi
    else
        log_error "Blog构建失败！"
        exit 1
    fi
    
    # 返回原目录
    cd ..
}

# 确认提交
confirm_commit() {
    local commit_msg="$1"
    
    echo ""
    log_warning "即将提交以下更改:"
    echo "提交信息: $commit_msg"
    echo ""
    
    # 显示将要提交的文件
    git status --porcelain blog/ | while read line; do
        status=${line:0:2}
        file=${line:3}
        case $status in
            "M ") echo "  修改: $file" ;;
            "A ") echo "  添加: $file" ;;
            "D ") echo "  删除: $file" ;;
            "R ") echo "  重命名: $file" ;;
            "C ") echo "  复制: $file" ;;
            "??") echo "  新文件: $file" ;;
        esac
    done
    
    echo ""
    read -p "确认提交？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_warning "取消提交"
        exit 0
    fi
}

# 执行blog更新
update_blog() {
    local commit_msg="$1"
    local force="$2"
    
    log_info "开始更新blog..."
    
    # 检查blog目录
    check_blog_dir
    
    # 检查是否有更改
    if git diff --quiet blog/ && git diff --cached --quiet blog/; then
        log_warning "blog目录没有更改"
        exit 0
    fi
    
    # 如果不是强制模式，需要确认
    if [ "$force" != "true" ]; then
        confirm_commit "$commit_msg"
    fi
    
    # 添加blog目录的更改
    log_info "添加blog目录的更改..."
    git add blog/
    
    # 提交更改
    log_info "提交更改..."
    if git commit -m "$commit_msg"; then
        log_success "提交成功！"
    else
        log_error "提交失败！"
        exit 1
    fi
    
    # 推送到远程仓库
    log_info "推送到远程仓库..."
    if git push origin main; then
        log_success "推送成功！"
        log_info "Blog将在几分钟后更新到: https://manwjh.github.io/mTNT-aios/"
    else
        log_error "推送失败！"
        exit 1
    fi
}

# 主函数
main() {
    local action="update"
    local commit_msg=""
    local force="false"
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -s|--status)
                action="status"
                shift
                ;;
            -d|--diff)
                action="diff"
                shift
                ;;
            -t|--test)
                action="test"
                shift
                ;;
            -f|--force)
                force="true"
                shift
                ;;
            -*)
                log_error "未知选项: $1"
                show_help
                exit 1
                ;;
            *)
                commit_msg="$1"
                shift
                ;;
        esac
    done
    
    # 执行相应的操作
    case $action in
        "status")
            show_status
            ;;
        "diff")
            show_diff
            ;;
        "test")
            test_build
            ;;
        "update")
            if [ -z "$commit_msg" ]; then
                log_error "请提供提交信息"
                echo "示例: $0 \"更新博客内容\""
                exit 1
            fi
            update_blog "$commit_msg" "$force"
            ;;
    esac
}

# 运行主函数
main "$@"
