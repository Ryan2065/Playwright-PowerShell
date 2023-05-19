using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Poshwright
{
    public static class Poshwait
    {
        public static T Wait<T>(Task<T> taskToWait)
        {
            return taskToWait.Result;
        }
        public static void Wait(Task taskToWait)
        {
            taskToWait.GetAwaiter().GetResult();
        }
    }
}