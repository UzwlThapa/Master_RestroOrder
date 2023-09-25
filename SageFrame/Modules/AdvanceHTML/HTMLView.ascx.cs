#region "Copyright"
/*
FOR FURTHER DETAILS ABOUT LICENSING, PLEASE VISIT "LICENSE.txt" INSIDE THE SAGEFRAME FOLDER
*/
#endregion

#region "References"
using System;
using SageFrame.Web;
using SageFrame.HTMLText;
#endregion 

namespace SageFrame.Modules.HTML
{
    public partial class HTMLView : BaseAdministrationUserControl
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                BindContent();
            }
            catch (Exception ex)
            {
                ProcessException(ex);
            }
        }

        private void BindContent()
        {
            try
            {
                HTMLController _html = new HTMLController();
                HTMLContentInfo contentInfo = _html.GetHTMLContent(GetPortalID, Int32.Parse(SageUserModuleID), GetCurrentCultureName);
                if (contentInfo != null)
                {
                    ltrContent.Text = contentInfo.Content.ToString();

                    if (contentInfo.IsActive == true)
                    {
                        divViewWrapper.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ProcessException(ex);
            }
        }
    }
}