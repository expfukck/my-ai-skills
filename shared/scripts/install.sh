#!/bin/bash
# install.sh - 在新电脑上自动配置 Skills

set -e

SKILLS_DIR="$HOME/Workspace/my-ai-skills"

# 加载中央配置文件（如果存在）
if [ -f "$SKILLS_DIR/.skillsrc" ]; then
    source "$SKILLS_DIR/.skillsrc"
fi

# 统一支持：传统目录 + Gemini/Antigravity 嵌套目录
skill_links=(
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  "$HOME/.gemini/skills"
  "$HOME/.antigravity/skills"
  "$HOME/.gemini/antigravity/skills"
)

echo "🚀 开始配置 AI Skills..."
echo "Skills 目录: $SKILLS_DIR"
echo ""

# 配置所有 AI 工具
for skill_link in "${skill_links[@]}"; do
    mkdir -p "$(dirname "$skill_link")"

    # 备份已存在的非软链接目录
    if [ -e "$skill_link" ] && [ ! -L "$skill_link" ]; then
        backup_dir="$HOME/skills-backup-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$backup_dir"
        backup_name="$(basename "$(dirname "$skill_link")")-skills"
        mv "$skill_link" "$backup_dir/$backup_name"
        echo "📦 备份旧 Skills: $backup_dir/$backup_name"
    fi

    # 创建软链接
    ln -sf "$SKILLS_DIR" "$skill_link"
    echo "✅ $skill_link -> $SKILLS_DIR"
done

echo ""
echo "✅ 配置完成！"
echo ""
echo "📊 验证："
for skill_link in "${skill_links[@]}"; do
    if [ -L "$skill_link" ]; then
        echo "  ✅ $skill_link"
    fi
done
