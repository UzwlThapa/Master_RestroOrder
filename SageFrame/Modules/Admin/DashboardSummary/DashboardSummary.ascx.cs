using SageFrame.Web;
using System;

public partial class Modules_Admin_DashboardSummary_DashboardSummary : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
       
       // IncludeCss("siteanalytics", "/Modules/Admin/DashboardSummary/js/jquery-ui.css");
        IncludeCss("SiteAnalytics", "/Modules/SiteAnalytics/css/jquery.jqplot.css");
         IncludeCss("DashboardSummary", "/Modules/Admin/DashboardSummary/StyleSheet.css");
        IncludeJs("DashboardSummery", "/Modules/Admin/DashboardSummary/js/jsDashboardSummary.js");
        IncludeJs("", "/js/jquery.alerts.js");
        IncludeCss("", "/css/jquery.alerts.css");
        //IncludeCss("SiteAnalytics", "/Modules/SiteAnalytics/css/jquery.jqplot.css");
        //IncludeJs("SiteAnalytics", "/Modules/SiteAnalytics/pjs/jquery.jqplot.min.js");
        //IncludeJs("SiteAnalytics", "/Modules/Admin/DashboardSummary/js/jquery.min.js");
        IncludeJs("SiteAnalytics", "/Modules/Admin/DashboardSummary/js/jquery.jqplot.js");
        IncludeJs("SiteAnalytics", "/Modules/Admin/DashboardSummary/js/jqplot.dateAxisRenderer.js");
        //IncludeJs("SiteAnalytics", "/Modules/SiteAnalytics/pjs/jqplot.dateAxisRenderer.min.js");
        IncludeJs("siteanalytics", "/modules/admin/dashboardsummary/js/jqplot.canvasaxistickrenderer.js");
        IncludeJs("siteanalytics", "/modules/admin/dashboardsummary/js/jqplot.canvastextrenderer.js");
        IncludeJs("siteanalytics", "/modules/admin/dashboardsummary/js/jqplot.logaxisrenderer.js");
        IncludeJs("siteanalytics", "/modules/admin/dashboardsummary/js/jqplot.highlighter.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");

        //IncludeCss("SiteAnalytics", "/Modules/SiteAnalytics/css/module.css");
        //IncludeCss("SiteAnalytics", "/Modules/SiteAnalytics/syntaxhighlighter/styles/shCoreDefault.min.css");
        //IncludeCss("SiteAnalytics", "/Modules/SiteAnalytics/syntaxhighlighter/styles/shThemejqPlot.min.css");
        //IncludeJs("SiteAnalytics", "/Modules/SiteAnalytics/pjs/jqplot.barRenderer.min.js");
        //IncludeJs("SiteAnalytics", "/Modules/SiteAnalytics/pjs/jqplot.pieRenderer.min.js");
        //IncludeJs("SiteAnalytics", "/Modules/SiteAnalytics/pjs/jqplot.categoryAxisRenderer.js");
        //IncludeJs("SiteAnalytics", "/Modules/SiteAnalytics/pjs/jqplot.pointLabels.min.js");
        //IncludeJs("SiteAnalytics", "/Modules/SiteAnalytics/pjs/jqplot.meterGaugeRenderer.min.js");
        //IncludeJs("SiteAnalytics", "/Modules/SiteAnalytics/pjs/jqplot.cursor.min.js");
        //Our JS
    }

    //protected void saveItem_Click(object sender, EventArgs e)
    //{
    //        ROInvItem info = new ROInvItem();
    //        RestrOrderController con = new RestrOrderController();
    //        info.ITId = empid;
    //    }


}