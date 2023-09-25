using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.RestroOrder;
using SageFrame.Web;
using System.Data;
public partial class Modules_Admin_Category_wucForCategory : BaseUserControl
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
            roiitemtable.Visible = false;
            roiitemtable1.Visible = false;
            //extraitems.Visible = false;
            btnAdd.Visible = true;
            modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
            userModuleID = int.Parse(SageUserModuleID);
            IncludeJs("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.uploadfile.min.js");
            IncludeCss("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.fileupload-ui.css");
            IncludeJs("ROUnit", "/Modules/Admin/Category/ItemScript.js");
            IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
            IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
            IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
            IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");

            BindGrid();
            BindDropdownList3();
            BindItem();

            DataTable dtAdd = new DataTable();
            dtAdd.Columns.AddRange(new DataColumn[]{
            new DataColumn("SN",typeof(Int32)),
            new DataColumn("ExtraItem",typeof(string)),
            new DataColumn("ExtraPrice",typeof(decimal)),

            });


            Session["dtAdd"] = dtAdd;
        }
    }

    protected void saveItem_Click(object sender, EventArgs e)
    {

        try
        {
            ROInvItem info = new ROInvItem();
            RestrOrderController con = new RestrOrderController();
            info.ITId = empid;
            info.ITName = itemName.Text;
            if (HiddenParentItem.Value == "" || HiddenParentItem.Value == "0")
            {
                info.PITId = 0;
                info.ROrderLevel = 1;
            }
            else
            {
                info.PITId = Convert.ToInt32(HiddenParentItem.Value);
                var inv = con.GetInvItemForOrderLevelFromDatabase(info.PITId);
                info.ROrderLevel = inv.Select(q => q.ROrderLevel).FirstOrDefault() + 1;
            }

            info.ITCode = itemCode.Text == "" ? itemName.Text : itemCode.Text;
            info.ImagePath = txtImage.Value;
            if (IsProdMaterial.Checked == true)
                info.IsProdMaterial = true;
            else
                info.IsProdMaterial = false;

            if (isMenu.Checked == true)
                info.IsMenu = true;
            else
                info.IsMenu = false;

            if (chkbxIsActive.Checked == true)
                info.IsActive = true;
            else
                info.IsActive = false;
            info.AddedBy = GetUsername;
            info.IsCategory = true;
            info.ItemCostCentreID = Convert.ToInt32(HiddenFieldCostCentre.Value == "" ? ddCostCentre.Text : HiddenFieldCostCentre.Value);
            itemRate inforate = new itemRate();
            int ItemID = HiddenParentItem.Value == "" ? 0 : Convert.ToInt32(HiddenParentItem.Value);



            if (chkbxIsCake.Checked == true)
                info.IsCake = true;
            else
                info.IsCake = false;

            if (ChkbxIsWholeSale.Checked == true)
                info.IsWholeSale = true;
            else
                info.IsWholeSale = false;

            if (ChckbxIsRetail.Checked == true)
                info.IsRetail = true;
            else
                info.IsRetail = false;

            inforate.PostedBy = GetUsername;
            DataTable dtAdd = new DataTable();
            var ASD = (DataTable)Session["dtAdd"];
            DataTable checking = new DataTable();
            if ((DataTable)Session["dtAdd"] == checking)
            {
                dtAdd = checking;
                ViewState["DataTable"] = dtAdd;
            }
            else
            {
                dtAdd = (DataTable)Session["dtAdd"];
                ViewState["DataTable"] = dtAdd;
            }


            List<extraItem> extradata = new List<extraItem>();

            if (dtAdd.Rows.Count != 0)
            {

                for (int i = 0; i < dtAdd.Rows.Count; i++)
                {
                    extraItem exItem = new extraItem();
                    var arr = dtAdd.Rows[i];
                    exItem.ExtraItem = arr.ItemArray[1].ToString();
                    exItem.ExtraPrice = Convert.ToDecimal(arr.ItemArray[2].ToString());
                    extradata.Add(exItem);
                }

            }
            info.extradata = extradata;
            con.SaveRoiItem(info, inforate);

            Response.Write("<script>alert('Record Saved successfully...', 'Information!!', function () { $.alerts.dialogClass = null;});</script>");
            empid = 0;
            BindGrid();
            BindItem();
            BindDropdownList1();
            itemName.Text = "";
            ddlParentITem.Text = "";
            HiddenParentItem.Value = "";
            itemCode.Text = "";
            txtImage.Value = "";
            isMenu.Checked = true;
            chkbxIsActive.Checked = true;
            ImgPrvs.Attributes["src"] = "";
            roiitemtable.Visible = false;
            roiitemtable1.Visible = false;
            btnAdd.Visible = true;
            gvDatas.Visible = true;
            Response.Redirect(Request.RawUrl);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }
    public void BindDropdownList1()
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
    }

    private void BindGrid()
    {
        List<ROInvItem> info1 = new List<ROInvItem>();
        RestrOrderController con = new RestrOrderController();
        info1 = con.GetRoiItemForCategoryHirerchy();
        gvDatas.DataSource = info1;
        gvDatas.DataBind();
    }
    public void BindDropdownList()
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
    }
    public void BindDropdownList4()
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
    }
    public void BindDropdownList2()
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
    }

    public void BindDropdownList3()
    {
        RestrOrderController roc = new RestrOrderController();
        List<costCenter> currencyList = roc.getcostcenter();
        ddCostCentre.DataSource = currencyList;
        ddCostCentre.DataTextField = "CostCenterName";
        ddCostCentre.DataValueField = "CostCenterID";
        ddCostCentre.DataBind();
    }

    public void BindItem()
    {

        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> currencyList = roc.GetPareintItem();
        ddlParentITem.DataSource = currencyList;
        ddlParentITem.DataTextField = "ITName";
        ddlParentITem.DataValueField = "ITId";
        ddlParentITem.DataBind();
        ddlParentITem.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Root", string.Empty));

    }
    protected void gvDatas_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditUser")
        {
            roiitemtable.Visible = true;
            roiitemtable1.Visible = true;
            btnAdd.Visible = false;
            gvDatas.Visible = false;

            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            empid = Convert.ToInt32(gvDatas.DataKeys[grdrow.RowIndex].Values["ITId"].ToString());
            itemRate info12 = new itemRate();
            RestrOrderController con = new RestrOrderController();
            int itemsrate = con.GetItemRateIdByItemId(empid);
            info12 = con.GetItemRateList().Where(p => p.ItemRateID == itemsrate).FirstOrDefault();
            List<ROInvItem> info1 = new List<ROInvItem>();

            info1 = con.GetRoiItemfromDatabase().Where(p => p.ITId == empid).ToList();
            itemName.Text = info1[0].ITName;
            itemCode.Text = info1[0].ITCode;
            ImgPrvs.Attributes["src"] = "~/Modules/ROI_Item/ImageItem/" + info1[0].ImagePath;
            txtImage.Value = info1[0].ImagePath;
            ddCostCentre.SelectedValue = Convert.ToString(info1[0].ItemCostCentreID);
            if (info1[0].PITId == 0)
            {

                ddlParentITem.Items.Insert(0, "Select");
            }
            else
            {
                if (ddlParentITem.Items.FindByValue(Convert.ToString(info1[0].PITId)) != null)
                    ddlParentITem.SelectedValue = Convert.ToString(info1[0].PITId);
            }
            if (info1[0].IsProdMaterial == true)
            {
                IsProdMaterial.Checked = true;
            }
            else
            {
                IsProdMaterial.Checked = false;
            }

            if (info1[0].IsMenu == true)
            {
                isMenu.Checked = true;
            }
            else
            {
                isMenu.Checked = false;
            }
            if (info1[0].IsActive == true)
            {
                chkbxIsActive.Checked = true;
            }
            else
            {
                chkbxIsActive.Checked = false;
            }
            if (info1[0].IsCake == true)
            {
                chkbxIsCake.Checked = true;
            }
            else
            {
                chkbxIsCake.Checked = false;
            }
            if (info1[0].IsWholeSale == true)
            {
                ChkbxIsWholeSale.Checked = true;
            }
            else
            {
                ChkbxIsWholeSale.Checked = false;
            }

            if (info1[0].IsRetail == true)
            {
                ChckbxIsRetail.Checked = true;
            }
            else
            {
                ChckbxIsRetail.Checked = false;
            }

        }
        else if (e.CommandName == "DeleteUser")
        {
            userName = GetUsername;
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int Itemid = Convert.ToInt32(gvDatas.DataKeys[grdrow.RowIndex].Values["ITId"].ToString());
            RestrOrderController con = new RestrOrderController();
            List<ROInvItem> info2 = new List<ROInvItem>();
            info2 = con.GetRoiItemForCategoryHirerchy().Where(x => x.PITId == Itemid).ToList();
            if (info2.Count > 0)
            {
                Response.Write("<script>alert('This Category cannot be Deleted ...', 'Information!!', function () { $.alerts.dialogClass = null;});</script>");
            }

            else
            {
                con.DeleteROIiTEM(Itemid, userName);
                Response.Write("<script>alert('Record Deleted successfully...', 'Information!!', function () { $.alerts.dialogClass = null;});</script>");
                BindGrid();
            }

        }
    }


    protected void gvDatas_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvDatas.PageIndex = e.NewPageIndex;
        BindGrid();
        DataBindChildren();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        roiitemtable.Visible = true;
        roiitemtable1.Visible = true;
        btnAdd.Visible = false;
        gvDatas.Visible = false;

    }


    protected void gvDatas_RowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.TableSection = TableRowSection.TableHeader;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.TableSection = TableRowSection.TableBody;
        }

        if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.TableSection = TableRowSection.TableFooter;
        }
    }
    protected void btnAddTemp_Click(object sender, EventArgs e)
    {
        try
        {
            DataTable dtAdd = (DataTable)Session["dtAdd"];

            ViewState["DataTable"] = dtAdd;
            DataRow dr = dtAdd.NewRow();
            dtAdd.Rows.Add(dr);
            roiitemtable.Visible = true;
            roiitemtable1.Visible = true;
            btnAdd.Visible = false;
        }
        catch (Exception)
        {

            throw;
        }

    }
    protected void btnCanecle_Click(object sender, EventArgs e)
    {
        roiitemtable.Visible = false;
        roiitemtable1.Visible = false;
        btnAdd.Visible = true;
        itemName.Text = "";
        ddlParentITem.Text = "";
        HiddenParentItem.Value = "";
        itemCode.Text = "";
        txtImage.Value = "";
        ImgPrvs.Attributes["src"] = "";
        empid = 0;
        IsProdMaterial.Checked = false;
        isMenu.Checked = true;
        chkbxIsActive.Checked = true;
        gvDatas.Visible = true;
    }
}