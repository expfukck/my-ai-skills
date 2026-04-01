# Claude Code 插件安装说明

> 本文档由 `shared/scripts/generate-claude-plugin-recommendations.sh` 自动生成。
> 最后更新：2026-04-01 17:47:45

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

## CTF-Sandbox-Orchestrator

- **插件名：** `CTF-Sandbox-Orchestrator`
- **来源仓库：** https://github.com/GALIAIS/CTF-Sandbox-Orchestrator
- **安装方式：** `disabled`
- **原因：** 官方建议通过 Claude Code 插件安装，中央仓库不发布到 ~/.claude/skills
- **涉及 skills：** competition-ad-certificate-abuse, competition-agent-cloud, competition-android-hooking, competition-browser-persistence, competition-bundle-sourcemap-recovery, competition-cloud-metadata-path, competition-container-runtime, competition-crypto-mobile, competition-custom-protocol-replay, competition-dpapi-credential-chain, competition-file-parser-chain, competition-firmware-layout, competition-forensic-timeline, competition-graphql-rpc-drift, competition-identity-windows, competition-ios-runtime, competition-jwt-claim-confusion, competition-k8s-control-plane, competition-kerberos-delegation, competition-kernel-container-escape, competition-linux-credential-pivot, competition-lsass-ticket-material, competition-mailbox-abuse, competition-malware-config, competition-oauth-oidc-chain, competition-pcap-protocol, competition-prompt-injection, competition-queue-worker-drift, competition-race-condition-state-drift, competition-relay-coercion-chain, competition-request-normalization-smuggling, competition-reverse-pwn, competition-runtime-routing, competition-ssrf-metadata-pivot, competition-stego-media, competition-supply-chain, competition-template-render-path, competition-web-runtime, competition-websocket-runtime, competition-windows-pivot, ctf-sandbox-orchestrator

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
