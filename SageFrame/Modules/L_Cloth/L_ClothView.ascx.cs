using SageFrame.Web;
using System;
using System.Web.UI.WebControls;
using SageFrame.Laundry;

public partial class Modules_L_Cloth_L_ClothView : BaseAdministrationUserControl
{
    LaundryController ctl = new LaundryController();
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js", "/Modules/L_LaundryMaster/jsLundry/colorpicker/js/colorpicker.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css", "/Modules/L_LaundryMaster/jsLundry/colorpicker/css/colorpicker.css");
        ddlGender.ClearSelection();

        addForm.Visible = false;
        if (!IsPostBack)
        {
            LoadClothList();

        }
    }

    private void LoadClothList()
    {
        gdvClothList.DataSource = ctl.LoadCloth();
        gdvClothList.DataBind();
        gdvClothList.UseAccessibleHeader = true;

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        AddCloth();
    }

    private void AddCloth()
    {
        try
        {
            L_ClothInfo obj = new L_ClothInfo();

            obj.Cloth = txtCloth.Text;
            obj.Gender = ddlGender.SelectedValue.ToString();

            if (Session["ClothID"] != null && Session["ClothID"].ToString() != string.Empty)
            {
                int MaterialId = Int32.Parse(Session["ClothID"].ToString());
                obj.ID = MaterialId;
                ctl.UpdateCloth(obj);
            }
            else
            {
                ctl.SaveCloth(obj);
            }

            HideForm();
            LoadClothList();
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
        LoadClothList();
        dvAddBtn.Visible = true;
        addForm.Visible = false;
        gdvClothList.Visible = true;
        Session["ClothID"] = string.Empty;
        txtCloth.Text = string.Empty;
        ddlGender.ClearSelection();
    }

    protected void btnAddCloth_Click(object sender, EventArgs e)
    {
        ShowForm();
    }

    private void ShowForm()
    {
        dvAddBtn.Visible = false;
        gdvClothList.Visible = false;
        addForm.Visible = true;
    }

    protected void gdvClothList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            int ClothId = Int32.Parse(e.CommandArgument.ToString());

            switch (e.CommandName.ToString())
            {
                case "cloth_delete":
                    DeleteCloth(ClothId);
                    break;
                case "cloth_edit":
                    EditCloth(ClothId);
                    break;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void EditCloth(int clothId)
    {
        try
        {
            ShowForm();

            L_ClothInfo obj = new L_ClothInfo();
            obj = ctl.GetClothByID(clothId);

            Session["ClothID"] = obj.ID;
            txtCloth.Text = obj.Cloth;
            ddlGender.Items.FindByValue(obj.Gender).Selected = true;
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    private void DeleteCloth(int clothId)
    {
        try
        {
            ctl.DeleteCloth(clothId);
            LoadClothList();
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected void gdvClothList_PreRender(object sender, EventArgs e)
    {
        if (gdvClothList.Rows.Count > 0)
        {
            gdvClothList.UseAccessibleHeader = true;
            gdvClothList.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}