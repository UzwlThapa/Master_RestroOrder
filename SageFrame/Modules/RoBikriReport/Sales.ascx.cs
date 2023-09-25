using SageFrame.RestroOrder;
using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class Modules_RoBikriReport_sales : BaseAdministrationUserControl
{
    public string CompanyName, PanNo;
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        
        IncludeJs("RoReport", "/Modules/RoReport/SalseReport.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeJs("RoReport", "/Modules/RoReport/jspdf.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.print.min.js");
        IncludeJs("RoReport", "/js/tableExport.js");
        IncludeJs("RoReport", "/js/jquery.base64.js");
        IncludeCss("RoReport", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("RoReport", "/Modules/PurRegister/css/custom.css");
        RestrOrderController rocc = new RestrOrderController();
        List<companyInfo> list = rocc.getcompanyInfo();
        CompanyName = list.FirstOrDefault().Name;
        PanNo = list.FirstOrDefault().PAN;
    }
}