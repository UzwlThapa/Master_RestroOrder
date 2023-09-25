<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FrontPage.ascx.cs" Inherits="FrontPage" %>
<%@ Register Src="~/Modules/RestoLoyalty/RestoLoyaltyView.ascx" TagPrefix="uc1" TagName="RestoLoyaltyView" %>
<%@ Register Src="~/Controls/LoginStatus.ascx" TagName="LoginStatus" TagPrefix="uc2" %>
<script type="text/javascript">
    //<![CDATA[
    $(function () { $(this).FrontPage({ UserModuleID: '<%=userModuleID%>' }); });
    //]]>	
</script>
	<div class="ROInnerWrapper">
	<div class="ROHeader clearfix" style="padding-top: 30px">
	<div class="TopLeft logo">
		<a runat="server" href="~/"><img src="/images/restroorder-white.png" width="130px" alt="logo"></a>
	</div>
	<div class="TopMiddle">
			<ul>
				<li><a href="#">Total Tables <span class="Totalnumbers" id="TotalTables"></span></a></li>
				<li><a href="#" class="OcpTables">Occupied Tables <span class="Totalnumbers" id="OccupiedTables"></span></a></li>
				<li><a href="#">Available Tables <span class="Totalnumbers" id="AvailableTables"></span></a></li>
			</ul>
		</div>
	<div class="TopRight">
		<div class="RODashboard">
			<ul>
				<li><a runat="server" id="hlnkDashboard"><img src="images/dashboard.png"><span>Dashboard</span></a></li>
				<li><a href="#"><img id="logo" src="/Modules/ROCompanyInfo/logo/logo.png"  style="height:65px;display:none;"></a></li>
                
				<li><span>Logged as <span class="user"><%= userName%></span></span></li>
                <li class="logout landing-out"><span class='myProfile icon-arrow-s'></span>
                    <div class="myProfileDrop Off" style="display: none;color:red">
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
<div class="RO_wrapper" style="display:none;">

    </div>