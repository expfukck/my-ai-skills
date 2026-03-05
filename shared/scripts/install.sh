#!/bin/bash
# install.sh - 在新电脑上自动配置 Skills（按每个 skill 建立软链接）

set -euo pipefail

SKILLS_DIR="${SKILLS_DIR:-$HOME/Workspace/my-ai-skills}"
AGENTS_SKILLS_DIR="$HOME/.agents/skills"
BACKUP_DIR=""
CLEANED_STALE_COUNT=0

# 加载中央配置文件（如果存在）
if [ -f "$SKILLS_DIR/.skillsrc" ]; then
    source "$SKILLS_DIR/.skillsrc"
fi

resolve_dir() {
    local dir="$1"
    (cd "$dir" 2>/dev/null && pwd -P)
}

contains_skill() {
    local needle="$1"
    shift
    local item
    for item in "$@"; do
        if [[ "$item" == "$needle" ]]; then
            return 0
        fi
    done
    return 1
}

# 统一支持：传统目录 + Gemini/Antigravity 嵌套目录
skill_links=(
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  "$HOME/.cursor/skills"
  "$HOME/.gemini/skills"
  "$HOME/.antigravity/skills"
  "$HOME/.gemini/antigravity/skills"
  "$HOME/.windsurf/skills"
  "$HOME/.cline/skills"
  "$HOME/.goose/skills"
)

ensure_backup_dir() {
    if [ -z "$BACKUP_DIR" ]; then
        BACKUP_DIR="$HOME/skills-backup-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$BACKUP_DIR"
    fi
}

backup_path() {
    local path="$1"
    local name="$2"
    ensure_backup_dir
    mv "$path" "$BACKUP_DIR/$name"
    echo "📦 备份: $BACKUP_DIR/$name"
}

safe_link() {
    local src="$1"
    local dest="$2"
    local dest_name="$3"
    local src_real=""
    local dest_real=""
    local current_target=""

    src_real=$(resolve_dir "$src" || true)

    if [ -e "$dest" ]; then
        dest_real=$(resolve_dir "$dest" || true)
        if [ -n "$src_real" ] && [ -n "$dest_real" ] && [ "$src_real" = "$dest_real" ]; then
            return 0
        fi
    fi

    if [ -L "$dest" ]; then
        current_target=$(readlink "$dest" || true)
        if [ "$current_target" = "$src" ]; then
            return 0
        fi
        rm "$dest"
    elif [ -e "$dest" ]; then
        backup_path "$dest" "$dest_name"
    fi

    ln -s "$src" "$dest"
}

is_managed_symlink() {
    local link_path="$1"
    local target=""
    local resolved=""

    target="$(readlink "$link_path" 2>/dev/null || true)"
    if [[ "$target" == "$AGENTS_SKILLS_DIR/"* ]] || [[ "$target" == *".agents/skills/"* ]]; then
        return 0
    fi

    resolved="$(resolve_dir "$link_path" || true)"
    if [[ -n "$resolved" ]] && [[ "$resolved" == "$AGENTS_SKILLS_DIR/"* ]]; then
        return 0
    fi

    return 1
}

cleanup_stale_links_in_dir() {
    local dir="$1"
    local label="$2"
    local link_path=""
    local link_name=""

    [[ -d "$dir" ]] || return 0

    while IFS= read -r link_path; do
        [[ -z "$link_path" ]] && continue
        link_name="$(basename "$link_path")"

        if contains_skill "$link_name" "${skill_names[@]-}"; then
            continue
        fi

        if ! is_managed_symlink "$link_path"; then
            continue
        fi

        rm "$link_path"
        CLEANED_STALE_COUNT=$((CLEANED_STALE_COUNT + 1))
        echo "🧹 清理过期链接($label): $link_path"
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -type l | sort)
}

echo "🚀 开始配置 AI Skills..."
echo "Skills 目录: $SKILLS_DIR"
echo ""

if [ ! -d "$SKILLS_DIR" ]; then
    echo "❌ 中央仓库不存在: $SKILLS_DIR"
    exit 1
fi

SKILLS_DIR="$(resolve_dir "$SKILLS_DIR")"
if [ -z "$SKILLS_DIR" ]; then
    echo "❌ 无法解析中央仓库路径"
    exit 1
fi

# 1) 确保 ~/.agents/skills 为真实目录（不是软链接）
if [ -L "$AGENTS_SKILLS_DIR" ]; then
    echo "⚠️  发现 ~/.agents/skills 是软链接，转换为目录以匹配 npx skills add 行为..."
    rm "$AGENTS_SKILLS_DIR"
    mkdir -p "$AGENTS_SKILLS_DIR"
elif [ -e "$AGENTS_SKILLS_DIR" ] && [ ! -d "$AGENTS_SKILLS_DIR" ]; then
    backup_path "$AGENTS_SKILLS_DIR" "agents-skills-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$AGENTS_SKILLS_DIR"
else
    mkdir -p "$AGENTS_SKILLS_DIR"
fi

# 2) 扫描中央仓库并为 ~/.agents/skills 创建每个 skill 的软链接
skill_names=()
while IFS= read -r skill_md; do
    if [ -z "$skill_md" ]; then
        continue
    fi
    skill_dir="$(dirname "$skill_md")"
    skill_name="$(basename "$skill_dir")"
    skill_names+=("$skill_name")

    safe_link "$skill_dir" "$AGENTS_SKILLS_DIR/$skill_name" "agents-$skill_name"
done < <(find "$SKILLS_DIR" -maxdepth 2 -type f -name "SKILL.md" | sort)

if [ "${#skill_names[@]}" -eq 0 ]; then
    echo "⚠️  未发现任何 SKILL.md，跳过软链接创建"
    exit 0
fi

# 2.1) 清理 ~/.agents/skills 中与当前 skill 集合不一致的旧链接
cleanup_stale_links_in_dir "$AGENTS_SKILLS_DIR" "agents"

# 3) 为各个 AI 工具创建软链接（指向 ~/.agents/skills/<skill>）
for tool_dir in "${skill_links[@]}"; do
    if [ -L "$tool_dir" ]; then
        echo "⚠️  发现 $tool_dir 是软链接，转换为目录以匹配 per-skill 结构..."
        rm "$tool_dir"
        mkdir -p "$tool_dir"
    elif [ -e "$tool_dir" ] && [ ! -d "$tool_dir" ]; then
        backup_path "$tool_dir" "$(basename "$(dirname "$tool_dir")")-skills-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$tool_dir"
    else
        mkdir -p "$tool_dir"
    fi
    tool_name="$(basename "$(dirname "$tool_dir")")"
    for skill_name in "${skill_names[@]}"; do
        safe_link "$AGENTS_SKILLS_DIR/$skill_name" "$tool_dir/$skill_name" "$tool_name-$skill_name"
    done
    cleanup_stale_links_in_dir "$tool_dir" "$tool_name"
done

echo ""
echo "✅ 配置完成！"
echo "🧹 清理过期链接: $CLEANED_STALE_COUNT 个"
echo ""
echo "📊 验证："
echo "  ✅ $AGENTS_SKILLS_DIR (目录)"
for tool_dir in "${skill_links[@]}"; do
    if [ -d "$tool_dir" ]; then
        echo "  ✅ $tool_dir"
    fi
done
