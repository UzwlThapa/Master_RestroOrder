#pragma warning disable
using System;
namespace Hangfire {
    [AttributeUsage(AttributeTargets.Method)] public class AutomaticRetryAttribute : Attribute { public int Attempts { get; set; } }
    // Fire-and-forget replacement for Hangfire's in-process queue: jobs run on the thread pool.
    // (Legacy ASMX used Hangfire only for waiter-call notifications; failures must never break a request.)
    public static class BackgroundJob {
        // Ported call sites only enqueue fire-and-forget sync jobs; DiningApp runs them via the hosted scheduler instead.
        public static string Enqueue(Action method) {
            System.Threading.Tasks.Task.Run(() => {
                try { method(); } catch { /* parity with Hangfire: swallow background failures */ }
            });
            return Guid.NewGuid().ToString("N");
        }
        // Supports () => obj.Method(args) expression trees, as used by the ported services.
        public static string Enqueue<T>(System.Linq.Expressions.Expression<Action<T>> method) {
            var call = method.Body as System.Linq.Expressions.MethodCallExpression;
            if (call == null) { var compiled = method.Compile(); return Enqueue(new Action(() => compiled(default))); }
            var target = call.Object != null
                ? System.Linq.Expressions.Expression.Lambda(call.Object).Compile().DynamicInvoke()
                : null;
            var args = new object[call.Arguments.Count];
            for (int i = 0; i < args.Length; i++)
                args[i] = System.Linq.Expressions.Expression.Lambda(call.Arguments[i]).Compile().DynamicInvoke();
            var mi = call.Method;
            // NOTE: wrap in an explicit Action lambda — C# cannot convert Action<T> to Action.
            return Enqueue(new Action(() => mi.Invoke(target, args)));
        }
    }
}
