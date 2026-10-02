#pragma warning disable
using System;
namespace Hangfire {
    [AttributeUsage(AttributeTargets.Method)] public class AutomaticRetryAttribute : Attribute { public int Attempts { get; set; } }
}
