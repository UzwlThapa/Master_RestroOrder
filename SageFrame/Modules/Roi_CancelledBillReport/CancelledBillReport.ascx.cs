using System;
using SageFrame.Web;

public partial class Modules_Roi_CancelledBillReport_CancelledBillReport : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeCss("CancelledBillReport", "/Modules/Roi_CancelledBillReport/css/cssCancelledBillReport.css");
        IncludeJs("CancelledBillReport", "/Modules/Roi_CancelledBillReport/js/jsCancelledBillReport.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeCss("DataTable", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/buttons.print.min.js");
    }
}