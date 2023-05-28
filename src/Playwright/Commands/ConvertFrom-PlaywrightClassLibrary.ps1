Function ConvertFrom-PlaywrightClassLibrary{
    Param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$true, ParameterSetName = 'CodeParameter')]
        [string]$GeneratorCode,
        [Parameter(Mandatory = $true, ParameterSetName = 'ClipParameter')]
        [switch]$FromClipboard,
        [Parameter(Mandatory=$false, ParameterSetName = 'CodeParameter')]
        [Parameter(Mandatory=$false, ParameterSetName = 'ClipParameter')]
        [switch]$SetClipboard
    )
    $output = @()
    if($FromClipboard){
        $SplitGeneratorCode = (Get-Clipboard).Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)
    }
    else{
        $SplitGeneratorCode = $GeneratorCode.Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)
    }
    $startConverter = $false
    foreach($line in $SplitGeneratorCode){
        if([string]::IsNullOrWhiteSpace($line)){ continue }
        if($line.Trim() -eq 'var context = await browser.NewContextAsync();'){
            $startConverter = $true
            $output += "`$browser = Start-PlaywrightBrowser -Browser 'Chromium' -ShowBrowser"
            $output += "`$context = Wait-PlaywrightTask ( `$browser.NewContextAsync() )"
            $output += "`$page = Wait-PlaywrightTask ( `$context.NewPageAsync() )"
            continue
        }
        if($false -eq $startConverter){ continue }
        elseif($line -like '*await context.NewPageAsync();*') { continue }
        elseif($line.Trim() -eq '}'){ continue }
        $line = $line.Trim().TrimEnd(';')

        $newLine = $line.Replace(' page.', ' $page.').replace('await ', 'Wait-PlaywrightTask (').replace('new() {', '@{')

        if($newLine -like '*Wait-PlaywrightTask*') { $newLine = $newLine + ")" }

        $Enums = ([Microsoft.Playwright.Playwright]).Assembly.DefinedTypes | Where-Object { $_.BaseType.FullName -eq 'System.Enum' }
        foreach($enum in $enums){
            $stringToFind = "$($enum.Name)"
            $newString = "[$($enum.FullName)]"
            foreach($val in [System.Enum]::GetValues($enum)){
                $newLine = $newLine.Replace("$($stringToFind).$($val.ToString())", "$($newString)::$($val.ToString())")
            }
        }
        $output += $newLine
    }
    $output -join [System.Environment]::NewLine
    if($SetClipboard){
        $output -join [System.Environment]::NewLine | Set-Clipboard
    }
}
