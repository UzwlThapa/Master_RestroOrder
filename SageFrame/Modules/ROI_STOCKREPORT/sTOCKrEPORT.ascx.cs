using System;
using SageFrame.Web;

public partial class Modules_ROI_STOCKREPORT_sTOCKrEPORT : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
        IncludeCss("DataTable", "/Modules/DataTable/css/buttons.dataTables.min.css");
        // IncludeCss("DataTable", "/Modules/DataTable/css/dataTables.min.css");


        //IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/jquery-1.12.3.js");
        IncludeJs("RoReport", "/js/jsPDF.js");
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
        IncludeCss("RoReport", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("RoReport", "/Modules/DataTable/css/dataTables.min.css");

        //IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/demo.js");
        IncludeCss("ROI_STOCKREPORT", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");

        IncludeJs("ROI_STOCKREPORT", "/Modules/ROI_STOCKREPORT/Stockjs.js");
       
        
        
       
       
        
        
       

        


        //ExcelXport
        //IncludeJs("DataTable", "/Modules/DataTable/js/jquery.btechco.excelexport.js");
        //IncludeJs("DataTable", "/Modules/DataTable/js/jquery.base64.js");

        
        
        
        
        

        

    }
}