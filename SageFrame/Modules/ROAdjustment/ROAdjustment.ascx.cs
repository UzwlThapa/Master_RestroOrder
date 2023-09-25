using System;
using System.Collections.Generic;
using SageFrame.Web;
using SageFrame.RestroOrder;

public partial class Modules_ROAdjustment_ROAdjustment : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string Username = string.Empty;
    RestrOrderController roc = new RestrOrderController();
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("ROAdjustment", "/Modules/ROAdjustment/script/AdjustmentScript.js");
        IncludeJs("ROAdjustment", "/Modules/ROAdjustment/nepali.datepicker.v2.1.min.js");
        IncludeCss("ROAdjustment", "/Modules/ROAdjustment/nepali.datepicker.v2.1.min.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");

        IncludeCss("ROItem", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        IncludeJs("ROItem", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
        ReceiptNo();
    }

    private void ReceiptNo()
    {
        
        List<adjustmentMain> data = roc.getAdjustmentAutoNumber();

        foreach (adjustmentMain item in data)
        {
            txtAMNo.Text = item.AMNo;
        }

    }


    private void reset()
    {
        TxtTypeName.Text = string.Empty;
        chktype.Checked = false;
    }
    //protected void btnTypeSave_Click(object sender, EventArgs e)
    //{
    //    if (TxtTypeName.Text != "" && TxtTypeName.Text != string.Empty)
    //    {
    //        AdjustmentType type = new AdjustmentType();
    //        type.AdjustmentTypeName = TxtTypeName.Text;
    //        type.IsActive = chktype.Checked;
    //        type.AddedBy = GetUsername;
    //        roc.SaveAdjustmentType(type);
    //        reset();
    //    }
    //    //if (TxtTypeName.Text == "" || TxtTypeName.Text == string.Empty)
    //    //{

    //       //}
    //    else
    //    {
    //        Response.Write("<script>jAlert('Empty Record', 'Alert!!', function () { $.alerts.dialogClass = null; });</script>");
    //    }
    //}
}