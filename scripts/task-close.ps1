param([Parameter(Mandatory=$true)][string]$TaskFile,[switch]$UserConfirmed)
$ErrorActionPreference = 'Stop'
if(-not $UserConfirmed){ throw '用户尚未确认关闭；只能先汇报结果，不能执行结束快照或修改状态。' }
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent (Split-Path -Parent $TaskFile)
$taskId = [IO.Path]::GetFileNameWithoutExtension($TaskFile)
$text=Get-Content -LiteralPath $TaskFile -Raw
$m=[regex]::Match($text,'(?m)^Tokdash session IDs:\s*(.+)$');$sid=$m.Groups[1].Value.Trim()
$tokens='unavailable';$cost='unavailable';$events='unavailable'
if($sid -and $sid -ne 'unavailable'){$snap=(& (Join-Path $scriptRoot 'tokdash-session-snapshot.ps1') -SessionId $sid | ConvertFrom-Json);$tokens=$snap.tokens;$cost=$snap.cost;$events=$snap.token_events}
$now=(Get-Date).ToString('o')
$started=[regex]::Match($text,'(?m)^Started:\s*(.+)$').Groups[1].Value.Trim()
$duration='unavailable'; try{$duration=[math]::Max(0,[int](([datetimeoffset]$now-[datetimeoffset]$started).TotalMinutes))}catch{}
$text=$text -replace '(?m)^Completed:.*$', "Completed: $now"
$text=$text -replace '(?m)^Duration minutes:.*$', "Duration minutes: $duration"
$text=$text -replace '(?m)^Tokdash end tokens:.*$', "Tokdash end tokens: $tokens"
$text=$text -replace '(?m)^Tokdash end cost:.*$', "Tokdash end cost: $cost"
$text=$text -replace '(?m)^Tokdash end token events:.*$', "Tokdash end token events: $events"
$text=$text -replace '(?m)^Status:.*$', 'Status: 已完成'
Set-Content -LiteralPath $TaskFile -Value $text -Encoding utf8
[pscustomobject]@{timestamp=$now;task_id=(Split-Path $TaskFile -LeafBase);session_id=$sid;model='unavailable';input_tokens=$null;output_tokens=$null;total_tokens=$tokens;cost=$cost;source='tokdash-end'} | ConvertTo-Json -Compress | Add-Content -LiteralPath (Join-Path (Split-Path (Split-Path $TaskFile -Parent) -Parent) 'logs\token-usage.jsonl')

# Keep the index and report in lockstep with the detail file.
$indexFile = Join-Path $projectRoot 'TASKS.md'
$index = Get-Content -LiteralPath $indexFile -Raw
$escapedId = [regex]::Escape($taskId)
$index = [regex]::Replace($index, "(?m)^(\|\s*$escapedId\s*\|.*?\|\s*)[^|]+(\s*\|.*)$", '${1}已完成${2}', 1)
if ($index -notmatch "(?m)^\|\s*$escapedId\s*\|") { throw "Task index entry not found: $taskId" }
Set-Content -LiteralPath $indexFile -Value $index -Encoding utf8

$reportsDir = Join-Path $projectRoot 'reports'
New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null
$reportFile = Join-Path $reportsDir "$taskId.md"
if (-not (Test-Path -LiteralPath $reportFile)) {
    @("# $taskId closeout", "", "Status: 已完成", "Completed: $now", "Duration minutes: $duration", "", "Commit: unavailable", "", "Token usage: $tokens", "Cost: $cost", "Token events: $events") | Set-Content -LiteralPath $reportFile -Encoding utf8
}

# Refuse to report success if any durable record still disagrees.
$detailStatus = [regex]::Match((Get-Content -LiteralPath $TaskFile -Raw), '(?m)^Status:\s*(.+)$').Groups[1].Value.Trim()
$indexLine = (Get-Content -LiteralPath $indexFile | Where-Object { $_ -match "^\|\s*$escapedId\s*\|" } | Select-Object -First 1)
if ($detailStatus -ne '已完成' -or $indexLine -notmatch '\|\s*已完成\s*\|') { throw "Task close consistency check failed: $taskId" }
[pscustomobject]@{session_id=$sid;tokens=$tokens;cost=$cost;timestamp=$now;source='tokdash';task_id=$taskId;status='已完成'} | ConvertTo-Json
