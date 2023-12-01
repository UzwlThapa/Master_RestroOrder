using Hangfire;
using Owin;

using System.Configuration;
using Microsoft.Owin;

/// <summary>
/// Summary description for Startup
/// </summary>


[assembly: OwinStartup(typeof(Startup))]
public partial class Startup
{

    public void Configuration(IAppBuilder app)
    {
        //ConfigureAuth(app);
        string minutes = ConfigurationManager.AppSettings["TimeToSyncBillsInMinutes"].ToString();
        string cronExpression = "*/" + minutes + " * * * *";
        GlobalConfiguration.Configuration.UseSqlServerStorage(ConfigurationManager.ConnectionStrings["SageFrameConnectionString"].ToString());
        GlobalJobFilters.Filters.Add(new AutomaticRetryAttribute { Attempts = 0 });
        app.UseHangfireDashboard();

        app.UseHangfireServer();
        //RecurringJob.AddOrUpdate(() => CBMS.syncSales(), cronExpression);
        //RecurringJob.AddOrUpdate(() => CBMS.syncReturnedSales(), cronExpression);

    }

}
