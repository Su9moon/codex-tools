param([string]$CodexHome = (Join-Path $env:USERPROFILE '.codex'))
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repo 'skills\save-tokens'
$target = Join-Path $CodexHome 'skills\save-tokens'
if (-not (Test-Path $source)) { throw "Skill source not found: $source" }
New-Item -ItemType Directory -Path $target -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $source 'SKILL.md') -Destination $target -Force
Copy-Item -LiteralPath (Join-Path $source 'agents') -Destination $target -Recurse -Force
Copy-Item -LiteralPath (Join-Path $source 'scripts') -Destination $target -Recurse -Force
$health = 'unavailable'
try { $health = (Invoke-RestMethod 'http://127.0.0.1:55423/health' -TimeoutSec 3).status } catch { $health = 'unavailable (Tokdash is not running)' }
[pscustomobject]@{skill=$target;tokdash=$health;message='Skill installed; restart Codex only if the Skill list is not refreshed'} | ConvertTo-Json
