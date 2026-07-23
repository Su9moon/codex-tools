param([Parameter(Mandatory=$true)][string]$SessionId)
$ErrorActionPreference = 'Stop'
$result = Invoke-RestMethod -Uri ('http://127.0.0.1:55423/api/codex/session?session_id=' + [uri]::EscapeDataString($SessionId)) -Method Get
$item = if($result.session){$result.session}else{$result}
[pscustomobject]@{session_id=$SessionId;tokens=$item.tokens;cost=$item.cost;token_events=$item.token_events;source='tokdash';timestamp=(Get-Date).ToString('o')} | ConvertTo-Json
