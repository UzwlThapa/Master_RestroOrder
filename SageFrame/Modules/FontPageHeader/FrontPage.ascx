<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FrontPage.ascx.cs" Inherits="FrontPage" %>
<%@ Register Src="~/Modules/RestoLoyalty/RestoLoyaltyView.ascx" TagPrefix="uc1" TagName="RestoLoyaltyView" %>
<%@ Register Src="~/Controls/LoginStatus.ascx" TagName="LoginStatus" TagPrefix="uc2" %>
<script type="text/javascript">
    //<![CDATA[
    $(function () { $(this).FrontPage({ UserModuleID: '<%=userModuleID%>' }); });
    //]]>	
</script>
<style>
    .TopMiddle li {
        color: white;
    }
</style>
<style>
    .license-expire-wrapper {
        display: flex !important;
        height: 2rem;
        background: #c5b8b1;
        justify-content: center !important;
        align-items: center !important;
        width: 100%;
        font-weight: bold;
        font-size: 12pt;
        color: #e32525;
    }
</style>
<script type="text/javascript">
    //<![CDATA[
    $(document).ready(() => {
        debugger;
        var licenceExpiryDays = parseInt(localStorage.getItem('LicenceExpiryDays') || '0');
        if (licenceExpiryDays <= 10) {
            $('#licenceExpiryWrapper').attr('style', 'visibility:visible !important');
            $('#licenceExpiryDays').html(licenceExpiryDays);
        } else {
            $('#licenceExpiryWrapper').attr('style', 'visibility:hidden !important');
            $('#licenceExpiryDays').html('');
        }
    });
    //]]>	
</script>
<div id="licenceExpiryWrapper" class="license-expire-wrapper" style="visibility: hidden !important">
    Your software license will expire in&nbsp;<span id="licenceExpiryDays"></span>&nbsp;days!
    &nbsp;&nbsp;<span>Please contact Restro Order Support at <b>01-4522345</b> or  <b>(dial 9802068068)</b> to renew your Subscription.</span>
</div>

<div class="ROInnerWrapper">
    <div class="ROHeader clearfix">
        <div class="TopLeft logo">
            <a runat="server">
                <img src="/images/restroorder-white.png" width="130px" alt="logo"></a>
        </div>
        <div class="TopMiddle">
            <ul>
                <li>Today's Sales <span class="Totalnumbers" id="TodaySales"></span></li>
                <li>Outstanding Sales <span class="Totalnumbers" id="OutstandingSales"></span></li>
                <li>Bills Issued<span class="Totalnumbers" id="IssuedBills"></span></li>
                <li>Total Ordered<span class="Totalnumbers" id="OrderedItems"></span></li>
                <li>Total Cancelled<span class="Totalnumbers" id="CanclledItems"></span></li>
            </ul>
        </div>
        <div class="TopRight">
            <div class="RODashboard">
                <ul>
                    <li><a runat="server" id="hlnkDashboard">
                        <img src="images/dashboard.png"><span>Dashboard</span></a></li>
                    <li><a href="#">
                        <img id="logo" src="/Modules/ROCompanyInfo/logo/logo.png" style="height: 65px; display: none;"></a></li>

                    <li><span>Logged as <span class="user"><%= userName%></span></span></li>
                    <li class="logout landing-out"><span class='myProfile icon-arrow-s'></span>
                        <div class="myProfileDrop Off" style="display: none; color: red">
                            <ul>
                                <li>
                                    <%= userName%>
                                </li>
                                <li>
                                    <asp:HyperLink runat="server" ID="lnkAccount" Text="Logged As" CssClass="iframe User-Profile" ForeColor="#ff7828">
                                    <strong>Profile</strong>
                                    </asp:HyperLink>
                                </li>
                                <li>
                                    <uc2:LoginStatus ID="LoginStatus1" runat="server" />
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
<div class="RO_wrapper" style="display: none;">
</div>
