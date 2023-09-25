using System;
using System.Collections.Generic;
using SageFrame.Web;
using SageFrame.RestroOrder;

public partial class Modules_RoReport_SalesReport_wucSalesReportByBillNo : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        fiscalYear();
        IncludeJs("RoReport", "/Modules/RoReport/SalseReport.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeJs("RoReport", "/Modules/RoReport/jspdf.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.print.min.js");
        IncludeCss("RoReport", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("Report", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
    }

    public void fiscalYear()
    {
        RestrOrderController roc = new RestrOrderController();
        List<FiscalYear> fiscal = roc.getTodayFiscalYr();
        lblFiscal.Text= fiscal[0].fyName;
        lblFiscal2.Text = fiscal[0].fyName;
    }
}