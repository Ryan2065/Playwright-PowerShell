using System.Threading.Tasks;
using Microsoft.Playwright;

namespace Poshwright
{
    public class Poshwright
    {
        public Poshwright()
        {
            var creat = Playwright.CreateAsync();
            var browserOptions = new BrowserTypeLaunchOptions();
            
        }
        public async Task Test(){
            using var playwright = await Playwright.CreateAsync();
            await using var browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
            {
                Headless = false,
            });
            var context = await browser.NewContextAsync();

            var page = await context.NewPageAsync();

            await page.GotoAsync("https://www.google.com/");

            await page.GetByRole(AriaRole.Combobox, new() { Name = "Search" }).ClickAsync();

            await page.GetByRole(AriaRole.Combobox, new() { Name = "Search" }).FillAsync("This is a test");

            await page.GetByRole(AriaRole.Combobox, new() { Name = "Search" }).PressAsync("Enter");
        }
    }
}