using System;
using System.Web.UI;
using SageFrame.Web;
//using System.Linq;
//using System.Data.DataTable;
public partial class Modules_ROI_Item_Roi_Item : BaseAdministrationUserControl
{

    public static int items = 0;
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public static int empid = 0;
    public string userName = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            //roiitemtable.Visible = false;
           // roiitemtable1.Visible = false;
            //extraitems.Visible = true;
            //btnAdd.Visible = true;
            modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
            userModuleID = int.Parse(SageUserModuleID);
            IncludeJs("ROUnit", "/Modules/ROI_Item/Scripts/ItemScript.js");
            IncludeJs("ROI_Item", "/Modules/ROI_Item/Scripts/FileUpload.js");
            IncludeJs("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.uploadfile.js");
            IncludeJs("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.uploadfile.min.js");
              IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
            //MakeGridViewPrinterFriendly(gvDatas);

            //IncludeCss("ROI_Item", "/Modules/ROI_Item/Scripts/jquery-ui.css");
            //IncludeCss("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.fileupload.css");
            IncludeCss("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.fileupload-ui.css");


            
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");

            //BindGrid();
            //BindDropdownList();
            //BindDropdownList1();
            //BindDropdownList2();
            //BindDropdownList3();
            //BindDropdownList4();
            //BindItem();

            //DataTable dtAdd = new DataTable();
            //dtAdd.Columns.AddRange(new DataColumn[]{
            //new DataColumn("SN",typeof(Int32)),
            //new DataColumn("ExtraItem",typeof(string)),
            //new DataColumn("ExtraPrice",typeof(decimal)),
            
            //});


