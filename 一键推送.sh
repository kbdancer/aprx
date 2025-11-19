#!/bin/bash
#
# 一键推送并触发 GitHub Actions 编译
#

set -e

echo "========================================="
echo "  APRX OpenWrt - 一键推送到 GitHub"
echo "========================================="
echo ""

# 检查当前分支
CURRENT_BRANCH=$(git branch --show-current)
echo "✓ 当前分支: $CURRENT_BRANCH"

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo ""
    echo "发现未提交的更改，正在提交..."
    git add -A
    git commit -m "Update OpenWrt build files"
fi

# 推送到远程
echo ""
echo "正在推送到 GitHub..."
git push origin "$CURRENT_BRANCH" || {
    echo ""
    echo "❌ 推送失败！"
    echo ""
    echo "可能的原因："
    echo "1. 需要配置 GitHub 认证（SSH key 或 Personal Access Token）"
    echo "2. 没有推送权限"
    echo "3. 网络问题"
    echo ""
    echo "解决方法："
    echo "方法 1 - 使用 SSH（推荐）："
    echo "  ssh-keygen -t ed25519 -C \"your_email@example.com\""
    echo "  cat ~/.ssh/id_ed25519.pub  # 复制到 GitHub SSH keys"
    echo ""
    echo "方法 2 - 使用 Personal Access Token："
    echo "  1. GitHub Settings -> Developer settings -> Personal access tokens"
    echo "  2. Generate new token (classic)"
    echo "  3. 选择 repo 权限"
    echo "  4. git remote set-url origin https://TOKEN@github.com/用户名/aprx.git"
    echo ""
    exit 1
}

echo ""
echo "========================================="
echo "✅ 推送成功！"
echo "========================================="
echo ""
echo "接下来的步骤："
echo ""
echo "1. 打开浏览器访问你的 GitHub 仓库"
echo "   （URL 会根据你的 git remote 自动显示）"
echo ""

# 获取远程仓库 URL
REMOTE_URL=$(git remote get-url origin)
if [[ $REMOTE_URL == git@github.com:* ]]; then
    # SSH URL
    REPO_PATH=${REMOTE_URL#git@github.com:}
    REPO_PATH=${REPO_PATH%.git}
    HTTPS_URL="https://github.com/$REPO_PATH"
elif [[ $REMOTE_URL == https://github.com/* ]]; then
    # HTTPS URL
    HTTPS_URL=${REMOTE_URL%.git}
else
    HTTPS_URL="https://github.com/你的用户名/aprx"
fi

echo "2. 仓库地址: $HTTPS_URL"
echo ""
echo "3. 点击 'Actions' 标签"
echo ""
echo "4. 如果看到提示，点击 'I understand my workflows, go ahead and enable them'"
echo ""
echo "5. 左侧选择 'Build OpenWrt IPK for MT7621'"
echo ""
echo "6. 右侧点击 'Run workflow' 按钮开始编译"
echo ""
echo "7. 等待 10-20 分钟后下载编译好的 IPK 文件"
echo ""
echo "========================================="
echo ""
echo "💡 提示: 你也可以创建标签来触发自动编译并创建 Release："
echo ""
echo "   git tag v2.9.0"
echo "   git push origin v2.9.0"
echo ""
echo "这样编译完成后会自动创建 Release，更方便下载！"
echo ""
