# 🤖 Git-ATM (AI Commit Message Generator)

Git-ATM is an intelligent Git commit message generator that uses AI APIs (like OpenAI or DeepSeek) to analyze your code changes and automatically generate clear, standardized commit messages.

## ✨ Features

- Automatically analyzes git diff content
- Uses AI to generate commit messages following best practices
- Supports conventional commit format `[type]: description`
- Supports custom API configurations
- Interactive confirmation mechanism
- Supports changes in both staged and working directories
- Multi-language support (English, Chinese) with language parameter control

## 🚀 Installation

1. Clone the repository:
```bash
git clone https://github.com/SYYANI/git-atm.git
```

2. Add execution permissions:
```bash
chmod +x git-atm.sh
```

3. Create a configuration file:
```bash
cp .atmrc.example ~/.atmrc
```

4. Edit the `~/.atmrc` file to set your API key and preferences:
```bash
# API Configuration
TOKEN="your-api-key-here"
MODEL="gpt-4" # or your preferred model
BASE_URL="https://api.openai.com/v1/chat/completions" # or another compatible API endpoint

# Default language setting (en for English, zh for Chinese)
DEFAULT_LANG="en"
```

5. Create a symbolic link to add it to your PATH (allowing you to use `git atm` as a git subcommand):
```bash
ln -s $(pwd)/git-atm.sh /usr/local/bin/git-atm
chmod +x /usr/local/bin/git-atm
```

## 💡 Usage

1. Make code changes in your Git repository
2. Run git-atm:
```bash
# Generate commit message in English (default)
git atm

# Generate commit message in Chinese
git atm --lang zh
# or
git atm -l zh
```
3. Review the generated commit message and choose:
   - `yes/y`: Use the generated message to create the commit
   - `no/n`: Cancel the operation
   - `regenerate/r`: Generate a new commit message
   - `custom/c`: Enter a custom commit message

## 📝 Commit Message Format

The generated commit messages follow the conventional commit format:

```
[type]: description

- Optional bullet point details
- Additional information
```

Where `type` is one of:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding tests
- `chore`: Maintenance tasks

The format follows these rules:
- Uses imperative mood
- Subject line limited to 50 characters
- Optional description with bullet points separated by a blank line
- Generated in English or Chinese based on your language setting

## 🔧 Configuration

You can customize the behavior of Git-ATM by editing the `~/.atmrc` file:

```bash
# API Configuration
TOKEN="your-api-key-here"              # Your OpenAI/DeepSeek API key
MODEL="gpt-4"                          # AI model to use
BASE_URL="https://api.openai.com/v1/chat/completions"  # API endpoint

# Language preference
DEFAULT_LANG="en"                      # Default language (en/zh)
```

## 🌐 Language Support

Git-ATM supports generating commit messages in:
- English (default): Use `git atm` or `git atm --lang en`
- Chinese: Use `git atm --lang zh`

The language setting determines both the user interface messages and the generated commit message language.

## 📄 License

[MIT License](LICENSE)

## 🤝 Contributing

Issues and Pull Requests are welcome! Feel free to contribute to this project by:
- Reporting bugs
- Suggesting enhancements
- Adding new features
- Improving documentation

## 📮 Contact

For questions or suggestions, please contact me through GitHub Issues.