using SageFrame.Web;
using System;
using System.Configuration;

public partial class Modules_CloseDay_CloseDay : BaseUserControl
{
    public string OccupiedTableDayClosedEnable = ConfigurationManager.AppSettings["OccupiedTableDayClosedEnable"].ToString();
    public string DayCloseFixedFloat = ConfigurationManager.AppSettings["DayCloseFixedFloat"] ?? "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeCss("SiteAnalytics", "/Modules/SiteAnalytics/css/jquery.jqplot.css");
        IncludeCss("DashboardSummary", "/Modules/Admin/DashboardSummary/StyleSheet.css");
        IncludeJs("CloseDay", "/Modules/CloseDay/CloseDay.js");
        IncludeJs("", "/js/jquery.alerts.js");
        IncludeCss("", "/css/jquery.alerts.css");
        IncludeJs("SiteAnalytics", "/Modules/Admin/DashboardSummary/js/jquery.jqplot.js");
        IncludeJs("SiteAnalytics", "/Modules/Admin/DashboardSummary/js/jqplot.dateAxisRenderer.js");
        IncludeJs("siteanalytics", "/modules/admin/dashboardsummary/js/jqplot.canvasaxistickrenderer.js");
        IncludeJs("siteanalytics", "/modules/admin/dashboardsummary/js/jqplot.canvastextrenderer.js");
        IncludeJs("siteanalytics", "/modules/admin/dashboardsummary/js/jqplot.logaxisrenderer.js");
        IncludeJs("siteanalytics", "/modules/admin/dashboardsummary/js/jqplot.highlighter.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeJs("", "/js/pincode.js");
    }
}