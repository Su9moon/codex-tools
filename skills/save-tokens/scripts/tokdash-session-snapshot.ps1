# 读取明确会话的累计 Token/成本，用于工单开始/结束差值计算。
# Read one explicit session's totals for task start/end delta attribution.
[CmdletBinding()]
param([Parameter(Mandatory = $true)][string]$SessionId,[string]$BaseUrl = 'http://127.0.0.1:55423')
try {
    $item = Invoke-RestMethod -Uri "$BaseUrl/api/session?tool=codex&session_id=$SessionId" -TimeoutSec 3
    [PSCustomObject]@{ session_id=$SessionId; tokens=$item.session.tokens; cost=$item.session.cost } | ConvertTo-Json -Compress
} catch { Write-Output 'unavailable' }
