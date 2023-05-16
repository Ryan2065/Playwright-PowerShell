$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$binFolder = [System.IO.Path]::Combine($PSScriptRoot, 'bin')
$PlaywrightDepsFolder = [System.IO.Path]::Combine($binFolder, 'PlaywrightDeps')
$PlaywrightModuleFolder = [System.IO.Path]::Combine($binFolder, 'Playwright')

$DependencyPsm1File = @'
$dllFiles = Get-ChildItem -Path $PSScriptRoot -Filter '*.dll'
foreach($dllFile in $dllFiles){
    $null = [Reflection.Assembly]::LoadFile($dllFile.FullName)
}

'@


if(Test-Path $binFolder -ErrorAction SilentlyContinue){
    $null = Remove-Item $binFolder -Force -Recurse
}

$null = New-Item -ItemType Directory -Path $PlaywrightDepsFolder -Force -ErrorAction SilentlyContinue

Set-Location $PlaywrightDepsFolder

nuget install Microsoft.Playwright

$PlaywrightDir = Get-ChildItem -Directory -Filter 'Microsoft.Playwright*'
if($PlaywrightDir.Count -ne 1){
    throw "Could not find the Microsoft.Playwright dependency directory, or found too many"
}

$DotPlaywright = [System.IO.Path]::Combine($PlaywrightDir.FullName, '.playwright')
$DotPlaywrightPackage = [System.IO.Path]::Combine($DotPlaywright, 'package')
$DotPlaywrightNode = [System.IO.Path]::Combine($DotPlaywright, 'node')
$DotPlaywrightNodeLicense = [System.IO.Path]::Combine($DotPlaywrightNode, 'LICENSE')

Set-Location $DotPlaywrightNode

$Frameworks = (Get-ChildItem -Directory).BaseName

Set-Location $PlaywrightDepsFolder

foreach($framework in $frameworks){
    $NewModuleFolder = "$($PlaywrightModuleFolder).$($framework.Replace('-', '.').Replace('win32_x64', 'win'))"
    $null = New-Item -ItemType Directory -Path $NewModuleFolder -Force -ErrorAction SilentlyContinue

    foreach($fold in (Get-ChildItem -Directory)){
        $netStandardFolder =  [System.IO.Path]::Combine($fold.FullName, 'lib', 'netstandard2.0')
        if(Test-Path $netStandardFolder -ErrorAction SilentlyContinue){
            $dlls = Get-ChildItem -Path $netStandardFolder -Filter '*.dll'
            foreach($dll in $dlls){
                $null = Copy-Item $dll.FullName "$NewModuleFolder/" -Force
            }
        }
    }

    $dotPlaywrightFolder = [System.IO.Path]::Combine($NewModuleFolder, '.playwright')
    $dotPlaywrightNodeFolder = [System.IO.Path]::Combine($dotPlaywrightFolder, 'node')
    
    $DotPlaywrightNodeFramework = [System.IO.Path]::Combine($DotPlaywrightNode, $framework)
    $null = New-Item -ItemType Directory -Path $dotPlaywrightNodeFolder -Force -ErrorAction SilentlyContinue
    
    $null = Copy-Item $DotPlaywrightPackage $dotPlaywrightFolder -Force -Recurse
    $null = Copy-Item $DotPlaywrightNodeLicense $dotPlaywrightNodeFolder -Force
    $null = Copy-Item $DotPlaywrightNodeFramework $dotPlaywrightNodeFolder -Force -Recurse
    $psm1File = [System.IO.Path]::Combine($NewModuleFolder, "Playwright.$($framework.Replace('-', '.').Replace('win32_x64', 'win')).psm1")
    $DependencyPsm1File | Out-File -Encoding utf8 -Force -FilePath $psm1File
}

