# git-atm.ps1
param(
    [string]$lang = "en"
)

# 获取脚本所在目录
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 加载配置
$configFile = "$scriptDir\.atmrc.ps1"
if (Test-Path $configFile) {
    . $configFile
}

# 设置默认值
if (-not $TOKEN) { $TOKEN = "" }
if (-not $MODEL) { $MODEL = "deepseek-chat" }
if (-not $BASE_URL) { $BASE_URL = "https://api.deepseek.com/v1/chat/completions" }

# 选择提示文件
if ($lang -eq "zh") {
    $promptFile = "$scriptDir\prompt_zh.txt"
} else {
    $promptFile = "$scriptDir\prompt_en.txt"
}

# 检查提示文件是否存在
if (-not (Test-Path $promptFile)) {
    Write-Error "提示文件不存在: $promptFile"
    exit 1
}

# 读取提示内容
$prompt = Get-Content -Path $promptFile -Raw

# 获取git diff
# 检查暂存区和工作区
$useStaged = $true
$diff = git diff --cached
if (-not $diff) {
    Write-Host "暂存区没有更改，检查工作区的更改..."
    
    # 检查是否是首次提交
    $hasHead = $null -ne (git rev-parse --verify HEAD 2>&1)
    
    if ($hasHead) {
        $diff = git diff HEAD
    } else {
        # 如果是首次提交，获取所有未追踪和修改的文件的差异
        $diff = git diff
    }
    
    $useStaged = $false
    
    if (-not $diff) {
        Write-Host "工作区也没有更改，请先执行git add"
        exit 1
    }
}

# 准备请求数据
$requestBody = @{
    model = $MODEL
    messages = @(
        @{
            role = "system"
            content = "You are a helpful assistant"
        },
        @{
            role = "user"
            content = "$prompt`n`n$diff"
        }
    )
    max_tokens = 2048
    temperature = 0.5
} | ConvertTo-Json -Depth 10

# 发送API请求
$response = Invoke-RestMethod -Uri $BASE_URL -Method Post -Headers @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer $TOKEN"
} -Body $requestBody

# 提取生成的commit消息
$commitMsg = $response.choices[0].message.content

# 显示生成的提交信息
Write-Host "`n生成的提交信息："
Write-Host $commitMsg
Write-Host ""

# 询问确认
while ($true) {
    $confirm = Read-Host "您想使用这个提交信息吗？(yes/no/regenerate/custom)"
    
    switch ($confirm.ToLower()) {
        { $_ -in "yes", "y" } {
            if ($useStaged) {
                # 创建提交（使用暂存区的更改）
                $commitMsg | git commit -F -
            } else {
                # 添加所有更改并创建提交（使用工作区的更改）
                git add -A
                $commitMsg | git commit -F -
            }
            Write-Host "提交成功创建。"
            return
        }
        { $_ -in "no", "n" } {
            Write-Host "提交已取消。"
            return
        }
        { $_ -in "regenerate", "r" } {
            Write-Host "重新生成提交信息..."
            # 重新调用API生成
            $response = Invoke-RestMethod -Uri $BASE_URL -Method Post -Headers @{
                "Content-Type" = "application/json"
                "Authorization" = "Bearer $TOKEN"
            } -Body $requestBody
            
            $commitMsg = $response.choices[0].message.content
            
            Write-Host "`n新生成的提交信息："
            Write-Host $commitMsg
            Write-Host ""
        }
        { $_ -in "custom", "c" } {
            Write-Host "请输入您的自定义提交信息（输入完成后按Ctrl+Z并回车结束）："
            $customMsg = @()
            while ($line = Read-Host) {
                $customMsg += $line
            }
            
            if ($customMsg) {
                $customMsg -join "`n" | git commit -F -
                Write-Host "使用自定义信息创建提交成功。"
                return
            } else {
                Write-Host "提交信息不能为空，请重新选择。"
            }
        }
        default {
            Write-Host "无效的输入，请输入 yes、no、regenerate 或 custom。"
        }
    }
}