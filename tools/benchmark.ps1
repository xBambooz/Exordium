param([ValidateSet('on','off')][string]$Mode, [int]$Port)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$validation = Join-Path $repo 'build/validation'
$run = Join-Path $validation 'run'
$data = Join-Path $validation 'benchmark-data'
$utf8 = [Text.UTF8Encoding]::new($false)
New-Item -ItemType Directory -Force (Join-Path $data 'scenes') | Out-Null
if (!(Test-Path (Join-Path $data 'scenes/benchmark-route'))) {
    Copy-Item -LiteralPath 'C:/Users/Ryan/Documents/Benchmark Mod/scenes/benchmark-route' -Destination (Join-Path $data 'scenes') -Recurse
}
[IO.File]::WriteAllText((Join-Path $run 'config/benchmarkmod.json'), (@{dataDirectory=$data} | ConvertTo-Json), $utf8)
[IO.File]::WriteAllText((Join-Path $data 'settings.json'), '{"warmupSeconds":8,"measuredRuns":3,"conditioningRun":false,"recordMetrics":true,"gpuUsageSampling":true,"onboardingSeen":true}', $utf8)
$jar = Join-Path $run 'mods/exordium-2.1.1+26.3.jar'
if ($Mode -eq 'on') { Copy-Item -LiteralPath (Join-Path $repo 'build/libs/exordium-2.1.1+26.3.jar') -Destination $jar -Force }
elseif (Test-Path $jar) { Remove-Item -LiteralPath $jar }
node C:/Users/Ryan/Documents/ai-brain/tools/game-guard.mjs
if ($LASTEXITCODE) { throw 'Game guard blocked launch' }
$env:MC_HARNESS_PRODUCTION = '1'
$env:MC_HARNESS_JVM_ARGS = '["-XX:StackShadowPages=32"]'
& C:/Users/Ryan/source/repos/mc-agent-harness/tools/launch.ps1 -Project $repo -RunDirectory $run -Port $Port -Monitor secondary -Width 1920 -Height 1080 -JavaHome 'C:/Program Files/GraalVM/graalvm-jdk-25.0.4+7.1' -TimeoutSeconds 90 -Pending
$session = Get-Content -LiteralPath "C:/Users/Ryan/source/repos/mc-agent-harness/instances/$Port/session.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$headers = @{Authorization="Bearer $($session.token)"}
function Call([string]$Endpoint, [string]$Body) {
    Invoke-RestMethod "http://127.0.0.1:$Port/$Endpoint" -Headers $headers -Method Post -ContentType application/json -Body $Body -TimeoutSec 15
}
$deadline = (Get-Date).AddMinutes(2)
do {
    try { $status = Call 'status' '{}'; if ($status.screen -eq 'TitleBridgeScreen' -or $status.screen -eq 'TitleScreen') { break } } catch { }
    Start-Sleep -Seconds 2
} while ((Get-Date) -lt $deadline)
if (!$status.ok) { throw 'Client did not become ready' }
Call 'window' '{"monitor":"secondary","x":2560,"y":0,"width":1920,"height":1080,"behind":true}' | Out-Null
Call 'reflexium' (@{benchmark=$true;scene='benchmark-route';label="exordium-$Mode"} | ConvertTo-Json)
