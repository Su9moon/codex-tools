param([Parameter(Mandatory=$true)][string]$TaskFile)
$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sid = & (Join-Path $scriptRoot 'tokdash-current-session.ps1')
$now = (Get-Date).ToString('o')
$tokens='unavailable';$cost='unavailable';$events='unavailable'
if($sid){$snap = (& (Join-Path $scriptRoot 'tokdash-session-snapshot.ps1') -SessionId $sid | ConvertFrom-Json);$tokens=$snap.tokens;$cost=$snap.cost;$events=$snap.token_events}
$text=Get-Content -LiteralPath $TaskFile -Raw
$text=$text -replace '(?m)^Started:.*$', "Started: $now"
$text=$text -replace '(?m)^Status:.*$', 'Status: 进行中'
$text=$text -replace '(?m)^Tokdash session IDs:.*$', "Tokdash session IDs: $sid"
$text=$text -replace '(?m)^Tokdash start tokens:.*$', "Tokdash start tokens: $tokens"
$text=$text -replace '(?m)^Tokdash start cost:.*$', "Tokdash start cost: $cost"
$text=$text -replace '(?m)^Tokdash start token events:.*$', "Tokdash start token events: $events"
Set-Content -LiteralPath $TaskFile -Value $text -Encoding utf8
[pscustomobject]@{timestamp=$now;task_id=(Split-Path $TaskFile -LeafBase);session_id=$sid;model='unavailable';input_tokens=$null;output_tokens=$null;total_tokens=$tokens;cost=$cost;source='tokdash-start'} | ConvertTo-Json -Compress | Add-Content -LiteralPath (Join-Path (Split-Path (Split-Path $TaskFile -Parent) -Parent) 'logs\token-usage.jsonl')
[pscustomobject]@{session_id=$sid;tokens=$tokens;cost=$cost;timestamp=$now;source='tokdash'} | ConvertTo-Json
