param([string]$Period = 'today')
$ErrorActionPreference = 'Stop'
$result = Invoke-RestMethod -Uri ("http://127.0.0.1:55423/api/usage?period=" + [uri]::EscapeDataString($Period)) -Method Get
$result | ConvertTo-Json -Depth 8