            //Session["dtAdd"] = dtAdd;
        }
    }

    //protected void saveItem_Click(object sender, EventArgs e)
    //{

    //    try
    //    {
    //        ROInvItem info = new ROInvItem();
    //        RestrOrderController con = new RestrOrderController();
    //        info.ITId = empid;
    //        info.ITName = itemName.Text;
    //        if (HiddenParentItem.Value == "" || HiddenParentItem.Value == "0")
    //        {
    //            info.PITId = 0;
    //            info.ROrderLevel = 1;
    //        }
    //        else
    //        {
    //            info.PITId = Convert.ToInt32(HiddenParentItem.Value);
    //            var inv = con.GetInvItemForOrderLevelFromDatabase(info.PITId);
    //            info.ROrderLevel = inv.Select(q => q.ROrderLevel).FirstOrDefault() + 1;
    //        }

    //        info.ITCode = itemCode.Text;
    //        //if (MunitHideen.Value == "")
    //        //{
    //        //    info.MUnitId = 0;
    //        //}
    //        //else
    //        //{
    //        //    info.MUnitId = Convert.ToInt32(MunitHideen.Value);
    //        //}
    //        //if (hiddenDSUnit.Value == "")
    //        //{
    //        //    info.DSUnitId = 0;
    //        //}
    //        //else
    //        //{
    //        //    info.DSUnitId = Convert.ToInt32(hiddenDSUnit.Value);
    //        //}
    //        //if (HiddenDPUnit.Value == "")
    //        //{
    //        //    info.DPUnitId = 0;
    //        //}
    //        //else
    //        //{
    //        //    info.DPUnitId = Convert.ToInt32(HiddenDPUnit.Value);
    //        //}
    //        //if (txtCompanyLogo.Text == "")
    //        //{
    //        //    List<companyInfo> comp = new List<companyInfo>();
    //        //    comp = con.getcompanyInfo();
    //        //    foreach (companyInfo roomtype in comp)
    //        //    {
    //        //        info.ImagePath = "~/Modules/ROCompanyInfo/logo/" + roomtype.Logo;
    //        //    }
    //        //}
    //        //else
    //        info.ImagePath = txtCompanyLogo.Text;

    //        if (isExpirable.Checked == true)
    //            info.IsExpirable = true;
    //        else
    //            info.IsExpirable = false;

    //        if (IsProdMaterial.Checked == true)
    //            info.IsProdMaterial = true;
    //        else
    //            info.IsProdMaterial = false;

    //        if (IsUnitWiseRate.Checked == true)
    //            info.IsUnitWiseRate = true;
    //        else
    //            info.IsUnitWiseRate = false;
    //        if (isMenu.Checked == true)
    //            info.isMenu = true;
    //        else
    //            info.isMenu = false;
    //        info.IsCategory = false;
    //        info.ItemCostCentreID = Convert.ToInt32(HiddenFieldCostCentre.Value);
    //        // info.CostCentreID = 81;
    //        info.Details = txtDetails.Text;
    //        itemRate inforate = new itemRate();
    //        inforate.ItemRateID = 0;

    //        int ItemID = Convert.ToInt32(HiddenParentItem.Value);

    //        if (ItemID == 0)
    //        {
    //            inforate.ItemID = 0;
    //        }
    //        else
    //        {
    //            inforate.ItemID = Convert.ToInt32(HiddenParentItem.Value);
    //        }
    //        //if (MunitHideen.Value == "")
    //        //{
    //        //    inforate.UnitID = 0;
    //        //}
    //        //else
    //        {
    //            inforate.UnitID = Convert.ToInt32(dditemrate2.Text);
    //        }
    //        //inforate.PRate = Convert.ToDecimal(pritemrate.Text == "" ? "0" : pritemrate.Text);
    //        //inforate.SRate = Convert.ToDecimal(sritemrate.Text == "" ? "0" : sritemrate.Text);
    //        //inforate.PRate = Convert.ToDecimal(pritemrate.Text == "0" ? "-1" : pritemrate.Text);
    //        //inforate.SRate = Convert.ToDecimal(sritemrate.Text == "0" ? "-1" : sritemrate.Text);
    //        //DateTime dates= new DateTime();
    //        //inforate.ValidFrom = Vitemrate.Text == "" ? DateTime.Now: Convert.ToDateTime(Vitemrate.Text);
    //        inforate.PostedBy = GetUsername;
    //        DataTable dtAdd = new DataTable();
    //        var ASD = (DataTable)Session["dtAdd"];
    //        DataTable checking = new DataTable();
    //        if ((DataTable)Session["dtAdd"] == checking)
    //        {
    //            dtAdd = checking;
    //            ViewState["DataTable"] = dtAdd;
    //        }
    //        else
    //        {
    //            dtAdd = (DataTable)Session["dtAdd"];
    //            ViewState["DataTable"] = dtAdd;
    //        }

    //        //extraItem dd = new extraItem();
    //        List<extraItem> extradata = new List<extraItem>();

    //        if (dtAdd.Rows.Count != 0)
    //        {

    //            for (int i = 0; i < dtAdd.Rows.Count; i++)
    //            {
    //                extraItem exItem = new extraItem();
    //                var arr = dtAdd.Rows[i];
    //                exItem.ExtraItem = arr.ItemArray[1].ToString();
    //                exItem.ExtraPrice = Convert.ToDecimal(arr.ItemArray[2].ToString());
    //                extradata.Add(exItem);
    //            }

    //        }
    //        info.extradata = extradata;
    //        con.SaveRoiItem(info, inforate);



    //        //con.SaveRoiItem(info,inforate);
    //        Response.Write("<script>alert('Record Saved successfully...')</script>");
    //        empid = 0;
    //        BindGrid();
    //        BindItem();
    //        BindDropdownList1();
    //        itemName.Text = "";
    //        ddlParentITem.Text = "";
    //        HiddenParentItem.Value = "";
    //        itemCode.Text = "";
    //        txtCompanyLogo.Text = "";
    //        //DropDownList1.Text = "";
    //        //MunitHideen.Value = "";
    //        //DropDownList1.Text = "";
    //        //hiddenDSUnit.Value = "";
    //        //DropDownList1.Text = "";
    //        //HiddenDPUnit.Value = "";
    //        ImgPrvs.ImageUrl = "";
    //        txtDetails.Text = "";
    //        ddCostCentre.Text = "";
    //        //pritemrate.Text = "";
    //        //sritemrate.Text = "";
    //        dditemrate2.Text = "";
    //        //DropDownList2.Text = "";
    //        //DropDownList3.Text = "";
    //        gv_TempTable.DataSource = null;
    //        gv_TempTable.DataBind();

    //        //Session["dtAdd"] = "";
    //        //roiitemtable.Visible = false;
    //        //roiitemtable1.Visible = false;
    //        extraitems.Visible = false;
    //        btnAdd.Visible = true;

    //        Response.Redirect(Request.RawUrl);
    //        //DataTable dtAdd = (DataTable)Session["dtAdd"];
    //        //dtAdd.Clear();
    //    }
    //    catch (Exception)
    //    {

    //        throw;
    //    }
    //}
    //public void BindDropdownList1()
    //{
    //    RestrOrderController roc = new RestrOrderController();
    //    List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
    //    dditemrate2.DataSource = currencyList;
    //    dditemrate2.DataTextField = "Particulars";
    //    dditemrate2.DataValueField = "UnitId";
    //    dditemrate2.DataBind();
    //    dditemrate2.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    //}

    //private void BindGrid()
    //{

    //    List<ROInvItem> info1 = new List<ROInvItem>();
    //    RestrOrderController con = new RestrOrderController();

    //    info1 = con.GetRoiItemfromDatabase();
    //    gvDatas.DataSource = info1;
    //    gvDatas.DataBind();
    //}
    //public void BindDropdownList()
    //{
    //    RestrOrderController roc = new RestrOrderController();
    //    List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
    //    //DropDownList1.DataSource = currencyList;
    //    //DropDownList1.DataTextField = "Particulars";
    //    //DropDownList1.DataValueField = "UnitId";
    //    //DropDownList1.DataBind();
    //    //DropDownList1.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    //}
    //public void BindDropdownList4()
    //{
    //    RestrOrderController roc = new RestrOrderController();
    //    List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
    //    //DropDownList2.DataSource = currencyList;
    //    //DropDownList2.DataTextField = "Particulars";
    //    //DropDownList2.DataValueField = "UnitId";
    //    //DropDownList2.DataBind();
    //    //DropDownList2.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    //}
    //public void BindDropdownList2()
    //{
    //    RestrOrderController roc = new RestrOrderController();
    //    List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
    //    //DropDownList3.DataSource = currencyList;
    //    //DropDownList3.DataTextField = "Particulars";
    //    //DropDownList3.DataValueField = "UnitId";
    //    //DropDownList3.DataBind();
    //    //DropDownList3.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    //}

    //public void BindDropdownList3()
    //{
    //    RestrOrderController roc = new RestrOrderController();
    //    List<costCenter> currencyList = roc.getcostcenter();
    //    ddCostCentre.DataSource = currencyList;
    //    ddCostCentre.DataTextField = "CostCenterName";
    //    ddCostCentre.DataValueField = "CostCenterID";
    //    ddCostCentre.DataBind();
    //    ddCostCentre.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    //}

    //public void BindItem()
    //{

    //    RestrOrderController roc = new RestrOrderController();
    //    List<unitclassforitem> currencyList = roc.GetPareintItem();
    //    ddlParentITem.DataSource = currencyList;
    //    ddlParentITem.DataTextField = "ITName";
    //    ddlParentITem.DataValueField = "ITId";
    //    ddlParentITem.DataBind();
    //    ddlParentITem.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    //}
    //protected void gvDatas_RowCommand(object sender, GridViewCommandEventArgs e)
    //{
    //    if (e.CommandName == "EditUser")
    //    {
    //        //ddlParentITem.Enabled = false;
    //        //roiitemtable.Visible = true;
    //        //roiitemtable1.Visible = true;
    //        extraitems.Visible = true;
    //        btnAdd.Visible = false;

    //        LinkButton btn = (LinkButton)e.CommandSource;
    //        GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
    //        empid = Convert.ToInt32(gvDatas.DataKeys[grdrow.RowIndex].Values["ITId"].ToString());

    //        //items = Convert.ToInt32(gvDatas.DataKeys[grdrow.RowIndex].Values["ItemRateID"].ToString());
    //        itemRate info12 = new itemRate();
    //        //List<itemRate> info1 = new List<itemRate>();
    //        RestrOrderController con = new RestrOrderController();
    //        int itemsrate = con.GetItemRateIdByItemId(empid);
    //        info12 = con.GetItemRateList().Where(p => p.ItemRateID == itemsrate).FirstOrDefault();
    //        //dditemrate1.SelectedValue = Convert.ToString(info1.ItemID);
    //        if (info12.UnitID == 0)
    //        {
    //            BindDropdownList1();
    //        }
    //        else
    //        {
    //            if (dditemrate2.Items.FindByValue(Convert.ToString(info12.UnitID)) != null)
    //                dditemrate2.SelectedValue = Convert.ToString(info12.UnitID);
    //        }
    //        //sritemrate.Text = Convert.ToString(info12.SRate);
    //        //pritemrate.Text = Convert.ToString(info12.PRate);
    //        DateTime dates = Convert.ToDateTime(info12.Validfroms);
    //        //Vitemrate.Text = Convert.ToString(dates.ToShortDateString());
    //        HiddenParentItem.Value = Convert.ToString(info12.ItemRateID);
    //        //MunitHideen.Value = Convert.ToString(info12.UnitID);

    //        List<ROInvItem> info1 = new List<ROInvItem>();

    //        info1 = con.GetRoiItemfromDatabase().Where(p => p.ITId == empid).ToList();
    //        itemName.Text = info1[0].ITName;
    //        //ddlParentITem.SelectedIndex = ddlParentITem.Items.IndexOf(ddlParentITem.Items.FindByValue(info1[0].PITId.ToString()));
    //        //DropDownList1.SelectedIndex = DropDownList1.Items.IndexOf(DropDownList1.Items.FindByText(info1[0].MParticulars));
    //        //ddlCurrency.SelectedValue = Convert.ToString(info1[0].CurrencyID);
    //        itemCode.Text = info1[0].ITCode;
    //        ImgPrvs.ImageUrl = "~/Modules/ROI_Item/ImageItem/" + info1[0].ImagePath;
    //        txtCompanyLogo.Text = info1[0].ImagePath;
    //        ddCostCentre.SelectedValue = Convert.ToString(info1[0].ItemCostCentreID);
    //        HiddenFieldCostCentre.Value = Convert.ToString(info1[0].ItemCostCentreID);
    //        txtDetails.Text = info1[0].Details;
    //        if (info1[0].PITId == 0)
    //        {

    //            ddlParentITem.Items.Insert(0, "Select");
    //        }
    //        else
    //        {
    //            if (ddlParentITem.Items.FindByValue(Convert.ToString(info1[0].PITId)) != null)
    //                ddlParentITem.SelectedValue = Convert.ToString(info1[0].PITId);
    //        }

    //        //if (info1[0].MUnitId == 0)
    //        //{
    //        //    BindDropdownList1();
    //        //}
    //        //else
    //        //{
    //        //    if (DropDownList1.Items.FindByValue(Convert.ToString(info1[0].MUnitId)) != null)
    //        //        DropDownList1.SelectedValue = Convert.ToString(info1[0].MUnitId);
    //        //}
    //        //if (info1[0].DPUnitId == 0)
    //        //{
    //        //    BindDropdownList2();
    //        //}
    //        //else
    //        //{
    //        //    if (DropDownList2.Items.FindByValue(Convert.ToString(info1[0].DPUnitId)) != null)
    //        //        DropDownList2.SelectedValue = Convert.ToString(info1[0].DPUnitId);
    //        //}
    //        //if (info1[0].DSUnitId == 0)
    //        //{
    //        //    BindDropdownList3();
    //        //}
    //        //else
    //        //{
    //        //    if (DropDownList3.Items.FindByValue(Convert.ToString(info1[0].DSUnitId)) != null)
    //        //        DropDownList3.SelectedValue = Convert.ToString(info1[0].DSUnitId);
    //        //}
    //        if (info1[0].IsExpirable == true)
    //        {
    //            isExpirable.Checked = true;
    //        }
    //        else
    //        {
    //            isExpirable.Checked = false;
    //        }

    //        if (info1[0].IsProdMaterial == true)
    //        {
    //            IsProdMaterial.Checked = true;
    //        }
    //        else
    //        {
    //            IsProdMaterial.Checked = false;
    //        }

    //        if (info1[0].IsUnitWiseRate == true)
    //        {
    //            IsUnitWiseRate.Checked = true;
    //        }
    //        else
    //        {
    //            IsUnitWiseRate.Checked = false;
    //        }
    //        if (info1[0].isMenu == true)
    //        {
    //            isMenu.Checked = true;
    //        }
    //        else
    //        {
    //            isMenu.Checked = false;
    //        }


    //        // Response.Write("<script>alert('Record Updated successfully...')</script>");
    //        //HiddenFieldCostCentre.Value = Convert.ToString(info1[0].ItemCostCentreID);
    //        //    ddlCurrency.SelectedValue = Convert.ToString(info1[0].CurrencyID);

    //    }
    //    else if (e.CommandName == "DeleteUser")
    //    {
    //        userName = GetUsername;
    //        LinkButton btn = (LinkButton)e.CommandSource;
    //        GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
    //        int Itemid = Convert.ToInt32(gvDatas.DataKeys[grdrow.RowIndex].Values["ITId"].ToString());
    //        RestrOrderController con = new RestrOrderController();
    //        con.DeleteROIiTEM(Itemid, userName);

    //        //Response.Write("<script>alert('Record deleted secussfully...')</script>");
    //        Response.Write("<script>alert('Record Deleted successfully...')</script>");
    //        BindGrid();


    //    }
    //}


    //protected void gvDatas_PageIndexChanging(object sender, GridViewPageEventArgs e)
    //{
    //    gvDatas.PageIndex = e.NewPageIndex;
    //    BindGrid();
    //    DataBindChildren();
    //}



    ////protected void gvPurchaserOrderlist_PageIndexChanging(object sender, GridViewPageEventArgs e)
    ////{
    ////    gvPurchaserOrderlist.PageIndex = e.NewPageIndex;
    ////    BindGridPurchase();
    ////    DataBindChildren();
    ////}

    ////protected void gvReceipt_PageIndexChanging(object sender, GridViewPageEventArgs e)
    ////{
    ////    gvReceipt.PageIndex = e.NewPageIndex;
    ////    DataBindChildren();
    ////    BindGridPurchase();
    ////}
    //protected void btnAdd_Click(object sender, EventArgs e)
    //{
    //    //roiitemtable.Visible = true;
    //   // roiitemtable1.Visible = true;
    //    btnAdd.Visible = false;
    //    extraitems.Visible = true;
    //}


    //protected void gvDatas_RowCreated(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.Header)
    //    {
    //        e.Row.TableSection = TableRowSection.TableHeader;
    //    }

    //    if (e.Row.RowType == DataControlRowType.DataRow)
    //    {
    //        e.Row.TableSection = TableRowSection.TableBody;
    //    }

    //    if (e.Row.RowType == DataControlRowType.Footer)
    //    {
    //        e.Row.TableSection = TableRowSection.TableFooter;
    //    }
    //}
    //protected void btnAddTemp_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        int row = gv_TempTable.Rows.Count;
    //        DataTable dtAdd = (DataTable)Session["dtAdd"];

    //        ViewState["DataTable"] = dtAdd;
    //        DataRow dr = dtAdd.NewRow();
    //        dr["SN"] = row + 1;
    //        dr["ExtraItem"] = extraItem.Text;
    //        dr["ExtraPrice"] = txtPrice.Text;
    //        dtAdd.Rows.Add(dr);
    //        gv_TempTable.DataSource = dtAdd;
    //        gv_TempTable.DataBind();

    //        extraItem.Text = "";
    //        txtPrice.Text = "";

    //        //roiitemtable.Visible = true;
    //        //roiitemtable1.Visible = true;
    //        btnAdd.Visible = false;
    //        extraitems.Visible = true;

    //    }
    //    catch (Exception)
    //    {

    //        throw;
    //    }

    //}
    //protected void btnCanecle_Click(object sender, EventArgs e)
    //{
    //    //roiitemtable.Visible = false;
    //    //roiitemtable1.Visible = false;
    //    extraitems.Visible = false;
    //    btnAdd.Visible = true;
    //    itemName.Text = "";
    //    ddlParentITem.Text = "";
    //    HiddenParentItem.Value = "";
    //    itemCode.Text = "";
    //    txtCompanyLogo.Text = "";
    //    //DropDownList1.Text = "";
    //    //MunitHideen.Value = "";
    //    //DropDownList1.Text = "";
    //    //hiddenDSUnit.Value = "";
    //    //DropDownList1.Text = "";
    //    //HiddenDPUnit.Value = "";
    //    ImgPrvs.ImageUrl = "";
    //    txtDetails.Text = "";
    //    ddCostCentre.Text = "";
    //    //pritemrate.Text = "";
    //    //sritemrate.Text = "";
    //    dditemrate2.Text = "";
    //    //DropDownList2.Text = "";
    //    //DropDownList3.Text = "";
    //    //Vitemrate.Text = "";
    //    empid = 0;
    //    isExpirable.Checked = false;
    //    IsProdMaterial.Checked = false;
    //    IsUnitWiseRate.Checked = false;
    //}
   
    //protected void btnForNewRow_Click(object sender, EventArgs e)
    //{
    //    //TableRow tRow = new TableRow();
    //    //tableForSubtable.Rows.Add(tRow);
    //}
}
