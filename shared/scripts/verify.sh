#!/bin/bash
# verify.sh - 验证 Skills 配置

echo "🔍 验证 AI Skills 配置..."
echo ""

SKILLS_DIR="$HOME/Workspace/my-ai-skills"

# 检查中央仓库
if [ -d "$SKILLS_DIR" ]; then
    echo "✅ 中央仓库: $SKILLS_DIR"
    skill_count=$(find "$SKILLS_DIR" -name "SKILL.md" | wc -l)
    echo "   Skills 数量: $skill_count"
else
    echo "❌ 中央仓库不存在: $SKILLS_DIR"
    exit 1
fi

echo ""
echo "🔗 工具链接状态："

links=(
    "$HOME/.claude/skills"
    "$HOME/.codex/skills"
    "$HOME/.gemini/skills"
    "$HOME/.antigravity/skills"
    "$HOME/.gemini/antigravity/skills"
)

for link in "${links[@]}"; do
    if [ -L "$link" ]; then
        target=$(readlink "$link")
        if [ "$target" = "$SKILLS_DIR" ]; then
            echo "✅ $link -> $SKILLS_DIR"
        else
            echo "⚠️  $link -> $target (指向其他位置)"
        fi
    else
        echo "❌ $link (不是软链接或不存在)"
    fi
done

echo ""
echo "📋 可用 Skills："
find "$SKILLS_DIR" -name "SKILL.md" | while read skill; do
    skill_name=$(basename "$(dirname "$skill")")
    desc=$(grep "^description:" "$skill" 2>/dev/null | head -1 | sed 's/description: *//' || echo "无描述")
    echo "  - $skill_name: $desc"
done

echo ""
echo "✅ 验证完成！"
