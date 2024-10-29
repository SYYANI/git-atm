# 🤖 Git-ATM (AI Commit Message Generator)

Git-ATM 是一个智能的 Git commit 信息生成工具，它使用 OpenAI API 来分析你的代码变更，并自动生成清晰、规范的 commit 信息。

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
git clone git@github.com:falconchen/git-atm.git
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

生成的 commit 信息遵循以下格式：
- 以表示变更类型的 emoji 开头
- 使用祈使语气
- 主题行限制在 50 个字符以内
- 可选的描述部分与主题之间有空行分隔

常用的 emoji 类型：
- ✨ 新功能
- 🐛 Bug 修复
- 📚 文档更新
- 🎨 样式/界面
- ♻️ 重构
- 🚀 性能优化
- 🧪 测试
- 🔧 配置调整
- 🔒 安全相关

## 📄 许可证

[MIT License](LICENSE)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📮 联系方式

如有问题或建议，请通过 GitHub Issues 联系我。
