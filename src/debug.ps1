Import-Module "$PSScriptRoot\bin\Playwright.win" -Force
Import-Module "$PSScriptRoot/Playwright" -Force



    $playwright = await ([Microsoft.Playwright.Playwright]::CreateAsync())
    $BrowserLaunchOptions = New-Object -TypeName 'Microsoft.Playwright.BrowserTypeLaunchOptions'

    $BrowserLaunchOptions.Headless = $false
    $BrowserLaunchOptions.Channel = 'chrome'
    $browser = await ($playwright.Chromium.LaunchAsync($BrowserLaunchOptions))

    $context = await ( $browser.NewContextAsync() )

    $page = await ( $context.NewPageAsync() )

    $test = await ( $page.PauseAsync() )
