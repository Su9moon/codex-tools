[CmdletBinding()]
param([string]$ProjectRoot = (Get-Location).Path)

$root = (Resolve-Path -LiteralPath $ProjectRoot).Path
Write-Output "Project: $root"
if (-not (Test-Path -LiteralPath (Join-Path $root '.git'))) { Write-Output 'Git: not initialized'; exit 0 }
Write-Output 'Git:'
git -C $root status --short --branch
$taskIndex = Join-Path $root 'TASKS.md'
if (Test-Path -LiteralPath $taskIndex) {
    $active = Select-String -LiteralPath $taskIndex -Pattern '\| .*\| (In progress|Blocked) \|' | ForEach-Object { $_.Line }
    Write-Output 'Active tasks:'
    if ($active) { $active } else { 'None' }
}
$usageLog = Join-Path $root 'logs\token-usage.jsonl'
if ((Test-Path -LiteralPath $usageLog) -and (Get-Item -LiteralPath $usageLog).Length -gt 0) {
    Write-Output "Latest token record: $(Get-Content -LiteralPath $usageLog -Tail 1)"
} else {
    Write-Output 'Latest token record: unavailable'
}
