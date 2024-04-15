<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Login.ascx.cs" Inherits="SageFrame.Modules.Admin.LoginControl.Login" %>
<%@ Register Src="../../../Controls/LoginStatus.ascx" TagName="LoginStatus" TagPrefix="uc1" %>

<script type="text/javascript">
    //<![CDATA[   
    var elementId = '#<%=UserName.ClientID%>';
    $(function () {
        $(".sfLocale").SystemLocalize();
    });
    $(document).ready(function () {
        window.localStorage.setItem("ordermenulisttype", JSON.stringify(<%= ordermenulisttype%>));
        window.localStorage.setItem("OrdermenuImageshow", JSON.stringify(<%= OrdermenuImageshow%>));
        window.localStorage.setItem("paymentAfterGenerateBill", JSON.stringify(<%= paymentAfterGenerateBill%>));
        window.localStorage.setItem("AddItemInMenuSearch", JSON.stringify(<%= AddItemInMenuSearch%>));
        window.localStorage.setItem("numpin", JSON.stringify(<%= numpin%>));
        window.localStorage.setItem("QRCode", JSON.stringify(<%= QRCode%>));
        window.localStorage.setItem("LicenceExpiryDays", JSON.stringify(<%= LicenceExpiryDays%>));
        window.localStorage.setItem("ShowTotalDiscount", JSON.stringify(<%= ShowTotalDiscount%>));
        $.ajax({
            type: "POST",
            async: true,
            cache: false,
            url: SageFrameHostURL + "/Modules/ROI_Item/RoiItem.asmx/GetInventoryItemList",
            data: "",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                window.localStorage.setItem('ingredientsList', data.d);
            },
            failure: function (response) {
                jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });
        $(this).companyProfEDIT({});
    });
    //]]> 
    function IntegerAndDecimal(evt, element) {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if ((charCode != 8) &&
            (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
            (charCode < 48 || charCode > 57))
            return false;
        return true;
    }
    function isNumber(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }
    $(function () {
        $("#PINbox").focus();
    });
</script>

<asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
    <asp:View ID="View1" runat="server">
        <div class="sfLogin">
            <div class="sfLogininside clearfix">
                <!--  <h2 class="login-title">
                    <asp:Label ID="lblAdminLogin" runat="server" Text="Login" meta:resourcekey="lblAdminLoginResource1"></asp:Label>
                </h2> -->
                <div class="sfCol_restro-left">
                    <h1>Restro Order</h1>
                    <h3>A complete Restaurant Management System</h3>
                    <ul>
                        <li>Tablet ordering system.</li>
                        <li>Central server to handle orders.</li>
                        <li>Order queued instantly to kitchen.</li>
                        <li>Have the functionality of complete inventory and account.</li>
                        <li>Handle orders for both table wise and room wise.</li>
                    </ul>
                </div>
                <div class="sfCol_restro-right">
                    <div class="sfLogoholder1">
                        <a href="http://restroorder.com/" target="_blank" class="sflogo">
                            <img id="imgLogo" alt="RestroOrder" src="/images/restroorder.png" style="border-width: 0px;">
                        </a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                    </div>
                    <div id="PINcode" class="login-pin">
                        <p>Please Enter Your PIN CODE</p>

                        <div class="pin-codeno">

                            <input id='PINbox' type='password' onkeypress='return isNumber(event);' value='' name='PINbox' />

                        </div>
                        <table id="pinpad">
                            <tr>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='1' value='1' /></td>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='2' value='2' /></td>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='3' value='3' /></td>
                            </tr>
                            <tr>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='4' value='4' /></td>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='5' value='5' /></td>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='6' value='6' /></td>
                            </tr>
                            <tr>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='7' value='7' /></td>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='8' value='8' /></td>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='9' value='9' /></td>
                            </tr>
                            <tr>
                                <td>
                                    <input type='button' class='sfBtn clearpin' value='C' /></td>
                                <td>
                                    <input type='button' class='PINbutton sfBtn' name='0' value='0' /></td>
                                <td>
                                    <input type='button' class='sfBtn del' value='D' />
                            </tr>
                        </table>
                    </div>

                    <p class="login-userr" style="display: none">
                        <asp:TextBox ID="UserName" placeholder="Username" runat="server" meta:resourcekey="UserNameResource1" autofocus="autofocus"
                            CssClass="login-button" ClientIDMode="Static"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                            ErrorMessage="Username is required." ToolTip="Username is required." ValidationGroup="Login1"
                            CssClass="sfErrorA" meta:resourcekey="UserNameRequiredResource1" InitialValue=""
                            Text="*"></asp:RequiredFieldValidator>
                    </p>
                    <p class="login-pass" style="display: none">
                        <asp:TextBox ID="Password" placeholder="Password" runat="server" TextMode="Password"
                            meta:resourcekey="PasswordResource1" CssClass="login-button" ClientIDMode="Static"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                            ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Login1"
                            CssClass="sfErrorA" meta:resourcekey="PasswordRequiredResource1" Text="*"></asp:RequiredFieldValidator>
                    </p>
                    <p>
                        <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="sfCheckBox" meta:resourcekey="RememberMeResource1" />
                        <asp:Label ID="lblrmnt" runat="server" Text="Remember me." CssClass="sfFormlabel"
                            meta:resourcekey="lblrmntResource1"></asp:Label>
                    </p>
                    <div id="dvCaptchaField" runat="server" style="clear: both;">
                        <p>
                            <asp:Image ID="CaptchaImage" runat="server" CssClass="sfCaptcha" meta:resourcekey="CaptchaImageResource1" />
                            <span id="captchaValidator" runat="server" class="sfError">*</span>
                            <asp:ImageButton ID="Refresh" CssClass="sfCaptchadata" runat="server" ValidationGroup="Sep"
                                OnClick="Refresh_Click" meta:resourcekey="RefreshResource1" />
                        </p>
                        <p>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <p class="sfCaptcha">
                                        <asp:TextBox placeholder="Enter captcha text" ID="CaptchaValue" runat="server" CssClass="sfInputbox" meta:resourcekey="CaptchaValueResource1"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvCaptchaValueValidator" runat="server" ControlToValidate="CaptchaValue"
                                            Display="Dynamic" ErrorMessage="*" ValidationGroup="Login1" CssClass="sfErrorA"
                                            meta:resourcekey="rfvCaptchaValueValidatorResource1"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="cvCaptchaValue" runat="server" Display="Dynamic" ErrorMessage="*"
                                            ControlToValidate="CaptchaValue" ValueToCompare="121" CssClass="sfError" meta:resourcekey="cvCaptchaValueResource1"></asp:CompareValidator>
                                    </p>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                            <p>
                            </p>

                            <p>
                            </p>

                            <p>
                            </p>

                            <p>
                            </p>

                            <p>
                            </p>

                            <p>
                            </p>

                            <p>
                            </p>

                            <p>
                            </p>

                            <p>
                            </p>

                            <p>
                            </p>

                            <p>
                            </p>

                        </p>
                    </div>
                    <p style="float: right; width: 100%; display: none;" class="forget-pass">
                        <span class="cssClassForgotPass">
                            <asp:HyperLink ID="hypForgotPassword" runat="server" meta:resourcekey="hypForgotPasswordResource1"
                                Text="Forgot Password?"></asp:HyperLink>
                        </span>
                    </p>
                    <p style="float: right; width: 100%; display: none;" class="cssClassPin">
                        <span>
                            <asp:HyperLink ID="HyperLink1" runat="server" meta:resourcekey="hypPinResource1"
                                Text="Sign-in Option" ClientIDMode="Static"></asp:HyperLink>
                            <asp:HiddenField ID="HiddenField1" runat="server" ClientIDMode="Static" />
                        </span>
                    </p>

                    <p style="float: right; width: 100%;" class="cssClasstext">
                        <span>
                            <asp:HyperLink ID="HyperLink2" runat="server" meta:resourcekey="hypPinResource2"
                                Text="Sign-in Option" ClientIDMode="Static"></asp:HyperLink>
                            <asp:HiddenField ID="HiddenField2" runat="server" ClientIDMode="Static" />
                        </span>
                    </p>

                    <div class="sfButtonwrapper" style="float: left; display: none;">
                        <span><span>
                            <asp:Button ID="LoginButton" runat="server" CommandName="Login" CssClass="sfBtn"
                                meta:resourcekey="LoginButtonResource1" OnClick="LoginButton_Click" Text="Sign In"
                                ValidationGroup="Login1" ClientIDMode="Static" />
                        </span></span>
                    </div>
                    <p style="clear: both;">
                        <asp:Literal ID="FailureText" runat="server" EnableViewState="False" meta:resourcekey="FailureTextResource1"></asp:Literal>
                    </p>
                </div>
            </div>
        </div>
        <div class="OpenID" align="center" runat="server" id="divOpenIDProvider">
            <h3 class="sfLocale">Login with any of these OpenID providers:
            </h3>
            <asp:ImageButton runat="server" ID="imgBtnFacebook" ImageUrl="images/Login_with_Facebook.png"
                OnClick="imgBtnFacebook_Click" meta:resourcekey="imgBtnFacebookResource1" />
            <asp:ImageButton runat="server" ID="imgBtnGoogle" ImageUrl="images/Login_with_Google.png"
                OnCommand="OpenLogin_Click" CommandArgument="https://www.google.com/accounts/o8/id"
                CssClass="sfGoogle" meta:resourcekey="imgBtnGoogleResource1" />
            <asp:ImageButton runat="server" ID="imgBtnYahoo" ImageUrl="images/Login_with_Yahoo.png"
                OnCommand="OpenLogin_Click" CommandArgument="https://me.yahoo.com" meta:resourcekey="imgBtnYahooResource1" />
            <asp:ImageButton runat="server" ID="imgBtnLinkedIn" ImageUrl="images/Login_with_LinkedIn.png"
                OnClick="imgBtnLinkedIn_Click" meta:resourcekey="imgBtnLinkedInResource1" />
            <asp:Label ID="lblAlertMsg" runat="server" Text="Login" Visible="False" meta:resourcekey="lblAlertMsgResource1"></asp:Label>
            <span class="sfOr sfLocale">or</span>
        </div>
    </asp:View>
    <asp:View ID="View2" runat="server">
        <uc1:LoginStatus ID="LoginStatus1" runat="server" />
    </asp:View>
</asp:MultiView>
<div class="powered-by">
    <a href="http://danfesolution.com/" target="_blank">
        <img src="/Modules/Logo/image/danfe-logo.png" width="150px"></a>
</div>