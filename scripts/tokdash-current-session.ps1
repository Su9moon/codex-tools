$ErrorActionPreference = 'Stop'
$result = Invoke-RestMethod -Uri 'http://127.0.0.1:55423/api/codex/sessions?period=today&include_review_sessions=true' -Method Get
$sessions = @($result.sessions)
if($sessions.Count -eq 0){ exit 0 }
$sessions | Sort-Object last_seen_at -Descending | Select-Object -First 1 -ExpandProperty session_id
