using System;
using System.Web.UI.WebControls;
using SageFrame.Laundry;
using SageFrame.Web;
using System.Text;
using SageFrame.Note2;

public partial class Modules_L_LaundryMaster_L_LaundryMasterView : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

        //IncludeJs("L_LaundryMaster", "/Modules/L_LaundryMaster/jsLundry/jquery.js");
        IncludeJs("L_LaundryMaster", "/Modules/L_LaundryMaster/jsLundry/jsLaundry.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js","/Modules/L_LaundryMaster/jsLundry/colorpicker/js/colorpicker.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css","/Modules/L_LaundryMaster/jsLundry/colorpicker/css/colorpicker.css");
        //LoadLaundry();
        txtDate.Text = DateTime.UtcNow.ToString("yyyy-MM-dd");
        txtDeliveryDate.Text = DateTime.UtcNow.AddDays(3).ToString("yyyy-MM-dd");
        LoadRoom();
        LoadRoomList();
        LoadCloth();
        LoadMaterial();
        //LoadlaundryType();
        LoadHouseKeeper();

    }

    //private void LoadLaundry()
    //{
    //    L_LaundryMasterController ctl = new L_LaundryMasterController();

    //    gdvLaundry.DataSource = ctl.LoadLaundry();
    //    gdvLaundry.DataBind();
    //}

    protected void btnAddLaundry_Click(object sender, EventArgs e)
    {
        ShowForm();
    }

    private void ShowForm()
    {
        divLaundryList.Visible = false;
        //LoadCustomer();
    }

    private void LoadRoom()
    {
        LaundryController ctl = new LaundryController();

        ddlRoomType.DataSource = ctl.GetRoom();
        ddlRoomType.DataTextField = "restroRoom";
        ddlRoomType.DataValueField = "restroRoomId";
        ddlRoomType.DataBind();
        ddlRoomType.Items.Insert(0, new ListItem(" -Select- ", ""));
    }
    private void LoadRoomList()
    {
        LaundryController ctl = new LaundryController();

        ddlroomtypelist.DataSource = ctl.GetRoom();
        ddlroomtypelist.DataTextField = "restroRoom";
        ddlroomtypelist.DataValueField = "restroRoom";
        ddlroomtypelist.DataBind();
        ddlroomtypelist.Items.Insert(0, new ListItem(" ALL ", ""));
    }

    private void LoadMaterial()
    {
        LaundryController ctl = new LaundryController();

        ddlMaterial.DataSource = ctl.LoadMaterialTypeList();
        ddlMaterial.DataTextField = "Type";
        ddlMaterial.DataValueField = "ID";
        ddlMaterial.DataBind();
        ddlMaterial.Items.Insert(0, new ListItem(" -Select- ", ""));
    }

    private void LoadCloth()
    {
        LaundryController ctl = new LaundryController();

        ddlCloth.DataSource = ctl.LoadCloth();
        ddlCloth.DataTextField = "Cloth";
        ddlCloth.DataValueField = "ID";
        ddlCloth.DataBind();
        ddlCloth.Items.Insert(0, new ListItem(" -Select- ", ""));
    }

    private void LoadHouseKeeper()
    {
        NoteController conObj = new NoteController();
        ddlHouseKeeperID.DataSource = conObj.getUserbyLaundryRole();
        ddlHouseKeeperID.DataTextField = "userName";
        ddlHouseKeeperID.DataValueField = "userId";
        ddlHouseKeeperID.DataBind();
        ddlHouseKeeperID.Items.Insert(0, new ListItem(" -Select- ", ""));
    }
   
    protected void btnSave_Click(object sender, EventArgs e)
    {
        AddLaundry();
    }

    private void AddLaundry()
    {
        try
        {
            //L_LaundryMasterController ctl = new L_LaundryMasterController();
            //L_LaundryMasterInfo obj = new L_LaundryMasterInfo();

            //obj.RoomID = Convert.ToInt32(ddlRoom.SelectedValue);
            //obj.CustomerID = Convert.ToInt32(txtCustomerID.Text);
            //obj.Date = Convert.ToDateTime(txtDate.Text);
            //obj.DeliveryDate = Convert.ToDateTime(txtDeliveryDate.Text);
            //obj.ChallanNo = Convert.ToInt32(txtChallanNo.Text);
            //obj.HouseKeeperID = Convert.ToInt32(ddlHouseKeeperID.Text);
            //ctl.AddLaundry(obj);

            //L_LaundryMasterInfo laundry = ctl.ViewAddedLaundry(obj);

           //L_LaundryDetailsController ctlr = new L_LaundryDetailsController();
            //L_LaundryDetailsInfo obj1 = new L_LaundryDetailsInfo();
            //obj1.LaundryMasterID = laundry.ID;
            //obj1.ClothID = Convert.ToInt32(txtClothID.Text);
            //obj1.MaterialID = Convert.ToInt32(txtMaterialID.Text);
            //obj1.Color = txtColor.Text;
            //obj1.Description = txtDescription.Text;
            //obj1.LaundryTypeID = Convert.ToInt32(txtLaundryTypeID.Text);
            //obj1.Quantity = Convert.ToInt32(txtQuantity.Text);
            //ctlr.AddLaundryDetails(obj1);


            StringBuilder sb = new StringBuilder();

            sb.Append("<table ");

            //foreach (HtmlTableRow row in tblForTempLaundry.Rows)
            //{
            //    sb.Append("<tr " + row + "");
            //    L_LaundryDetailsController ctlr = new L_LaundryDetailsController();
            //    L_LaundryDetailsInfo obj1 = new L_LaundryDetailsInfo();
            //    obj1.LaundryMasterID = laundry.ID;
            //    //obj1.ClothID = (Label)row.FindControl("Cells[0]").Text();

            //    //obj1.ClothID = Convert.ToInt32((HtmlInputText)row.Cells[0].Controls[0]);
            //    //obj1.MaterialID = Convert.ToInt32((HtmlInputText)row.Cells[1].Controls[1]);
            //    //obj1.Color = Convert.ToString((HtmlInputText)row.Cells[2].Controls[2]);
            //    //obj1.Description = Convert.ToString((HtmlInputText)row.Cells[3].Controls[3]);
            //    //obj1.LaundryTypeID = Convert.ToInt32((HtmlInputText)row.Cells[4].Controls[4]);
            //    //obj1.Quantity = Convert.ToInt32((HtmlInputText)row.Cells[5].Controls[5]);

              //  ctlr.AddLaundryDetails(obj1);
            //}


            HideForm();
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
        //txtChallanNo.Text = null;
        txtCustomerName.Value = null;
        filterbox.Visible = true;
        divLaundryList.Visible = true;
        //LoadLaundry();

    }

    protected void ddlRoomType_TextChanged(object sender, EventArgs e)
    {
        int RoomTypeID = Convert.ToInt32(ddlRoomType.SelectedValue);
        LaundryController ctl = new LaundryController();
        ddlRoomType.DataSource = ctl.getRoomNoByRoomType(RoomTypeID);
        ddlRoomType.DataTextField = "restrotableTitle";
        ddlRoomType.DataValueField = "restrotableId";
        ddlRoomType.DataBind();
        ddlRoomType.Items.Insert(0, new ListItem(" -Select- ", ""));
    }
}