# 使用 Codex Desktop 注入的当前 task ID；缺失时宁可不可用，也不猜测其他会话。
# Use the Codex Desktop task ID; report unavailable rather than guessing another session.
[CmdletBinding()]
param([string]$BaseUrl = 'http://127.0.0.1:55423')

if ($env:CODEX_THREAD_ID) { Write-Output $env:CODEX_THREAD_ID } else { Write-Output 'unavailable' }
