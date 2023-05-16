Function ConvertTo-PlaywrightPowerShell{
    Param(
        [ValidateNotNullOrEmpty()]
        [string]$GeneratorCode
    )
    $output = ""
    $GeneratorCode = $GeneratorCode.Split("`n")
    $startConverter = $false
    foreach($line in $GeneratorCode){
        if([string]::IsNullOrEmpty($line)){ continue }
        if($line.Trim() -eq 'var context = await browser.NewContextAsync();'){
            $startConverter = $true
        }
        if($false -eq $startConverter){ continue }

    }
}
