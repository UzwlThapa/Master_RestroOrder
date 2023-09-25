using System;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.Laundry;

public partial class Modules_L_Condition_L_ConditionEdit : BaseAdministrationUserControl
{
    LaundryController ctl = new LaundryController();
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js", "/Modules/L_LaundryMaster/jsLundry/colorpicker/js/colorpicker.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css", "/Modules/L_LaundryMaster/jsLundry/colorpicker/css/colorpicker.css");

        addForm.Visible = false;
        if (!IsPostBack)
        {
            LoadConditionList();
        }
    }

    private void LoadConditionList()
    {
        gdvConditionList.DataSource = ctl.LoadConditionList();
        gdvConditionList.DataBind();

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        AddCondition();
    }

    private void AddCondition()
    {
        try
        {
            L_ConditionInfo obj = new L_ConditionInfo();

            obj.Condition = txtCondition.Text;

            if (Session["ConditionID"] != null && Session["ConditionID"].ToString() != string.Empty)
            {
                int MaterialId = Int32.Parse(Session["ConditionID"].ToString());
                obj.ID = MaterialId;
                ctl.UpdateCondition(obj);
            }
            else
            {
                ctl.SaveCondition(obj);
            }

            HideForm();
            LoadConditionList();
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
        gdvConditionList.Visible = true;
        Session["ConditionID"] = string.Empty;
        txtCondition.Text = string.Empty;
        LoadConditionList();
    }

    protected void btnAddCondition_Click(object sender, EventArgs e)
    {
        ShowForm();
    }

    private void ShowForm()
    {
        dvAddBtn.Visible = false;
        gdvConditionList.Visible = false;
        addForm.Visible = true;
    }

    protected void gdvConditionList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            int ConditionId = Int32.Parse(e.CommandArgument.ToString());

            switch (e.CommandName.ToString())
            {
                case "condition_delete":
                    DeleteCondition(ConditionId);
                    break;
                case "condition_edit":
                    EditCondition(ConditionId);
                    break;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void EditCondition(int conditionId)
    {
        try
        {
            ShowForm();

            L_ConditionInfo obj = new L_ConditionInfo();
            obj = ctl.GetConditionByID(conditionId);

            Session["ConditionID"] = obj.ID;
            txtCondition.Text = obj.Condition;
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    private void DeleteCondition(int conditionId)
    {
        try
        {
            ctl.DeleteCondition(conditionId);
            LoadConditionList();
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected void gdvConditionList_PreRender(object sender, EventArgs e)
    {
        if (gdvConditionList.Rows.Count > 0)
        {
            gdvConditionList.UseAccessibleHeader = true;
            gdvConditionList.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}