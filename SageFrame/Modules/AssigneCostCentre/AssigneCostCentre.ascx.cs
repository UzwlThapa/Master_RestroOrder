
using SageFrame.CostCenter;
using SageFrame.ExportUser;
using SageFrame.RolesManagement;
using SageFrame.Security;
using SageFrame.Security.Entities;
using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Note2;

public partial class Modules_AssigneCostCentre_AssigneCostCentre : BaseAdministrationUserControl
{
    MembershipController m = new MembershipController();
    RoleController role = new RoleController();
    List<ExportUserInfo> lstUserImportUsers = new List<ExportUserInfo>();
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("ROUnit", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("ROUnit", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        if(!Page.IsPostBack)
        {
  BindUserList();
        BindRolesInListBox(lstAvailableRoles);
        BindCostCenterInListBox(costcentrelist);
        BindGrid();
        //BindAssignedData();
        }
      
    }

    //private void BindAssignedData()
    //{
    //    CostCenterController coc = new CostCenterController();
    //    DataTable gridDatas = coc.GetgridDatatable();

    //}

    private void BindGrid()
    {
        List<CCAssign> info1 = new List<CCAssign>();
        NoteController con = new NoteController();
        //RestrOrderController con = new RestrOrderController();
        info1 = con.GetDataForCCAssign();
        GridView1.DataSource = info1;
        GridView1.DataBind();
    }
    private void BindUserList()
    {
        SageFrameUserCollection lstUser = m.GetAllUsers();
        List<UserInfo> userlist = lstUser.UserList;
        userddlist.DataTextField = "UserName";
        userddlist.DataValueField = "UserID";
        userddlist.DataSource = userlist;
        userddlist.DataBind();
    }

    private void BindCostCenterInListBox(ListBox costcentrelist)
    {
        DataTable dtRoles = GetAllCostCenter();
        costcentrelist.DataSource = dtRoles;
        costcentrelist.DataTextField = "CostCenterName";
        costcentrelist.DataValueField = "CostCenterName";
        costcentrelist.DataBind();
    }

    private DataTable GetAllCostCenter()
    {
        CostCenterController coc = new CostCenterController();
        DataTable costCenter = coc.GetCostCenterDatatable();
        return costCenter;
    }




    private void BindRolesInListBox(ListBox lst)
    {
        DataTable dtRoles = GetAllRoles();
        lst.DataSource = dtRoles;
        lst.DataTextField = "RoleName";
        lst.DataValueField = "RoleName";
        lst.DataBind();
        //lst.Items.RemoveAt(0);
    }
    private DataTable GetAllRoles()
    {
        DataTable dtRole = new DataTable();
        dtRole.Columns.Add("RoleID");
        dtRole.Columns.Add("RoleName");
        dtRole.AcceptChanges();
        RolesManagementController objController = new RolesManagementController();
        List<RolesManagementInfo> objRoles = objController.PortalRoleList(GetPortalID, false, GetUsername);
        foreach (RolesManagementInfo role in objRoles)
        {
            string roleName = role.RoleName;
            if (SystemSetting.SYSTEM_ROLES.Contains(roleName, StringComparer.OrdinalIgnoreCase))
            {
                DataRow dr = dtRole.NewRow();
                dr["RoleID"] = role.RoleId;
                dr["RoleName"] = roleName;
                dtRole.Rows.Add(dr);
            }
            else
            {
                string rolePrefix = GetPortalSEOName + "_";
                roleName = roleName.Replace(rolePrefix, "");
                DataRow dr = dtRole.NewRow();
                dr["RoleID"] = role.RoleId;
                dr["RoleName"] = roleName;
                dtRole.Rows.Add(dr);
            }
        }
        return dtRole;
    }

    public class assignedcc
    {
     
        public string UserName { get; set; }
        public string RoleName { get; set; }
        public string CostCenterName { get; set; }

    }
    protected void ButtonSave_Click(object sender, EventArgs e)
    {
        CostCenterController co = new CostCenterController();
        string userRoles = role.GetRoleNames(userddlist.SelectedItem.Text, GetPortalID);
        string[] arrRoles = userRoles.Split(',');
        var unselectedroles = getunselectedlist(arrRoles);
        var ApplicationName = Membership.ApplicationName;
        Guid userid = new Guid(userddlist.SelectedValue.ToString());
        var UserName = userddlist.SelectedItem.Text;
        var selectedRoleName = GetSelectedRoleNameString();
        var CostCenterName = GetSelectedCostcenterNameString();
        co.SaveAssignedCostCenter(ApplicationName, userid, UserName, unselectedroles, selectedRoleName, CostCenterName, GetPortalID);
        //ShowMessage("SucessfullyUpdated", GetSageMessage("AssignCostCentre", "SucessfullyUpdated"), "", SageMessageType.Success);
        GridView1.DataBind();
        BindGrid();
        ShowMessage("Successfully Updated", "Success", "", SageMessageType.Success);
    }

    private string getunselectedlist(string[] arrRoles)
    {
        List<string> roleList = new List<string>();
        foreach (var item in arrRoles)
        {
            roleList.Add(item);
        }
        return (String.Join(",", roleList.ToArray()));
    }

    private string GetSelectedCostcenterNameString()
    {
        List<string> roleList = new List<string>();
        foreach (ListItem li in costcentrelist.Items)
        {
            if (li.Selected == true)
            {
                roleList.Add(li.Text);
            }
        }

        return (String.Join(",", roleList.ToArray()));
    }
    private string GetSelectedRoleNameString()
    {
        List<string> roleList = new List<string>();
        foreach (ListItem li in lstAvailableRoles.Items)
        {
            if (li.Selected == true)
            {
                roleList.Add(li.Text);
            }
        }

        return (String.Join(",", roleList.ToArray()));
    }
    protected void ChangeUserName(object sender, EventArgs e)
    {

    }
    protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
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
}