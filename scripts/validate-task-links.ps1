param([Parameter(Mandatory=$true)][string]$ProjectRoot)
$tasks = Join-Path $ProjectRoot 'TASKS.md'
if(-not (Test-Path $tasks)){ throw "TASKS.md not found: $ProjectRoot" }
$ids = @((Get-Content $tasks) | Where-Object { $_ -match '^\|\s*(TASK-\d+)' } | ForEach-Object { [regex]::Match($_,'TASK-\d+').Value })
$missing = @($ids | Where-Object { -not (Test-Path (Join-Path $ProjectRoot ("tasks\$_.md"))) })
if($missing.Count){ throw "Missing task detail files: $($missing -join ', ')" }
"Valid task links: $($ids.Count)"
