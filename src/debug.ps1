Import-Module "$PSScriptRoot\bin\Playwright.win" -Force
Import-Module "$PSScriptRoot/Playwright" -Force
$ErrorActionPreference = 'Stop'
$browser = Start-PlaywrightBrowser -Browser 'Chromium' -BrowserChannel 'chrome' -ShowBrowser


$context = Wait-PlaywrightTask ( $browser.NewContextAsync() )

$page = Wait-PlaywrightTask ( $context.NewPageAsync() )

$test = Wait-PlaywrightTask ( $page.PauseAsync() )
