# Git 协作规范指南 (Collaboration Guide)

本文档旨在规范 **LifeFit** 项目的团队协作流程，确保代码质量，减少冲突，并提高开发效率。

## 1. 分支管理策略 (Branching Strategy)

我们采用 **Feature Branch Workflow**（功能分支工作流）。

### 核心分支
*   **`main`**: 主分支，始终保持**可部署、稳定**的状态。禁止直接向 `main` 推送代码 (Direct Push)。所有代码必须通过 Pull Request (PR) 合并。

### 临时分支
*   **`feature/*`**: 功能开发分支。从 `main` 切出，开发完成后合并回 `main`。
    *   命名示例: `feature/login-screen`, `feature/user-profile`, `feature/calendar-api`
*   **`bugfix/*`**: 修复 bug 的分支。
    *   命名示例: `bugfix/fix-login-error`
*   **`hotfix/*`**: 紧急修复线上问题的分支（如果已有发布版本）。

---

## 2. 日常开发流程 (Workflow)

### 第一步：同步代码
在开始任何工作之前，**必须**先拉取远程最新代码，防止冲突。

```bash
git checkout main
git pull origin main
```

### 第二步：创建分支
为您要开发的任务创建一个独立分支。

```bash
# 格式: git checkout -b feature/<功能名称>
git checkout -b feature/register-screen
```

### 第三步：开发与提交
*   保持提交粒度适中，一个 commit 做一件事。
*   **Commit Message 规范**: `type: description`
    *   `feat`: 新功能 (feature)
    *   `fix`: 修复 bug
    *   `docs`: 文档修改
    *   `style`: 代码格式修改 (不影响代码运行)
    *   `refactor`: 重构 (既不是新增功能也不是修改 bug)
    *   `chore`: 构建过程或辅助工具的变动

    **示例**:
    ```bash
    git commit -m "feat: implement user registration form"
    git commit -m "fix: resolve login timeout issue"
    ```

### 第四步：推送到远程
开发完成后，将分支推送到 GitHub。

```bash
git push origin feature/register-screen
```

### 第五步：发起 Pull Request (PR)
1.  在 GitHub 页面上，点击 **"Compare & pull request"**。
2.  填写 PR 描述：
    *   **What**: 做了什么修改？
    *   **Why**: 为什么要修改？
    *   **Screenshots**: 如果是 UI 修改，**必须**附上截图或 GIF。
3.  指定 Reviewer（代码审查人）。

### 第六步：代码审查 (Code Review)
*   队友审查代码，提出修改意见。
*   开发者根据意见修改代码，并再次 push（会自动更新 PR）。
*   审查通过后，点击 **"Squash and merge"** 合并到 `main`。

---

## 3. 解决冲突 (Conflict Resolution)

如果在您开发过程中，`main` 分支有了新更新，合并时可能会发生冲突。

1.  切换回您的功能分支：
    ```bash
    git checkout feature/register-screen
    ```
2.  将 `main` 的最新代码合并进您的分支：
    ```bash
    git pull origin main
    ```
3.  VS Code 会提示冲突文件。手动解决冲突（保留需要的代码）。
4.  提交修改：
    ```bash
    git add .
    git commit -m "merge: resolve conflicts with main"
    ```

---

## 4. 环境配置 (Environment Setup)

*   **Flutter Version**: 3.x (确保团队成员版本一致)
*   **Java Version**: JDK 17
*   **Android SDK**: Android 14 (API 34)

## 5. 常用命令速查

| 场景 | 命令 |
| :--- | :--- |
| 查看状态 | `git status` |
| 查看提交记录 | `git log --oneline` |
| 暂存所有修改 | `git add .` |
| 丢弃本地修改 | `git checkout .` (慎用) |
| 强制推送到远程分支 | `git push origin <branch> -f` (慎用) |
