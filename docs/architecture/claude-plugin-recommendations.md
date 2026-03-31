# Claude Code 插件安装说明

> 本文档由 `shared/scripts/generate-claude-plugin-recommendations.sh` 自动生成。
> 最后更新：2026-03-31 18:22:07

以下 skill 包不会发布到 `~/.claude/skills`，以避免与 Claude Code 官方插件能力重复暴露。
当本机存在可用的 Claude CLI 和 `~/.claude` 环境时，中央仓库全局安装流程会自动尝试完成插件安装 / 启用。

## superpowers

- **插件名：** `superpowers`
- **来源仓库：** https://github.com/obra/superpowers.git
- **安装方式：** `plugin`
- **原因：** 官方建议通过 Claude Code 插件安装，中央仓库不发布到 ~/.claude/skills
- **涉及 skills：** brainstorming, dispatching-parallel-agents, executing-plans, finishing-a-development-branch, receiving-code-review, requesting-code-review, subagent-driven-development, systematic-debugging, test-driven-development, using-git-worktrees, using-superpowers, verification-before-completion, writing-plans, writing-skills
- **插件市场：** `superpowers-marketplace`
- **插件市场来源：** `obra/superpowers-marketplace`
- **目标命令：** `/plugin install superpowers@superpowers-marketplace`

---

## ui-ux-pro-max-skill

- **插件名：** `ui-ux-pro-max`
- **来源仓库：** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git
- **安装方式：** `plugin`
- **原因：** 官方建议通过 Claude Code 插件安装，中央仓库不发布到 ~/.claude/skills
- **涉及 skills：** ui-ux-pro-max
- **插件市场：** `ui-ux-pro-max-skill`
- **插件市场来源：** `nextlevelbuilder/ui-ux-pro-max-skill`
- **目标命令：** `/plugin install ui-ux-pro-max@ui-ux-pro-max-skill`

---
