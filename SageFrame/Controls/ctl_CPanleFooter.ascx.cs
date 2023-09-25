/*
FOR FURTHER DETAILS ABOUT LICENSING, PLEASE VISIT "LICENSE.txt" INSIDE THE SAGEFRAME FOLDER
*/
using System;
using SageFrame.Web;

public partial class Controls_ctl_CPanleFooter : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadHeadContent();
        }
    }

    private void LoadHeadContent()
    {
        try
        {
            SageFrameConfig sfConfig = new SageFrameConfig();
            string strCPanleHeader = sfConfig.GetSettingValueByIndividualKey(SageFrameSettingKeys.PortalCopyright);
            litCPanlePortalCopyright.Text = strCPanleHeader;            
        }
        catch (Exception ex)
        {
            ProcessException(ex);
        }
    }
}