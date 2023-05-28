using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.IO;
using System.Runtime.InteropServices;

namespace Poshwright
{
    public static class AssemblyResolver
    {
        public static void EnableAssemblyResolver()
        {
            AppDomain.CurrentDomain.AssemblyResolve += new ResolveEventHandler(PoshResolveEventHandler);
            
        }
        private static string pathToCheck = "";
        private static string GetPathToCheck()
        {
            if(string.IsNullOrEmpty(pathToCheck))
            {
                pathToCheck = Path.GetDirectoryName(typeof(AssemblyResolver).Assembly.Location);
            }
            return pathToCheck;
        }
        internal static Assembly PoshResolveEventHandler(object sender, ResolveEventArgs args)
        {
            var directoryToCheck = GetPathToCheck();
            if(string.IsNullOrEmpty(directoryToCheck)){ return null; }

            var dllNeeded = args.Name.Split(',')[0] + ".dll";

            var fullDLLPath = Path.Combine(directoryToCheck, dllNeeded);
            if (File.Exists(fullDLLPath))
            {
                return Assembly.LoadFrom(fullDLLPath);
            }
            return null;
        }
    }
}