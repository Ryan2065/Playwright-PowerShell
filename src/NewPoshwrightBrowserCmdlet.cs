using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using Microsoft.Playwright;
namespace Playwright
{
    [Cmdlet(VerbsCommon.New, "PlaywrightBrowser")]
    [OutputType(typeof(IBrowser))]
    public class NewPlaywrightBrowserCmdlet : PSCmdlet
    {
        [Parameter(Mandatory = false)]
        public BrowserTypeLaunchOptions LaunchOptions { get; set; }
        [Parameter(Mandatory = true, ParameterSetName = "Chromium")]
        public SwitchParameter Chromium { get; set; }
        [Parameter(Mandatory = true, ParameterSetName = "Firefox")]
        public SwitchParameter Firefox { get; set; }
        [Parameter(Mandatory = true, ParameterSetName = "Webkit")]
        public SwitchParameter Webkit { get; set; }
        protected override void ProcessRecord()
        {
            var playwright = Playwright.CreateAsync().Result;
            var browser = GetBrowser(playwright);
            WriteObject(browser);
        }
        private IBrowser GetBrowser(IPlaywright playwright)
        {
            LaunchOptions ??= new BrowserTypeLaunchOptions();
            if (Webkit.IsPresent)
            {
                return playwright.Webkit.LaunchAsync(LaunchOptions).Result;
            }
            else if (Firefox.IsPresent)
            {
                return playwright.Firefox.LaunchAsync(LaunchOptions).Result;
            }
            return playwright.Chromium.LaunchAsync(LaunchOptions).Result;
        }
    }
}