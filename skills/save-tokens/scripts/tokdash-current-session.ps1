# 优先从本机最近写入的 Codex 会话日志取得 ID；Tokdash API 仅作回退。
# Prefer the newest local Codex session log; use the Tokdash API only as fallback.
[CmdletBinding()]
param([string]$BaseUrl = 'http://127.0.0.1:55423')

$sessionRoot = Join-Path $env:USERPROFILE '.codex\sessions'
if (Test-Path -LiteralPath $sessionRoot) {
    $latest = Get-ChildItem -LiteralPath $sessionRoot -Recurse -File -Filter '*.jsonl' |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
    if ($latest -and $latest.Name -match '([0-9a-f]{8}-[0-9a-f-]{27,})\.jsonl$') {
        Write-Output $Matches[1]
        exit 0
    }
}

try {
    $data = Invoke-RestMethod -Uri "$BaseUrl/api/sessions?tool=codex&period=today" -TimeoutSec 3
    $id = $data.latest_session.session_id
    if ($id) { Write-Output $id } else { Write-Output 'unavailable' }
} catch {
    Write-Output 'unavailable'
}
