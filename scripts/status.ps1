[CmdletBinding()]
param([string]$ProjectRoot = (Get-Location).Path)

$root = (Resolve-Path -LiteralPath $ProjectRoot).Path
Write-Output "Project: $root"
if (-not (Test-Path -LiteralPath (Join-Path $root '.git'))) { Write-Output 'Git: not initialized'; exit 0 }
Write-Output 'Git:'
git -C $root status --short --branch
$taskIndex = Join-Path $root 'TASKS.md'
if (Test-Path -LiteralPath $taskIndex) {
    $active = Select-String -LiteralPath $taskIndex -Pattern '\| .*\| (In progress|Blocked|进行中|阻塞)\s*\|' | ForEach-Object { $_.Line }
    Write-Output 'Active tasks:'
    if ($active) { $active } else { 'None' }
}
$sidScript = Join-Path $root 'scripts\tokdash-current-session.ps1'
if (Test-Path $sidScript) {
    $sid = & $sidScript
    Write-Output "Tokdash session: $sid"
    if ($sid) {
        $snapScript = Join-Path $root 'scripts\tokdash-session-snapshot.ps1'
        if (Test-Path $snapScript) { try { Write-Output "Current snapshot: $(& $snapScript -SessionId $sid)" } catch { Write-Output "Tokdash snapshot: unavailable ($($_.Exception.Message))" } }
    }
} else { Write-Output 'Tokdash session: unavailable (helper not installed)' }
$unfinished = Select-String -LiteralPath $taskIndex -Pattern '\|\s*(TASK-\d+)\s*\|.*\|\s*(进行中|阻塞|待用户确认关闭|待确认开始)\s*\|' -ErrorAction SilentlyContinue
Write-Output "Unclosed task rows: $(@($unfinished).Count)"
$usageLog = Join-Path $root 'logs\token-usage.jsonl'
if ((Test-Path -LiteralPath $usageLog) -and (Get-Item -LiteralPath $usageLog).Length -gt 0) {
    Write-Output "Latest token record: $(Get-Content -LiteralPath $usageLog -Tail 1)"
} else {
    Write-Output 'Latest token record: unavailable'
}
