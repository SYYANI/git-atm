# 🤖 Git-ATM (AI Commit Message Generator) - PowerShell版本

Git-ATM是一个智能的Git commit消息生成工具，它使用AI API（如OpenAI或DeepSeek）分析你的代码变更，并自动生成清晰、规范的commit消息。这是使用PowerShell实现的更可靠版本。

## ✨ 特性

- 自动分析git diff内容
- 使用AI生成符合最佳实践的commit消息
- 支持常规commit格式 `[type]: description`
- 支持自定义API配置
- 交互式确认机制
- 支持暂存区和工作区的更改
- 多语言支持（英文、中文）与语言参数控制
- PowerShell实现，更可靠的字符串和HTTP请求处理

## 🚀 安装

1. 克隆仓库：
```powershell
git clone https://github.com/yourusername/git-atm.git
cd git-atm
```

3. 编辑 `.atmrc.ps1` 文件，设置你的API密钥和首选项：
```powershell
# Git-ATM 配置文件
$TOKEN = "your-api-key-here"
$MODEL = "gpt-4"
$BASE_URL = "https://api.openai.com/v1/chat/completions"
```

## 💡 使用方法

1. 在你的Git仓库中进行代码更改
2. 运行git-atm：
```powershell
# 使用Git-atm命令
git-atm

# 或直接运行PowerShell脚本
pwsh -File "C:\完整路径\git-atm.ps1"

# 生成中文commit消息
git-atm -lang zh
# 或
.\git-atm.ps1 -lang zh
```
3. 查看生成的commit消息，并选择：
   - `yes/y`: 使用生成的消息创建commit
   - `no/n`: 取消操作
   - `regenerate/r`: 重新生成commit消息
   - `custom/c`: 输入自定义commit消息

## 📝 Commit消息格式

生成的commit消息遵循以下格式：

```
[type]: description

- 可选的项目点详情
- 额外信息
```

其中 `type` 是以下之一：
- `feat`: 新功能
- `fix`: Bug修复
- `docs`: 文档更改
- `style`: 格式化、缺少分号等
- `refactor`: 代码重构
- `perf`: 性能改进
- `test`: 添加测试
- `chore`: 维护任务

格式遵循这些规则：
- 使用祈使语气
- 主题行限制在50个字符内
- 可选的描述与主题之间用空行分隔
- 根据你的语言设置生成英文或中文

## 🔧 配置

你可以通过编辑 `$scriptDir\.atmrc.ps1` 文件来自定义Git-ATM的行为：

```powershell
# API配置
$TOKEN = "your-api-key-here"        # 你的OpenAI/DeepSeek API密钥
$MODEL = "gpt-4"                    # 要使用的AI模型
$BASE_URL = "https://api.openai.com/v1/chat/completions"  # API端点

# 可选：设置默认语言 (未使用时默认为英文)
$DEFAULT_LANG = "en"                # 默认语言(en/zh)
```

## 🌐 语言支持

Git-ATM支持生成以下语言的commit消息：
- 英文（默认）：使用 `git atm` 或 `.\git-atm.ps1`
- 中文：使用 `git atm -lang zh` 或 `.\git-atm.ps1 -lang zh`

语言设置决定了用户界面消息和生成的commit消息的语言。

## 🔍 PowerShell相关说明

- 此版本使用PowerShell脚本实现，更可靠地处理复杂字符串和HTTP请求
- 使用内置的JSON处理功能
- 更简洁的错误处理和用户交互
- 配置文件使用PowerShell语法
- 如遇执行策略问题，可能需要调整执行策略或使用`-ExecutionPolicy Bypass`参数

## 📋 系统要求

- PowerShell 5.1或更高版本（Windows 10/11自带）
- Git

## 📄 许可证

[MIT License](LICENSE)

## 🤝 贡献

欢迎Issues和Pull Requests！欢迎通过以下方式为这个项目做出贡献：
- 报告bug
- 提出改进建议
- 添加新功能
- 改进文档

## 📮 联系

如有问题或建议，请通过GitHub Issues联系我。