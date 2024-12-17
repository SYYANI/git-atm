# 🤖 Git-ATM (AI commit Text Generator)

Git-ATM 是一个智能的 Git commit 信息生成工具，它使用 OpenAI API(或对齐的api，如DeepSeek API) 来分析你的代码变更，并自动生成清晰、规范的 commit 信息。

## ✨ 特性

- 自动分析 git diff 内容
- 使用 AI 生成符合最佳实践的 commit 信息
- 支持 emoji 前缀
- 支持自定义 OpenAI API 配置
- 交互式确认机制
- 支持暂存区和工作区的更改

## 🚀 安装

1. 克隆仓库：
```bash
git clone https://github.com/falconchen/git-atm.git
```

2. 添加执行权限：
```bash
chmod +x git-atm.sh
```

3. 创建配置文件：
```bash
cp .atmrc.example ~/.atmrc
```

4. 编辑 `~/.atmrc` 文件，设置你的 OpenAI或DeepSeek API 密钥：
    - `ATM_OPENAI_API_TOKEN`: OpenAI或DeepSeek API 密钥
    - `ATM_OPENAI_API_MODEL`: 使用的 AI 模型（默认：gpt-4）
    - `ATM_OPENAI_API_BASE_URL`: API 基础 URL


5. 创建软链接并加入到 PATH 中，如`/usr/local/bin`，添加后可以通过`git atm`作为git 子命令使用：
```bash
ln -s $(pwd)/git-atm.sh /usr/local/bin/git-atm
chmod +x /usr/local/bin/git-atm
```

## 💡 使用方法

1. 在你的 Git 仓库中进行代码更改
2. 运行 git-atm：
```bash
git atm
```
3. 查看生成的 commit 信息，并选择：
   - `yes/y`: 使用生成的信息创建 commit
   - `no/n`: 取消操作
   - `regenerate/r`: 重新生成 commit 信息
   - `custom/c`: 输入自定义 commit 信息


## 📝 Commit 信息格式

1. 使用格式 '[类型]: 描述'，其中类型包括：
   - feat (新功能)
   - fix (错误修复)
   - docs (文档)
   - style (格式化，缺少分号等)
   - refactor (代码重构)
   - perf (性能改进)
   - test (添加测试)
   - chore (维护任务)

2. 使用祈使句风格描述
3. 主题行限制在50个字符以内
4. 如有需要，添加空行后跟项目符号列出额外细节
5. 尽可能描述详细同时保持简洁
6. 返回的提交信息应直接可用于提交编辑，无需进一步修改
7. 始终用英语回复

示例格式：
[feat]: 添加用户认证系统

- 实现JWT令牌生成
- 添加登录/登出端点
- 创建用户认证中间件

## 📄 许可证

[MIT License](LICENSE)
