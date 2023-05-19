Function Start-PlaywrightBrowser{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('Chromium', 'Firefox', 'Webkit')]
        [string]$Browser,
        [Parameter(Mandatory=$false)]
        [ValidateSet('chrome', 'msedge', 'chrome-beta', 'msedge-beta', 'msedge-dev')]
        [string]$BrowserChannel,
        [Parameter(Mandatory=$false)]
        [Microsoft.Playwright.BrowserTypeLaunchOptions]$BrowserLaunchOptions,
        [Parameter(Mandatory=$false)]
        [switch]$ShowBrowser
    )
    
    if($null -ne $Script:BrowserObject){
        $null = $Script:BrowserObject.Dispose()
    }
    if($null -ne $Script:PlaywrightObj){
        $null = $Script:PlaywrightObj.Dispose()
    }
    $Script:PlaywrightObj = Wait-PlaywrightTask ([Microsoft.Playwright.Playwright]::CreateAsync())
    
    if($null -eq $BrowserLaunchOptions){
        $BrowserLaunchOptions = New-Object -TypeName 'Microsoft.Playwright.BrowserTypeLaunchOptions'
    }

    if($true -eq $ShowBrowser){
        $BrowserLaunchOptions.Headless = $false
    }

    if(-not ( [string]::IsNullOrEmpty($BrowserChannel) )){
        $BrowserLaunchOptions.Channel = $BrowserChannel
    }

    $Script:BrowserObject = Wait-PlaywrightTask ( $Script:PlaywrightObj."$Browser".LaunchAsync($BrowserLaunchOptions))

    return $Script:BrowserObject
}

