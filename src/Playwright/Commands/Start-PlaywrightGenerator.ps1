Function Start-PlaywrightGenerator{
    Param(
        [string]$Url
    )
    $argumentsToSend = @('codegen')
    if(-not ([string]::IsNullOrEmpty($ur))){
        $argumentsToSend += $url
    }
    $null = [Microsoft.Playwright.Program]::main($argumentsToSend)
}
