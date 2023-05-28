using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Playwright;

namespace Poshwright
{
    public class PoshwrightConverter
    {
        private readonly string _toConvert;
        private StringBuilder _sb;
        public PoshwrightConverter(string toConvert){
            _toConvert = toConvert;
            _sb = new StringBuilder();
        }

        private void ComposeBeginning()
        {
            _sb.AppendLine("$browser = Start-PlaywrightBrowser -Browser 'Chromium' -ShowBrowser");
            _sb.AppendLine("$context = Wait-PlaywrightTask ( $browser.NewContextAsync() )");
            _sb.AppendLine("$page = Wait-PlaywrightTask ( $context.NewPageAsync() )");
        }
    }
}