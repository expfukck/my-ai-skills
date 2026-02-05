#!/bin/bash

# add-skill 的非交互式安装脚本
# 用于在 Claude Code 等非交互式环境中安装 skills

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 使用说明
usage() {
    echo "用法: $0 <owner/repo> --skill <skill-name>"
    echo ""
    echo "示例:"
    echo "  $0 remotion-dev/skills --skill remotion-best-practices"
    echo "  $0 vercel-labs/agent-skills --skill frontend-design"
    echo ""
    exit 1
}

# 解析参数
REPO=""
SKILL_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --skill)
            SKILL_NAME="$2"
            shift 2
            ;;
        *)
            if [[ -z "$REPO" ]]; then
                REPO="$1"
            fi
            shift
            ;;
    esac
done

# 验证参数
if [[ -z "$REPO" ]] || [[ -z "$SKILL_NAME" ]]; then
    echo -e "${RED}❌ 错误: 缺少必需参数${NC}"
    usage
fi

# 配置
CENTRAL_REPO="$HOME/Workspace/my-ai-skills"
TEMP_DIR=$(mktemp -d)
GITHUB_URL="https://github.com/${REPO}.git"

echo -e "${BLUE}📦 安装 Skill: ${SKILL_NAME}${NC}"
echo -e "${BLUE}📍 来源: ${REPO}${NC}"
echo ""

# 1. 克隆仓库
echo -e "${YELLOW}⏳ 正在克隆仓库...${NC}"
if ! git clone --depth 1 "$GITHUB_URL" "$TEMP_DIR/repo" 2>/dev/null; then
    echo -e "${RED}❌ 克隆失败: $GITHUB_URL${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi
echo -e "${GREEN}✅ 仓库克隆成功${NC}"

# 2. 查找 skill 目录
SKILL_FOUND=false
SKILL_SOURCE_DIR=""

# 尝试多种可能的路径
POSSIBLE_PATHS=(
    "$TEMP_DIR/repo/skills/$SKILL_NAME"
    "$TEMP_DIR/repo/$SKILL_NAME"
    "$TEMP_DIR/repo/skills/*"
)

for path in "${POSSIBLE_PATHS[@]}"; do
    for dir in $path; do
        if [[ -d "$dir" ]] && [[ -f "$dir/SKILL.md" ]]; then
            # 读取 SKILL.md 中的 name 字段
            SKILL_FILE_NAME=$(grep -E "^name:" "$dir/SKILL.md" | head -1 | sed 's/name: *//' | tr -d '\r')

            if [[ "$SKILL_FILE_NAME" == "$SKILL_NAME" ]]; then
                SKILL_SOURCE_DIR="$dir"
                SKILL_FOUND=true
                break 2
            fi
        fi
    done
done

if [[ "$SKILL_FOUND" == false ]]; then
    echo -e "${RED}❌ 未找到 skill: $SKILL_NAME${NC}"
    echo -e "${YELLOW}💡 提示: 检查 skill 名称是否正确${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}✅ 找到 skill: $SKILL_NAME${NC}"

# 3. 检查是否已存在
if [[ -d "$CENTRAL_REPO/$SKILL_NAME" ]]; then
    echo -e "${YELLOW}⚠️  Skill 已存在，将覆盖: $SKILL_NAME${NC}"
    rm -rf "$CENTRAL_REPO/$SKILL_NAME"
fi

# 4. 复制到中央仓库
echo -e "${YELLOW}⏳ 正在复制文件到中央仓库...${NC}"
cp -r "$SKILL_SOURCE_DIR" "$CENTRAL_REPO/$SKILL_NAME"
echo -e "${GREEN}✅ 文件复制成功${NC}"

# 5. 创建软链接到 ~/.agents/skills/
echo -e "${YELLOW}⏳ 正在创建软链接...${NC}"

mkdir -p "$HOME/.agents/skills"

# 链接到 ~/.agents/skills/ (中央位置)
if [[ -L "$HOME/.agents/skills/$SKILL_NAME" ]]; then
    rm "$HOME/.agents/skills/$SKILL_NAME"
fi
ln -sf "$CENTRAL_REPO/$SKILL_NAME" "$HOME/.agents/skills/$SKILL_NAME"
echo -e "${GREEN}  ✓ ~/.agents/skills/$SKILL_NAME${NC}"

# 链接到各个 AI 工具（如果目录存在）
AI_TOOLS=(
    "$HOME/.claude/skills"
    "$HOME/.cursor/skills"
    "$HOME/.codex/skills"
    "$HOME/.windsurf/skills"
    "$HOME/.cline/skills"
    "$HOME/.goose/skills"
)

for tool_dir in "${AI_TOOLS[@]}"; do
    if [[ -d "$tool_dir" ]]; then
        if [[ -L "$tool_dir/$SKILL_NAME" ]]; then
            rm "$tool_dir/$SKILL_NAME"
        fi
        ln -sf "$HOME/.agents/skills/$SKILL_NAME" "$tool_dir/$SKILL_NAME"
        echo -e "${GREEN}  ✓ $tool_dir/$SKILL_NAME${NC}"
    fi
done

# 6. 清理临时文件
rm -rf "$TEMP_DIR"

# 7. 更新 skills 列表
echo ""
echo -e "${YELLOW}⏳ 正在更新 skills 列表...${NC}"
if [[ -f "$CENTRAL_REPO/shared/scripts/update-skills-list.sh" ]]; then
    bash "$CENTRAL_REPO/shared/scripts/update-skills-list.sh"
    echo -e "${GREEN}✅ Skills 列表已更新${NC}"
else
    echo -e "${YELLOW}⚠️  未找到更新脚本，跳过${NC}"
fi

# 8. 成功提示
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Skill 安装成功！${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📍 位置: ${CENTRAL_REPO}/${SKILL_NAME}${NC}"
echo -e "${BLUE}🔗 已自动链接到所有支持的 AI 编码工具${NC}"
echo ""
echo -e "${YELLOW}💡 别忘了提交到 Git:${NC}"
echo -e "   cd ${CENTRAL_REPO}"
echo -e "   git add ${SKILL_NAME} INSTALLED_SKILLS.md"
echo -e "   git commit -m \"feat: 安装 ${SKILL_NAME} skill\""
echo -e "   git push"
echo ""
