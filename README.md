# 🎯 我的 AI Skills 仓库

统一管理所有 AI 编码工具的 Skills（基于 Agent Skills 标准）。

**兼容 [add-skill](https://github.com/vercel-labs/add-skill) 工具** - 可安装社区 skills 并自动同步。

## 架构设计

本仓库采用中央仓库 + add-skill 集成的方式：

```
中央仓库: ~/Workspace/my-ai-skills/
         ↑
         │ (软链接)
         │
~/.agents/skills/ → add-skill 默认位置
         │
         │ (add-skill 自动创建软链接)
         ↓
~/.claude/skills/skill-name → ~/.agents/skills/skill-name
~/.codex/skills/skill-name → ~/.agents/skills/skill-name
~/.cursor/skills/skill-name → ~/.agents/skills/skill-name
...等所有支持的 agents
```

**优势：**
- ✅ 所有 skills 统一存储在 `~/Workspace/my-ai-skills`（Git 管理）
- ✅ 使用 add-skill 安装社区 skills，自动进入中央仓库
- ✅ Git 跨设备同步
- ✅ 兼容 25+ 种 coding agents

## 支持的工具

通过 add-skill 自动支持：
- ✅ Claude Code、Codex、Cursor
- ✅ Gemini CLI、Antigravity
- ✅ Windsurf、Cline、Goose
- ✅ GitHub Copilot、Roo Code
- ✅ 及其他 20+ 种工具

## 快速开始

### 在新电脑上设置

```bash
# 1. 克隆仓库
git clone git@github.com:你的用户名/my-ai-skills.git ~/Workspace/my-ai-skills

# 2. 运行设置脚本（一键配置）
bash ~/Workspace/my-ai-skills/setup-universal-skills.sh
```

### 安装社区 Skills

```bash
# 使用 add-skill 安装（自动进入中央仓库）
npx add-skill vercel-labs/agent-skills -g

# 安装特定 skill
npx add-skill vercel-labs/agent-skills --skill frontend-design -g

# 列出可用的社区 skills
npx add-skill vercel-labs/agent-skills --list
```

### 创建自己的 Skill

```bash
cd ~/Workspace/my-ai-skills
mkdir -p my-skill
cat > my-skill/SKILL.md << 'SKILL_EOF'
---
name: my-skill
description: 我的 Skill 描述
---

# My Skill

Skill 内容...
SKILL_EOF

# 更新 skills 列表
bash ~/Workspace/my-ai-skills/shared/scripts/update-skills-list.sh

# 提交到 Git
git add my-skill/ INSTALLED_SKILLS.md
git commit -m "feat: 添加 my-skill"
git push
```

## 工作流程

### 日常使用

```bash
# 安装社区 skills
npx add-skill vercel-labs/agent-skills -g

# 创建自己的 skill
cd ~/Workspace/my-ai-skills
mkdir new-skill && vim new-skill/SKILL.md

# 提交到 Git
git add . && git commit -m "feat: 添加新 skill" && git push
```

### 跨设备同步

```bash
# 在新设备上
git clone git@github.com:你的用户名/my-ai-skills.git ~/Workspace/my-ai-skills
bash ~/Workspace/my-ai-skills/setup-universal-skills.sh

# 在旧设备上同步
cd ~/Workspace/my-ai-skills
git pull
```

## 验证配置

```bash
# 验证设置是否正确
bash ~/Workspace/my-ai-skills/shared/scripts/verify.sh
```

## 文档

- [已安装的 Skills](INSTALLED_SKILLS.md) - 查看所有已安装的 skills（自动更新）
- [最佳实践](BEST-PRACTICES.md) - 创建跨工具兼容的 Skills
- [设置总结](SETUP-SUMMARY.md) - 详细的设置说明
- [GitHub 推送指南](GITHUB-PUSH-GUIDE.md) - 如何推送到 GitHub

## 当前 Skills

📋 查看完整的 skills 列表：**[INSTALLED_SKILLS.md](INSTALLED_SKILLS.md)**

该文档由脚本自动维护，包含所有已安装 skills 的详细信息（用途、位置、来源等）。

## 技术细节

### 目录结构

```
~/Workspace/my-ai-skills/
├── .git/                           # Git 仓库
├── commit-conventional/            # 你的 skills
├── code-quality-check/
├── skill-creator/
├── add-skill/                      # 新增：add-skill 管理工具
├── vercel-react-best-practices/    # add-skill 安装的
├── web-design-guidelines/          # add-skill 安装的
├── shared/
│   └── scripts/
│       ├── install.sh              # 新设备安装脚本
│       ├── verify.sh               # 验证脚本
│       └── update-skills-list.sh   # 更新 skills 列表
├── setup-universal-skills.sh       # 主设置脚本
├── README.md
├── INSTALLED_SKILLS.md             # 已安装的 skills 列表（自动生成）
├── BEST-PRACTICES.md
└── SETUP-SUMMARY.md
```

### 软链接架构

```
~/.agents/skills -> ~/Workspace/my-ai-skills (中央仓库)
~/.claude/skills/skill-name -> ~/.agents/skills/skill-name
~/.cursor/skills/skill-name -> ~/.agents/skills/skill-name
...
```

## Skills 管理工具

本仓库包含两个辅助工具来管理 skills：

### add-skill
用于通过 `npx add-skill` 安装和管理社区 skills。

**触发方式：** 对话中说"安装 XXX skill"

**功能：**
- 从 vercel-labs/agent-skills 等仓库安装 skills
- 自动更新 INSTALLED_SKILLS.md
- 提醒提交到 Git

### skill-creator
用于创建新的自定义 skills。

**触发方式：** 对话中说"创建新 skill"

**功能：**
- 提供 skill 创建指导
- 遵循最佳实践
- 自动更新 skills 列表

## FAQ

**Q: add-skill 和手动创建的区别？**
- add-skill：从社区安装，自动管理软链接
- 手动创建：你自己的 skills，直接在中央仓库创建

**Q: 会不会安装多份？**
- 不会！所有 skills 都在 `~/Workspace/my-ai-skills`，只有一份

**Q: 如何查看已安装的 skills？**
```bash
# 查看详细列表
cat ~/Workspace/my-ai-skills/INSTALLED_SKILLS.md

# 或者在对话中说
"列出已安装的 skills"
```

**Q: 如何更新社区 skills？**
```bash
npx add-skill vercel-labs/agent-skills --skill skill-name -g
bash ~/Workspace/my-ai-skills/shared/scripts/update-skills-list.sh
```

**Q: 如何删除 skill？**
```bash
cd ~/Workspace/my-ai-skills
rm -rf skill-name
bash ~/Workspace/my-ai-skills/shared/scripts/update-skills-list.sh
git add . && git commit -m "remove: skill-name" && git push
```

## 相关链接

- [add-skill 工具](https://github.com/vercel-labs/add-skill)
- [Vercel Agent Skills](https://github.com/vercel-labs/agent-skills)
- [Agent Skills 标准](https://vercel-labs.github.io/agent-skills/)
