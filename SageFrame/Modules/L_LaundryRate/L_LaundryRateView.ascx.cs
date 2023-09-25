using SageFrame.Laundry;
using SageFrame.Web;
using System;
using System.Web.UI.WebControls;

public partial class Modules_L_LaundryRate_L_LaundryRateView : BaseAdministrationUserControl
{

    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js", "/Modules/L_LaundryMaster/jsLundry/colorpicker/js/colorpicker.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css", "/Modules/L_LaundryMaster/jsLundry/colorpicker/css/colorpicker.css");

        
            LoadClothList();

            LoadLaundryTypeList();
        if (!IsPostBack)
        {
            addForm.Visible = false;
            LoadLaundryRateList();
        }
        

    }

    private void LoadLaundryTypeList()
    {
        LaundryController ctl = new LaundryController();

        ddlLaundryType.DataSource = ctl.LoadLaundryType();
        ddlLaundryType.DataTextField = "LaundryType";
        ddlLaundryType.DataValueField = "LaundryTypeID";
        ddlLaundryType.DataBind();
        ddlLaundryType.Items.Insert(0,new ListItem("Select Laundry Type", ""));
    }

    private void LoadClothList()
    {
        LaundryController ctl = new LaundryController();

        ddlCloth.DataSource = ctl.LoadClothList();
        ddlCloth.DataTextField = "ClothType";
        ddlCloth.DataValueField = "ClothTypeID";
        ddlCloth.DataBind();
        ddlCloth.Items.Insert(0,new ListItem("Select Cloth Type", null));
    }

    private void LoadLaundryRateList()
    {
        LaundryController ctl = new LaundryController();

        gdvLaundryRateList.DataSource = ctl.LoadLaundryRateList();
        gdvLaundryRateList.DataBind();

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        AddLaundryRate();
        
    }

    private void AddLaundryRate()
    {
        try
        {
            LaundryController ctl = new LaundryController();

            L_LaundryRateInfo obj = new L_LaundryRateInfo();
            if (hfClothTypeID.Value == "")
            {
                Response.Write("<script>alert('Cloth Type is Needed');</script>");
                ddlLaundryType.Items.FindByValue(hfLaundryTypeID.Value).Selected = true;
            }
            else if (hfLaundryTypeID.Value == "")
            {
                Response.Write("<script>alert('Laundry Type is Needed');</script>");
                ddlCloth.Items.FindByValue(hfClothTypeID.Value).Selected = true;
                ddlLaundryType.Items.FindByValue(hfLaundryTypeID.Value).Selected = true;

            }
            else
            {

                obj.ClothTypeID = Convert.ToInt32(hfClothTypeID.Value);
                obj.LaundryTypeID = Convert.ToInt32(hfLaundryTypeID.Value);
                obj.Rate = Convert.ToDecimal(txtRate.Text);

                if (Session["LaundryRateID"] != null && Session["LaundryRateID"].ToString() != string.Empty)
                {
                    int LaundryId = Int32.Parse(Session["LaundryRateID"].ToString());
                    obj.ID = LaundryId;
                    ctl.UpdateLaundryRate(obj);
                    Response.Write("<script>alert('Item Updated');</script>");
                }
                else
                {
                    foreach (var item in ctl.LoadLaundryRateList())
                    {
                        if (obj.ClothTypeID == item.ClothTypeID && obj.LaundryTypeID == item.LaundryTypeID)
                        {
                            obj.ID = item.ID;
                            Response.Write("<script>alert('Item Updated');</script>");
                            ctl.UpdateLaundryRate(obj);
                            HideForm();
                            LoadLaundryRateList();
                            return;
                        }
                    }
                    ctl.SaveLaundryRate(obj);
                    Response.Write("<script>alert('Item Saved');</script>");
                }

                HideForm();
                LoadLaundryRateList();
            }
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        HideForm();
    }

    private void HideForm()
    {
        dvAddBtn.Visible = true;
        addForm.Visible = false;
        gdvLaundryRateList.Visible = true;
        Session["LaundryRateID"] = string.Empty;
        txtRate.Text = string.Empty;
        ddlLaundryType.SelectedIndex = 0;
        ddlCloth.SelectedIndex = 0;
        LoadLaundryRateList();
    }

    protected void btnAddLaundryRate_Click(object sender, EventArgs e)
    {
        ShowForm();


    }

    private void ShowForm()
    {
        dvAddBtn.Visible = false;
        gdvLaundryRateList.Visible = false;
        addForm.Visible = true;
        hfClothTypeID.Value = "";
        hfLaundryTypeID.Value = "";
    }

    protected void gdvLaundryRateList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            int LaundryRateId = Int32.Parse(e.CommandArgument.ToString());

            switch (e.CommandName.ToString())
            {
                case "laundryRate_delete":
                    DeleteLaundryRate(LaundryRateId);
                    break;
                case "laundryRate_edit":
                    EditLaundryRate(LaundryRateId);
                    break;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void EditLaundryRate(int laundryRateId)
    {
        try
        {
            ShowForm();
            LaundryController ctl = new LaundryController();

            L_LaundryRateInfo obj = new L_LaundryRateInfo();
            obj = ctl.GetLaundryRateByID(laundryRateId);

            Session["LaundryRateID"] = obj.ID;
            ddlCloth.Items.FindByValue(obj.ClothTypeID.ToString()).Selected = true;
            ddlLaundryType.Items.FindByValue(obj.LaundryTypeID.ToString()).Selected = true;
            txtRate.Text = Convert.ToString(obj.Rate);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    private void DeleteLaundryRate(int laundryRateId)
    {
        try
        {
            LaundryController ctl = new LaundryController();

            ctl.DeleteLaundryRate(laundryRateId);
            LoadLaundryRateList();
        }
        catch (Exception e)
        {
            throw e;
        }
    }
    


    protected void gdvLaundryRateList_PreRender(object sender, EventArgs e)
    {
        if (gdvLaundryRateList.Rows.Count > 0)
        {
            gdvLaundryRateList.UseAccessibleHeader = true;
            gdvLaundryRateList.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}