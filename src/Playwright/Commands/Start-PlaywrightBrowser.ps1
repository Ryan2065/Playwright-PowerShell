Function Start-PlaywrightBrowser{
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet('Chromium', 'Firefox', 'Webkit')]
        [string]$Browser = 'Chromium',
        [Parameter(Mandatory=$false)]
        [Microsoft.Playwright.BrowserTypeLaunchOptions]$BrowserLaunchOptions
    )
    if($null -ne $Script:BrowserObject){
        $null = $Script:BrowserObject.Dispose()
    }
    if($null -ne $Script:PlaywrightObj){
        $null = $Script:PlaywrightObj.Dispose()
    }
    $Script:PlaywrightObj = await ([Microsoft.Playwright.Playwright]::CreateAsync())
    if($null -eq $BrowserLaunchOptions){
        $BrowserLaunchOptions = New-Object -TypeName 'Microsoft.Playwright.BrowserTypeLaunchOptions'
        $BrowserLaunchOptions.Headless = $false
    }
    if($Browser -eq 'Chromium'){
        $Script:BrowserObject = await ( $Script:PlaywrightObj.Chromium.LaunchAsync($BrowserLaunchOptions) )
    }
    elseif($Browser -eq 'Firefox'){
        $Script:BrowserObject = await ( $Script:PlaywrightObj.Firefox.LaunchAsync($BrowserLaunchOptions) )
    }
    else{
        $Script:BrowserObject = await ( $Script:PlaywrightObj.Webkit.LaunchAsync($BrowserLaunchOptions) )
    }
    return $Script:BrowserObject
}

