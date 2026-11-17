$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$profile = 'C:/Users/Ryan/AppData/Roaming/ModrinthApp/profiles/Fabric 26.3'
$run = Join-Path $repo 'build/validation/run'
New-Item -ItemType Directory -Force $run | Out-Null
foreach ($folder in @('mods', 'config', 'resourcepacks', 'shaderpacks')) {
    Copy-Item -LiteralPath (Join-Path $profile $folder) -Destination $run -Recurse -Force
}
$options = [IO.File]::ReadAllText((Join-Path $profile 'options.txt'), [Text.Encoding]::UTF8)
$options = [regex]::Replace($options, '(?m)^soundCategory_master:.*$', 'soundCategory_master:0.0')
if ($options -notmatch '(?m)^soundCategory_master:0\.0\r?$') { throw 'Mute was not applied' }
[IO.File]::WriteAllText((Join-Path $run 'options.txt'), $options, [Text.UTF8Encoding]::new($false))
Copy-Item -LiteralPath (Join-Path $repo 'build/libs/exordium-2.1.1+26.3.jar') -Destination (Join-Path $run 'mods') -Force
