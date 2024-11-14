#!/bin/bash

if [ -f ~/.atmrc ]; then
    source ~/.atmrc
fi
# Default configuration
BASE_URL=${ATM_OPENAI_API_BASE_URL:-"https://api.openai.com/v1/completions"}
MODEL=${ATM_OPENAI_API_MODEL:-"gpt-4"}
TOKEN=${ATM_OPENAI_API_TOKEN:-"your-api-token-here"}

# Updated prompt to generate [type]: [description] format
PROMPT="Take a deep breath and work on this problem step-by-step. Summarize the provided diff into a clear and concise written commit message. Follow these rules:

1. Use the format '[type]: description' where type is one of:
   - feat (new feature)
   - fix (bug fix)
   - docs (documentation)
   - style (formatting, missing semicolons, etc)
   - refactor (refactoring code)
   - perf (performance improvements)
   - test (adding tests)
   - chore (maintenance tasks)

2. Use the imperative style for the description
3. Limit the subject line to 50 characters
4. If needed, add a blank line followed by bullet points for additional details
5. Be as descriptive as possible while keeping it concise
6. Return the commit message ready to be pasted into commit edits without further editing
7. Always reply in English

Example format:
[feat]: add user authentication system

- Implement JWT token generation
- Add login/logout endpoints
- Create user authentication middleware

Provide only the commit message, without any additional explanations or formatting."

# 获取git diff
DIFF=$(git diff --cached)
USE_STAGED=true

if [ -z "$DIFF" ]; then
  echo "暂存区没有更改，检查工作区的更改..."
  
  # 检查是否存在首次提交
  if git rev-parse --verify HEAD >/dev/null 2>&1; then
    DIFF=$(git diff HEAD)
  else
    # 如果是首次提交，获取所有未追踪和修改的文件的差异
    DIFF=$(git diff)
  fi
  
  USE_STAGED=false
  if [ -z "$DIFF" ]; then
    echo "工作区也没有更改,请先执行git add"
    exit 1
  fi
fi

# 准备请求数据
REQUEST_DATA=$(jq -n \
                  --arg model "$MODEL" \
                  --arg prompt "$PROMPT\n\n$DIFF" \
                  --arg max_tokens "2048" \
                  --arg temperature "0.5" \
                  --arg   echo "false" \
                  '{
                    model: $model,
                    messages: [
                      {role: "system", content: "You are a helpful assistant"},
                      {role: "user", content: $prompt}
                    ],
                    max_tokens: $max_tokens|tonumber,
                    temperature: $temperature|tonumber
                  }')

# 发送请求到API并处理可能的错误
send_api_request() {
  local response
  local http_code
  response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    --data-raw "$REQUEST_DATA")

  http_code=$(echo "$response" | tail -n1)
  body=$(echo "$response" | sed '$d')

  if [ "$http_code" != "200" ]; then
    echo "错误：API请求失败，HTTP状态码：$http_code"
    echo "响应内容：$body"
    return 1
  fi

  if ! echo "$body" | jq . >/dev/null 2>&1; then
    echo "错误：API返回的不是有效的JSON格式"
    echo "响应内容：$body"
    return 1
  fi

  echo "$body"
}

# 使用错误处理发送API请求
RESPONSE=$(send_api_request)
if [ $? -ne 0 ]; then
  echo "生成提交信息失败，请检查网络连接或API配置。"
  exit 1
fi

# 提取生成的提交信息并确保格式正确
COMMIT_MSG=$(echo "$RESPONSE" | jq -r '.choices[0].message.content' | sed 's/^```//; s/```$//')

# 验证提交信息格式
if ! echo "$COMMIT_MSG" | grep -qE '^\[?(feat|fix|docs|style|refactor|perf|test|chore|ci)(\([^)]+\))?\]?: .+$'; then
  echo "警告：生成的提交信息可能不符合预期格式"
fi

if [ -z "$COMMIT_MSG" ]; then
  echo "错误：无法从API响应中提取提交信息"
  exit 1
fi

# 显示生成的提交信息
echo -e "\n生成的提交信息：\n$COMMIT_MSG\n"

# 询问确认
while true; do
  read -p "您想使用这个提交信息吗？(yes/no/regenerate/custom) " CONFIRM
  case $CONFIRM in
    yes|y)
      if [ "$USE_STAGED" = true ]; then
        # 创建提交（使用暂存区的更改）
        git commit -m "$COMMIT_MSG"
      else
        # 添加所有更改并创建提交（使用工作区的更改）
        git add -A
        git commit -m "$COMMIT_MSG"
      fi
      echo "提交成功创建。"
      break
      ;;
    no|n)
      echo "提交已取消。"
      break
      ;;
    regenerate|r)
      echo "重新生成提交信息..."
      # 这里重新调用API生成新的提交信息
      RESPONSE=$(send_api_request)
      if [ $? -ne 0 ]; then
        echo "重新生成提交信息失败，请重试。"
        continue
      fi
      COMMIT_MSG=$(echo "$RESPONSE" | jq -r '.choices[0].message.content' | sed 's/^```//; s/```$//')
      if [ -z "$COMMIT_MSG" ]; then
        echo "错误：无法从API响应中提取提交信息"
        continue
      fi
      echo -e "\n新生成的提交信息：\n$COMMIT_MSG\n"
      ;;
    custom|c)
      echo "请输入您的自定义提交信息（输入完成后，在新行输入 'EOF' 并按回车结束）："
      CUSTOM_MSG=""
      while IFS= read -r line; do
        if [ "$line" = "EOF" ]; then
          break
        fi
        CUSTOM_MSG+="$line"$'\n'
      done
      if [ -n "$CUSTOM_MSG" ]; then
        if [ "$USE_STAGED" = true ]; then
          git commit -m "$CUSTOM_MSG"
        else
          git add -A
          git commit -m "$CUSTOM_MSG"
        fi
        echo "使用自定义信息创建提交成功。"
        break
      else
        echo "提交信息不能为空，请重新选择。"
      fi
      ;;
    *)
      echo "无效的输入，请输入 yes、no、regenerate 或 custom。"
      ;;
  esac
done