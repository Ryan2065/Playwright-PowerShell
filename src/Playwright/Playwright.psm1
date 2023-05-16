# Playwright requires the playwright dependencies, which are in a separate module
# Ensure they are loaded or the module exists - if not throw error

$Rid = [System.Runtime.InteropServices.RuntimeInformation]::RuntimeIdentifier

$Assemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()
$PlaywrightLoaded = $false
foreach($assembly in $Assemblies){
    if($assembly.Location -like '*Microsoft.Playwright.dll'){
        $PlaywrightLoaded = $true
    }
}

$RequiredModule = ''
if($PSVersionTable.PSVersion -lt ([Version]'6.0') -or $Rid -like 'win*' ){
    $RequiredModule = 'Playwright.win'
}
elseif($rid -like 'linux*' -and $Rid -like '*arm*'){
    $RequiredModule = 'Playwright.linux.arm64'
}
elseif($rid -like 'linux*'){
    $RequiredModule = 'Playwright.linux.x64'
}
elseif($rid -like 'darwin*' -and $Rid -like '*arm*'){
    $RequiredModule = 'Playwright.darwin.arm64'
}
elseif($rid -like 'darwin*'){
    $RequiredModule = 'Playwright.darwin.x64'
}

if($false -eq $PlaywrightLoaded -and [string]::IsNullOrEmpty($RequiredModule)){
    throw "Playwright dependencies required! Could not detect which module required. Please install dependencies and import before importing Playwright"
    return
}
elseif($false -eq $PlaywrightLoaded){
    if($FoundModule = Get-Module -Name $RequiredModule -ListAvailable -ErrorAction SilentlyContinue ){
        Import-Module $FoundModule -Force
    }
    else{
        throw "Could not find required module $($RequiredModule) - Please install and then try to import again"
        return
    }
}

$CommandFolder = [System.IO.Path]::Combine($PSScriptRoot, 'Commands')
$CommandScripts = Get-ChildItem $CommandFolder -Filter '*.ps1'

Foreach($CommandScript in $CommandScripts){
    . $CommandScript.FullName
}

Set-Alias -Name 'await' -Value 'Wait-PlaywrightTask'

Export-ModuleMember -Function $CommandScripts.BaseName -Alias 'await'