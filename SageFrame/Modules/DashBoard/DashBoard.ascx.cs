#region "Copyright"
/*
FOR FURTHER DETAILS ABOUT LICENSING, PLEASE VISIT "LICENSE.txt" INSIDE THE SAGEFRAME FOLDER
*/
#endregion

#region "References"
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.Dashboard;
using SageFrame.Framework;
#endregion

namespace SageFrame.Modules.DashBoard
{
    public partial class DashBoard : BaseAdministrationUserControl
    {
        public string Extension;
        protected void Page_Load(object sender, EventArgs e)
        {
            Extension = SageFrameSettingKeys.PageExtension;

            SageFrameConfig sfConf = new SageFrameConfig();
            string PortalLogoTemplate = sfConf.GetSettingValueByIndividualKey(SageFrameSettingKeys.PortalLogoTemplate);
            if (SageFrameSettingKeys.PortalLogoTemplate.ToString() != string.Empty)
            {
                lblSfInfo.Text = PortalLogoTemplate.ToString();
            }
            if (!Page.IsPostBack)
            {
                DashBoardView();
            }
        }
        protected void imbAdmin_Click(object sender, ImageClickEventArgs e)
        {
        }
        private void DashBoardView()
        {
            try
            {
                string PageSEOName = string.Empty;
                if (Request.QueryString["pgnm"] != null)
                {
                    PageSEOName = Request.QueryString["pgnm"].ToString();
                }
                else
                {
                    PageBase pb = new PageBase();
                    SageUserControl SageUser = new SageUserControl();
                    PageSEOName = pb.GetPageSEOName(SageUser.PagePath);
                }
                DashboardController objController = new DashboardController();
                List<DashboardInfo> lstDashboard = objController.DashBoardView(PageSEOName, GetUsername, GetPortalID);
                lstDashboard.ForEach(
                    delegate(DashboardInfo obj)
                    {
                        if (obj.IconFile != null && obj.IconFile != string.Empty)
                        {
                            string iconFile = string.Empty;
                            iconFile = string.Format("{0}/PageImages/{1}", Request.ApplicationPath == "/" ? "" : Request.ApplicationPath, obj.IconFile);
                            iconFile = "<img align='middle' style='border-width:0px; width:60px; height:60px;' src='" + iconFile + "' class='sfImageheight' id='ctl17_rptDashBoard_ctl17_imgDisplayImage'>";
                            obj.IconFile = iconFile;
                        }
                        else
                        {
                            obj.IconFile = "<i class='icon-" + obj.PageName.Replace(" ", "-").ToLower() + "'></i>";

                        }
                        obj.Url = obj.Url + Extension;
                    }
                    );
                int count = lstDashboard.Count;
                List<DashboardInfo> lstDashboard1 = new List<DashboardInfo>();
                // List<DashboardInfo> lstDashboard2 = new List<DashboardInfo>();
                // List<DashboardInfo> lstDashboard3 = new List<DashboardInfo>();
                // List<DashboardInfo> lstDashboard4 = new List<DashboardInfo>();
                // List<DashboardInfo> lstDashboard5 = new List<DashboardInfo>();
                //foreach(var obj in lstDashboard)
                //{
                //    if (i < 12)
                //    {
                //        lstDashboard1.Add(obj);
                //    }
                //    //else if (i < 2 * count / 3)
                //    else if (i <  20)
                //    {
                //        lstDashboard2.Add(obj);
                //    }

                //    else if (i <  24)
                //    {
                //        lstDashboard3.Add(obj);
                //    }
                //    else 
                //    {
                //        lstDashboard4.Add(obj);
                //    }
                //    i++;
                //}
                lstDashboard1 = lstDashboard;
                // lstDashboard2 = lstDashboard.Where(x => x.DasboardGroup == 2).ToList();
                // lstDashboard3 = lstDashboard.Where(x => x.DasboardGroup == 3).ToList();
                // lstDashboard4 = lstDashboard.Where(x => x.DasboardGroup == 4).ToList();
                // lstDashboard5 = lstDashboard.Where(x => x.DasboardGroup == 5).ToList();
                //for (int i = 0; i < count; i = count/3 )
                //{

                //}


                rptDashBoard1.DataSource = lstDashboard1;
                rptDashBoard1.DataBind();

                // rptDashBoard2.DataSource = lstDashboard2;
                // rptDashBoard2.DataBind();

                // rptDashBoard3.DataSource = lstDashboard3;
                // rptDashBoard3.DataBind();

                //  rptDashBoard4.DataSource = lstDashboard4;
                // rptDashBoard4.DataBind();

                // rptDashBoard5.DataSource = lstDashboard5;
                // rptDashBoard5.DataBind();
            }
            catch (Exception ex)
            {
                ProcessException(ex);
            }
        }

        protected void rptDashBoard_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

        }

        #region SageFrameRoute Members

        #endregion
    }
}
