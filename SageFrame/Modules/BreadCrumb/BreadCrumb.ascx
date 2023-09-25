<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BreadCrumb.ascx.cs" Inherits="Modules_BreadCrumb_BreadCrumb" %>

<script type="text/javascript">
    //<![CDATA[    
    var DefaultPortalHomePage = '<%=DefaultPortalHomePage %>';
    var Extension = '<%=Extension %>';
    $(function() {
        $(this).BreadCrumbBuilder({
            baseURL: BreadCrumPagePath + 'Modules/BreadCrumb/BreadCrumbWebService.asmx/',
            PagePath: BreadCrumPageLink,
            PortalID: '<%=PortalID%>',
            PageName: '<%=PageName%>',
            Container: "div.sfBreadcrumb",
            MenuId: '<%=MenuID%>',
            CultureCode: '<%=CultureCode %>'
        });
    });
    //]]>	
</script>
<div class="sfBreadcrumb clearfix">
    
</div>
<div class="iframeeright">
<input type="button" class="refreshbtn" onclick="refreshIframe();">
<button class="iframeeClose" onclick="closeIframe();"><img src="images/close.png" style="width:10px;height:10px;" alt="Close frame" title="Close Frame"></button>
</div>
