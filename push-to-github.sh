#!/bin/bash
# push-to-github.sh - 推送到 GitHub 的辅助脚本

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 准备推送到 GitHub"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 询问 GitHub 用户名
read -p "请输入你的 GitHub 用户名: " GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo "❌ 用户名不能为空"
    exit 1
fi

echo ""
echo "📋 配置信息："
echo "  GitHub 用户名: $GITHUB_USER"
echo "  仓库名称: my-ai-skills"
echo "  分支: main"
echo ""

# 检查是否已有 remote
if git remote get-url origin > /dev/null 2>&1; then
    echo "⚠️  已存在 remote origin，删除旧配置..."
    git remote remove origin
fi

# 添加 remote（使用 HTTPS）
echo "🔗 添加远程仓库..."
git remote add origin https://github.com/$GITHUB_USER/my-ai-skills.git

# 设置分支
echo "📌 设置主分支..."
git branch -M main

# 推送
echo ""
echo "🚀 开始推送..."
echo ""
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ 推送成功！"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🔗 仓库地址："
    echo "   https://github.com/$GITHUB_USER/my-ai-skills"
    echo ""
    echo "💡 下次更新时使用："
    echo "   cd ~/Workspace/my-ai-skills"
    echo "   git add ."
    echo "   git commit -m \"feat: 添加新 Skill\""
    echo "   git push"
    echo ""
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "可能的原因："
    echo "1. GitHub 仓库还未创建"
    echo "2. 用户名输入错误"
    echo "3. 需要 GitHub 认证（首次推送时会提示）"
    echo ""
    echo "请访问 https://github.com/new 创建仓库"
    echo ""
fi
