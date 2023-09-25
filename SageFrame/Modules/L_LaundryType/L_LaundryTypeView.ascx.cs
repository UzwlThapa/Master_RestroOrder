using SageFrame.Laundry;
using SageFrame.Web;
using System;
using System.Web.UI.WebControls;

public partial class Modules_L_LaundryType_L_LaundryTypeView : BaseAdministrationUserControl
{
    LaundryController ctl = new LaundryController();

    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js", "/Modules/L_LaundryMaster/jsLundry/colorpicker/js/colorpicker.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css", "/Modules/L_LaundryMaster/jsLundry/colorpicker/css/colorpicker.css");

        addForm.Visible = false;

        if (!IsPostBack)
        {
            LoadLaundryTypeList();
        }
    }

    private void LoadLaundryTypeList()
    {
        gdvLaundryTypeList.DataSource = ctl.LoadLaundryTypeList(0);
        gdvLaundryTypeList.DataBind();

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        AddLaundryType();
    }

    private void AddLaundryType()
    {
        try
        {
            L_LaundryTypeInfo obj = new L_LaundryTypeInfo();

            obj.Type = txtLaundryType.Text;

            if (Session["LaundryTypeID"] != null && Session["LaundryTypeID"].ToString() != string.Empty)
            {
                int LaundryId = Int32.Parse(Session["LaundryTypeID"].ToString());
                obj.ID = LaundryId;
                ctl.UpdateLaundryType(obj);
            }
            else
            {
                ctl.SaveLaundryType(obj);
            }

            HideForm();
            LoadLaundryTypeList();
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
        gdvLaundryTypeList.Visible = true;
        Session["LaundryTypeID"] = string.Empty;
        txtLaundryType.Text = string.Empty;
    }

    protected void btnAddLaundryType_Click(object sender, EventArgs e)
    {
        ShowForm();
    }

    private void ShowForm()
    {
        dvAddBtn.Visible = false;
        gdvLaundryTypeList.Visible = false;
        addForm.Visible = true;
    }

    protected void gdvLaundryTypeList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            int LaundryTypeId = Int32.Parse(e.CommandArgument.ToString());

            switch (e.CommandName.ToString())
            {
                case "laundryType_delete":
                    DeleteLaundryType(LaundryTypeId);
                    break;
                case "laundryType_edit":
                    EditLaundryType(LaundryTypeId);
                    break;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void EditLaundryType(int laundryTypeId)
    {
        try
        {
            ShowForm();

            L_LaundryTypeInfo obj = new L_LaundryTypeInfo();
            obj = ctl.GetLaundryTypeByID(laundryTypeId);

            Session["LaundryTypeID"] = obj.ID;
            txtLaundryType.Text = obj.Type;
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    private void DeleteLaundryType(int laundryTypeId)
    {
        try
        {
            ctl.DeleteLaundryType(laundryTypeId);
            LoadLaundryTypeList();
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected void gdvLaundryTypeList_PreRender(object sender, EventArgs e)
    {
        if (gdvLaundryTypeList.Rows.Count > 0)
        {
            gdvLaundryTypeList.UseAccessibleHeader = true;
            gdvLaundryTypeList.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}