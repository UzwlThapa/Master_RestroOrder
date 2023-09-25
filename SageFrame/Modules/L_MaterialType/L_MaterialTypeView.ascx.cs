using SageFrame.Laundry;
using SageFrame.Web;
using System;
using System.Web.UI.WebControls;

public partial class Modules_L_MaterialType_L_MaterialTypeView : BaseAdministrationUserControl
{
    LaundryController ctl = new LaundryController();

    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js", "/Modules/L_LaundryMaster/jsLundry/colorpicker/js/colorpicker.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css", "/Modules/L_LaundryMaster/jsLundry/colorpicker/css/colorpicker.css");

        addForm.Visible = false;

        if (!IsPostBack)
        {
            LoadMaterialTypeList();
        }
    }

    private void LoadMaterialTypeList()
    {
        gdvMaterialTypeList.DataSource = ctl.LoadMaterialTypeList();
        gdvMaterialTypeList.DataBind();

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        AddMaterialType();
    }

    private void AddMaterialType()
    {
        try
        {
            L_MaterialTypeInfo obj = new L_MaterialTypeInfo();

            obj.Type = txtMaterialType.Text;

            if (Session["MaterialTypeID"] != null && Session["MaterialTypeID"].ToString() != string.Empty)
            {
                int MaterialId = Int32.Parse(Session["MaterialTypeID"].ToString());
                obj.ID = MaterialId;
                ctl.UpdateMaterialType(obj);
            }
            else
            {
                ctl.SaveMaterialType(obj);
            }

            HideForm();
            LoadMaterialTypeList();
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
        gdvMaterialTypeList.Visible = true;
        Session["MaterialTypeID"] = string.Empty;
        txtMaterialType.Text = string.Empty;
        LoadMaterialTypeList();
    }

    protected void btnAddMaterialType_Click(object sender, EventArgs e)
    {
        ShowForm();
    }

    private void ShowForm()
    {
        dvAddBtn.Visible = false;
        gdvMaterialTypeList.Visible = false;
        addForm.Visible = true;
    }

    protected void gdvMaterialTypeList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            int MaterialTypeId = Int32.Parse(e.CommandArgument.ToString());

            switch (e.CommandName.ToString())
            {
                case "materialType_delete":
                    DeleteMaterialType(MaterialTypeId);
                    break;
                case "materialType_edit":
                    EditMaterialType(MaterialTypeId);
                    break;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void EditMaterialType(int materialTypeId)
    {
        try
        {
            ShowForm();

            L_MaterialTypeInfo obj = new L_MaterialTypeInfo();
            obj = ctl.GetMaterialTypeByID(materialTypeId);

            Session["MaterialTypeID"] = obj.ID;
            txtMaterialType.Text = obj.Type;
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    private void DeleteMaterialType(int materialTypeId)
    {
        try
        {
            ctl.DeleteMaterialType(materialTypeId);
            LoadMaterialTypeList();
        }
        catch (Exception e)
        {
            throw e;
        }
    }
    

    protected void gdvMaterialTypeList_PreRender(object sender, EventArgs e)
    {
        if (gdvMaterialTypeList.Rows.Count > 0)
        {
            gdvMaterialTypeList.UseAccessibleHeader = true;
            gdvMaterialTypeList.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}