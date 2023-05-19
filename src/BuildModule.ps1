$OriginalLocation = Get-Location
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$binFolder = [System.IO.Path]::Combine($PSScriptRoot, 'bin')
$PlaywrightDependencyProject = [System.IO.Path]::Combine($PSScriptRoot, 'Poshwright')

$DependencyPsm1File = @'

$dllFiles = @(Get-ChildItem -Path $PSScriptRoot -Filter '*.dll')
foreach($dllFile in $dllFiles){
    $null = [Reflection.Assembly]::LoadFile($dllFile.FullName)
}
[Poshwright.AssemblyResolver]::EnableAssemblyResolver()

'@

Set-Location $PlaywrightDependencyProject

if(Test-Path $binFolder -ErrorAction SilentlyContinue){
    $null = Remove-Item $binFolder -Force -Recurse
}

$null = New-Item -ItemType Directory -Path $binFolder -Force -ErrorAction SilentlyContinue

$WinProjPath = [System.IO.Path]::Combine($binFolder, 'Playwright.win')

dotnet build -c Release -r win -f net462 -o $WinProjPath

$Winpsm1File = [System.IO.Path]::Combine($WinProjPath, "Playwright.win.psm1")
$DependencyPsm1File | Out-File -Encoding utf8 -Force -FilePath $Winpsm1File

$additionalTargets = @('darwin-arm64', 'darwin-x64', 'linux-arm64', 'linux-x64')

foreach($target in $additionalTargets){
    $projPath = [System.IO.Path]::Combine($binFolder, "Playwright.$($target.Replace('-', '.'))")
    dotnet build -c Release -r $target -f netstandard2.0 -o $projPath
    $temppsm1File = [System.IO.Path]::Combine($projPath, "Playwright.$($target.Replace('-', '.')).psm1")
    $DependencyPsm1File | Out-File -Encoding utf8 -Force -FilePath $temppsm1File

    $nodeFolder = [System.IO.Path]::Combine($projPath, ".playwright", "node")
    $CurrentDir = Get-Location
    Set-Location $nodeFolder
    $dirs = Get-ChildItem -Directory | Where-Object { $_.Name -ne $target }
    foreach($dir in $dirs){ Remove-Item $dir.FullName -Force -Recurse }
    Set-Location $CurrentDir
}

Set-Location $OriginalLocation