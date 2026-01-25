---
name: add-skill
description: Install and manage skills using npx add-skill. Use when users want to (1) install a specific skill, (2) install from custom GitHub repos, (3) update existing skills, or (4) browse available skills from vercel-labs/agent-skills or other repos for installation. 当用户说"安装 skill"、"更新 skill"、"从 XX 安装 skill"时触发。
---

# Add Skill

通过 `npx add-skill` 工具安装和管理 skills，支持从 vercel-labs/agent-skills 或自定义仓库安装。

## 核心功能

1. **安装特定 skill** - 从默认仓库安装
2. **从自定义仓库安装** - 支持任意 GitHub 仓库
3. **更新已安装的 skills** - 重新安装获取最新版本
4. **浏览可安装的 skills** - 查看 vercel-labs/agent-skills 等仓库中的可用 skills（用于安装前预览）

## 使用 add-skill 的优势

- ✅ 自动创建软链接到所有支持的 agents（Claude Code、Cursor、Codex 等 25+ 工具）
- ✅ 统一管理在 `~/.agents/skills/`（软链接到你的中央仓库）
- ✅ 社区生态支持（vercel-labs、openai 等）

## 常用命令

### 浏览可安装的 skills（用于安装前预览）

```bash
npx add-skill vercel-labs/agent-skills --list
```

**注意：** 此命令用于浏览远程仓库中**可供安装**的 skills，而非列出本地已安装的 skills。

输出示例：
```
Available skills:
- frontend-design
- vercel-react-best-practices
- web-design-guidelines
- pdf-editor
- ...
```

### 安装全部 skills（全局安装到中央仓库）

```bash
npx add-skill vercel-labs/agent-skills -g
```

**重要：** 必须使用 `-g` 标志，这样会安装到 `~/.agents/skills/`（软链接到你的中央仓库 `~/Workspace/my-ai-skills`）

### 安装特定 skill

```bash
npx add-skill vercel-labs/agent-skills --skill <skill-name> -g
```

示例：
```bash
npx add-skill vercel-labs/agent-skills --skill frontend-design -g
npx add-skill vercel-labs/agent-skills --skill pdf-editor -g
```

### 从自定义 GitHub 仓库安装

```bash
npx add-skill <owner>/<repo> -g
npx add-skill <owner>/<repo> --skill <skill-name> -g
```

示例：
```bash
npx add-skill openai/skills -g
npx add-skill myusername/my-skills --skill custom-skill -g
```

### 更新已安装的 skill

重新运行安装命令即可（会覆盖现有版本）：
```bash
npx add-skill vercel-labs/agent-skills --skill <skill-name> -g
```

## 工作流程

### 场景 1：用户说"安装 X skill"

1. 确认 skill 名称（如果用户提供的名称不准确，先列出查找）
2. 运行安装命令
3. 更新 skills 列表
4. 提醒用户提交到 Git

```bash
# 安装
npx add-skill vercel-labs/agent-skills --skill <skill-name> -g

# 更新列表
bash ~/Workspace/my-ai-skills/shared/scripts/update-skills-list.sh

# 提示用户提交
echo "别忘了提交: git add <skill-name> README.md && git commit -m 'feat: 安装 <skill-name>'"
```

### 场景 2：用户说"从某个仓库安装 skill"

1. 确认仓库地址（owner/repo 格式）
2. 运行自定义仓库安装命令
3. 更新 skills 列表
4. 验证安装结果

```bash
# 安装
npx add-skill <owner>/<repo> --skill <skill-name> -g

# 更新列表
bash ~/Workspace/my-ai-skills/shared/scripts/update-skills-list.sh
```

### 场景 3：用户说"更新 skill"

1. 重新运行安装命令（会覆盖现有版本）
2. 更新 skills 列表
3. 提醒用户检查更新内容

```bash
# 更新
npx add-skill vercel-labs/agent-skills --skill <skill-name> -g

# 更新列表
bash ~/Workspace/my-ai-skills/shared/scripts/update-skills-list.sh
```

## 安装后验证和更新

安装完成后，执行以下步骤：

### 1. 验证安装

```bash
# 检查 skill 是否存在于中央仓库
ls -la ~/Workspace/my-ai-skills/<skill-name>

# 检查软链接是否正确
ls -la ~/.agents/skills/<skill-name>
ls -la ~/.claude/skills/<skill-name>
```

### 2. 更新 Skills 列表

**重要：** 每次安装新 skill 后，必须更新中央仓库的 skills 列表：

```bash
bash ~/Workspace/my-ai-skills/shared/scripts/update-skills-list.sh
```

这个脚本会自动：
- 扫描所有已安装的 skills
- 从 SKILL.md 提取名称和描述
- 更新 README.md 中的"当前 Skills"部分
- 区分"自己创建的"和"社区安装的" skills

### 3. 提交到 Git

```bash
cd ~/Workspace/my-ai-skills
git add <skill-name> README.md
git commit -m "feat: 安装 <skill-name>"
git push
```

## 重要提示

1. **始终使用 `-g` 标志** - 确保安装到全局位置（`~/.agents/skills/`），这样会自动链接到你的中央仓库
2. **安装后更新列表** - 每次安装后运行更新脚本：
   ```bash
   bash ~/Workspace/my-ai-skills/shared/scripts/update-skills-list.sh
   ```
3. **安装后同步到 Git** - 提醒用户将新安装的 skill 和更新的 README.md 一起提交：
   ```bash
   cd ~/Workspace/my-ai-skills
   git add <skill-name> README.md
   git commit -m "feat: 安装 <skill-name>"
   git push
   ```
4. **检查冲突** - 如果已存在同名 skill，询问用户是否覆盖
5. **验证安装** - 安装后检查文件是否正确写入中央仓库

## 常见默认仓库

- **vercel-labs/agent-skills** - Vercel 官方 skills（推荐）
- **openai/skills** - OpenAI 官方 skills
- **anthropics/claude-code-skills** - Claude Code 官方 skills（如果存在）

## 错误处理

如果 add-skill 命令失败：

1. **检查网络连接** - add-skill 需要访问 GitHub
2. **检查仓库是否存在** - 确认仓库地址正确
3. **检查权限** - 私有仓库需要 GitHub token
4. **检查 Node.js** - add-skill 需要 Node.js 环境

## 输出示例

安装成功后的典型输出：
```
✓ Installing skill: frontend-design
✓ Created ~/.agents/skills/frontend-design
✓ Linked to ~/.claude/skills/frontend-design
✓ Linked to ~/.cursor/skills/frontend-design
✓ Linked to ~/.codex/skills/frontend-design
... (更多 agents)

Successfully installed skill: frontend-design
```

安装后提醒用户：
```
✅ Skill '<skill-name>' 已成功安装到中央仓库！

📍 位置: ~/Workspace/my-ai-skills/<skill-name>
🔗 已自动链接到所有支持的 AI 编码工具

🔄 正在更新 skills 列表...
✅ README.md 已更新

💡 别忘了提交到 Git：
cd ~/Workspace/my-ai-skills
git add <skill-name> README.md
git commit -m "feat: 安装 <skill-name>"
git push
```
