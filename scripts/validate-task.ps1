param([Parameter(Mandatory=$true)][string]$TaskFile)
$required = @('Status:', 'Started:', 'Completed:', 'Duration minutes:', 'Outcome:', 'Priority:', 'Objective:', 'Rework count:', 'Negative rating count:', 'Tokdash session IDs:', 'Tokdash start tokens:', 'Tokdash end tokens:', 'Tokdash start cost:', 'Tokdash end cost:', 'Tokdash start token events:', 'Tokdash end token events:')
$text = Get-Content -LiteralPath $TaskFile -Raw
$missing = $required | Where-Object { -not $text.Contains($_) }
if ($missing) { Write-Error ("Missing fields: " + ($missing -join ', ')); exit 1 }
if ($text -match 'Status:\s*Completed' -and $text -notmatch '## Objective details') { Write-Error 'Completed task is missing objective details'; exit 1 }
if ($text -match 'Status:\s*(Completed|已完成)' -and ($text -match 'Tokdash start tokens:\s*unavailable' -or $text -match 'Tokdash end tokens:\s*unavailable')) { Write-Error 'Completed task is missing snapshot'; exit 1 }
Write-Output "Valid: $TaskFile"
