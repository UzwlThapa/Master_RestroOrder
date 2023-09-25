<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LoginStatus.ascx.cs" Inherits="LoginStatus"
    EnableViewState="false" %>
    <div class="sfLogoholder1">
                        <a href="http://restroorder.com/" target="_blank" class="sflogo">
                            <img id="imgLogo" alt="RestroOrder" src="/images/restroorder.png" style="border-width: 0px;">
                        </a>
                    </div>
<asp:LinkButton ID="lnkloginStatus" runat="server" Text="Login" OnClick="lnkloginStatus_Click"
    EnableViewState="false" CssClass="sfBtnlogin sfBtn" title="Login" style="margin-top:20px;"></asp:LinkButton>