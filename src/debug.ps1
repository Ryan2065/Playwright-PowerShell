Import-Module "$PSScriptRoot/bin/Playwright.win" -Force
Import-Module "$PSScriptRoot/Playwright" -Force

$onAssemblyResolveEventHandler = [System.ResolveEventHandler] {
    param($sender, $e)
    foreach($assembly in [System.AppDomain]::CurrentDomain.GetAssemblies()) {
        if ($assembly.FullName -eq $e.Name) {
            Write-Host "Successful FullName resolution of $($e.Name)" 
            return $assembly
        }
    }
    foreach($assembly in [System.AppDomain]::CurrentDomain.GetAssemblies()) {
        # Get just the name from the FullName (no version)
        $assemblyName = $assembly.FullName.Substring(0, $assembly.FullName.IndexOf(", "))
        if ($e.Name.StartsWith($($assemblyName + ","))) {
            Write-Host "Successful name-only (no version) resolution of $assemblyName" 
            return $assembly
        }
    }
    return $null
}

[System.AppDomain]::CurrentDomain.add_AssemblyResolve($onAssemblyResolveEventHandler)


$playwright = await ([Microsoft.Playwright.Playwright]::CreateAsync())
$BrowserLaunchOptions = New-Object -TypeName 'Microsoft.Playwright.BrowserTypeLaunchOptions'

$BrowserLaunchOptions.Headless = $false
$BrowserLaunchOptions.Channel = 'chrome'
$browser = await ($playwright.Chromium.LaunchAsync($BrowserLaunchOptions))

$context = await ( $browser.NewContextAsync() )

$page = await ( $context.NewPageAsync() )

$test = await ( $page.PauseAsync() )