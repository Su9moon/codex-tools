# 查询本机 Tokdash 的聚合统计；只访问 localhost，不重解析会话。
# Query aggregate local Tokdash usage; localhost only, no session reparsing.
[CmdletBinding()]
param(
    [ValidateSet('today', 'week', 'month')]
    [string]$Period = 'today',
    [string]$BaseUrl = 'http://127.0.0.1:55423'
)

try {
    # 连接失败不阻断任务工作流；返回简洁的不可用状态。
    # A failed local connection must not block the task workflow.
    $usage = Invoke-RestMethod -Uri "$BaseUrl/api/usage?period=$Period" -TimeoutSec 3
} catch {
    Write-Output 'Tokdash: unavailable'
    exit 0
}

# 保持输出紧凑，供状态与任务报告引用。
# Keep output compact for status and task-report use.
$codex = $usage.by_tool.codex
[PSCustomObject]@{
    Period = $usage.period
    Timestamp = $usage.timestamp
    TotalTokens = $usage.total_tokens
    TotalCost = $usage.total_cost
    CodexTokens = $codex.tokens
    CodexCost = $codex.cost
    CacheHitRate = $codex.cache_hit_rate
} | ConvertTo-Json -Compress
