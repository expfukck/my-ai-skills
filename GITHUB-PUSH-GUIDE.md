# GitHub 推送快速指南

本文档提供快速推送到 GitHub 的步骤说明。

---

## 🚀 推送到 GitHub - 三步完成

### 步骤 1：创建 GitHub 仓库（2 分钟）

1. 打开浏览器访问：**https://github.com/new**

2. 填写仓库信息：
   - **Repository name**: `my-ai-skills`
   - **Description**: `统一管理所有 AI 编码工具的 Skills`
   - **Private**: ✅ 勾选（推荐私有仓库）
   - ❌ **不要勾选** "Add a README file"
   - ❌ **不要勾选** "Add .gitignore"
   - ❌ **不要勾选** "Choose a license"

3. 点击 **"Create repository"**

---

### 步骤 2：运行推送脚本

在终端执行：

```bash
cd ~/Workspace/my-ai-skills
./push-to-github.sh
```

脚本会提示你输入 GitHub 用户名，然后自动完成推送。

---

### 步骤 3：认证（首次推送时需要）

#### HTTPS 方式（推荐）

首次推送时会提示输入：
- **用户名**: 你的 GitHub 用户名
- **密码**: 使用 **Personal Access Token**（不是密码！）

如何创建 Personal Access Token：

1. 访问：**https://github.com/settings/tokens/new**
2. 填写：
   - **Note**: "My AI Skills"
   - **Expiration**: 选择过期时间（建议 90 days 或 No expiration）
   - **Select scopes**: ✅ 勾选 **"repo"**
3. 点击 **"Generate token"**
4. **立即复制** token（只显示一次！）
5. 在推送时粘贴这个 token 作为密码

#### SSH 方式（可选）

如果你想使用 SSH，需要先添加 SSH 公钥到 GitHub：

1. 访问：**https://github.com/settings/ssh/new**

2. 添加你的 SSH 公钥：
   ```
   ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+dK2tupnlyQuXFcHr1JixDd06JFMYwDmFGV7nWFBiO enjoy.loneliness@iCloud.com
   ```

3. Title: "My Mac - AI Skills"

4. 点击 **"Add SSH key"**

5. 然后修改推送脚本使用 SSH URL（或手动推送）

---

## 📋 手动推送（高级）

如果你想手动推送而不使用脚本：

```bash
cd ~/Workspace/my-ai-skills

# 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/my-ai-skills.git

# 或使用 SSH
git remote add origin git@github.com:YOUR_USERNAME/my-ai-skills.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

---

## 🔍 验证推送成功

推送成功后，访问你的 GitHub 仓库：

```
https://github.com/YOUR_USERNAME/my-ai-skills
```

你应该能看到：
- ✅ 2 个提交
- ✅ 10 个文件
- ✅ README.md 显示在首页

---

## 🔄 后续更新

以后创建新 Skill 或修改现有 Skill 后，更新到 GitHub：

```bash
cd ~/Workspace/my-ai-skills

# 添加变更
git add .

# 创建提交
git commit -m "feat: 添加新 Skill"

# 推送到 GitHub
git push
```

---

## 🌐 在其他电脑上同步

在新电脑上克隆仓库：

```bash
# 使用 HTTPS
git clone https://github.com/YOUR_USERNAME/my-ai-skills.git ~/Workspace/my-ai-skills

# 或使用 SSH
git clone git@github.com:YOUR_USERNAME/my-ai-skills.git ~/Workspace/my-ai-skills

# 运行安装脚本配置软链接
cd ~/Workspace/my-ai-skills
bash shared/scripts/install.sh
```

---

## ❓ 常见问题

### Q: 推送时显示 "Permission denied"

**A:** 检查认证方式：
- HTTPS：确保使用 Personal Access Token 而不是密码
- SSH：确保已添加 SSH 公钥到 GitHub

### Q: 推送时显示 "Repository not found"

**A:** 检查：
- GitHub 仓库是否已创建
- 用户名是否正确
- 仓库名称是否为 `my-ai-skills`

### Q: 如何查看当前的远程仓库配置？

**A:** 运行：
```bash
cd ~/Workspace/my-ai-skills
git remote -v
```

---

## 📞 获取帮助

如果遇到问题：

1. 查看推送脚本输出的错误信息
2. 运行验证脚本：`bash shared/scripts/verify.sh`
3. 检查 Git 状态：`git status`
4. 查看提交历史：`git log --oneline`

---

**创建时间**: 2026-01-23
**版本**: v1.0
