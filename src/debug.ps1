Import-Module "$PSScriptRoot\bin\Playwright.win" -Force
Import-Module "$PSScriptRoot/Playwright" -Force
$ErrorActionPreference = 'Stop'

$Example = @'
using Microsoft.Playwright;
using System;
using System.Threading.Tasks;

class Program
{
    public static async Task Main()
    {
        using var playwright = await Playwright.CreateAsync();
        await using var browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
        {
            Headless = false,
        });
        var context = await browser.NewContextAsync();

        await page.GotoAsync("https://www.google.com/");

        await page.GetByRole(AriaRole.Combobox, new() { Name = "Search" }).ClickAsync();

        await page.GetByRole(AriaRole.Combobox, new() { Name = "Search" }).FillAsync("This is a test");

        await page.GetByRole(AriaRole.Combobox, new() { Name = "Search" }).PressAsync("Enter");

    }
}

'@

$Example | Set-Clipboard

ConvertFrom-PlaywrightClassLibrary -FromClipboard -SetClipboard

<#
$browser = Start-PlaywrightBrowser -Browser 'Chromium' -BrowserChannel 'chrome' -ShowBrowser

$context = Wait-PlaywrightTask ( $browser.NewContextAsync() )

$page = Wait-PlaywrightTask ( $context.NewPageAsync() )

Wait-PlaywrightTask ( $page.GotoAsync("https://www.google.com/") )

$page.GetByRole([Microsoft.Playwright.AriaRole]::Combobox, @{ Name = "Search" }).ClickAsync()

$page.GetByRole([Microsoft.Playwright.AriaRole]::Combobox, @{ Name = "Search" }).FillAsync("This is a test");

#$test = Wait-PlaywrightTask ( $page.PauseAsync() )
#>

