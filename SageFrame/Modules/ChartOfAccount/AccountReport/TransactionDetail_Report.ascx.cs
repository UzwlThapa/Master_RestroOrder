using SageFrame.Web;
using System;

public partial class Modules_ChartOfAccount_AccountReport_TransactionDetail_Report : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("AccountReport", "/Modules/ChartOfAccount/AccountReport/js/TransactionDetail_Report.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeJs("ROI_Item", "/js/jquery.validate.js");

        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.print.min.js");

        //IncludeJs("TrailBalance", "/Modules/ChartOfAccount/TrailBalance/js/jquery.table2excel.js", "/Modules/ChartOfAccount/TrailBalance/js/base64.js", "/Modules/ChartOfAccount/TrailBalance/js/jspdf.js", "/Modules/ChartOfAccount/TrailBalance/js/sprintf.js", "/Modules/ChartOfAccount/TrailBalance/js/tableExport.js", "/Modules/ChartOfAccount/TrailBalance/js/jquery.base64.js", "/js/tableExport.js");
        IncludeJs("TrailBalance", "/Modules/ChartOfAccount/TrailBalance/js/jquery.table2excel.js");

    }
}