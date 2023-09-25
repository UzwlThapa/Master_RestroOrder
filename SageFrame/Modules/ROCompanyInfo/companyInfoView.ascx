<%@ Control Language="C#" AutoEventWireup="true" CodeFile="companyInfoView.ascx.cs" ViewStateMode="Enabled" Inherits="Modules_ROCompanyInfo_companyInfoView" %>

<script type="text/javascript">
    $(document).ready(function () {


        //Check Radio  for vat and pan and uncheck Abbreviated value.

        $('.vatpan1').on('click', function () {
            var value = $(this).find('input[type=radio]').val();
            if (value == 'PAN') {
                $('#isAbbreviated').prop("checked", false);
                $('#isAbbreviated').hide();
                $('#isAbbreviated').parents('td').prev('td').hide();
            }
            else if (value == 'VAT') {
                $('#isAbbreviated').prop("checked", false);
                $('#isAbbreviated').show();
                $('#isAbbreviated').parents('td').prev('td').show();
            }
        });


        $('#tabs').tabs();
        resizeIframe();
        var tabs = $("#tabs").tabs();
        $("#tbl1").hide();
        $("#ImgPrv").hide();

        $("#btncancel").on('click', function () {
            $("#tbl1").hide();
            $("#ImgPrv").hide();
        });


        $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: SageFrameHostURL + '/Modules/Admin/LoginControl/LoginWs.asmx/GetCompanyInfo',
            data: {},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                //console.log(data.d);
                window.localStorage.setItem("companyInfo", JSON.stringify(data.d));
            },
            failure: function (response) {
               // jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });

    });

    function HideTable(input) {
        $("#btncancel").on('click', function () {
            $("#tbl1").hide();
            $("#ImgPrv").hide();
        });
    }

    function ShowImagePreview(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#<%=ImgPrvs.ClientID%>').prop('src', e.target.result)
                    .height(90);
                $("#ImgPrv").show();
            };
            reader.readAsDataURL(input.files[0]);
            $('<%=ImgPrvs.ClientID %>').style.display = 'block';
        }



    }
</script>

<style>
    .userlogo {
        position: absolute;
        top: 18px;
        left: 50%;
        transform: translateX(-50%);
        -webkit-transform: translateX(-50%);
        -moz-transform: translateX(-50%);
    }

    .vatpan table {
        margin-bottom: 0px;
    }
</style>
<div class="RO_wrapper">
    <table visible="true" runat="server" id="tbl1">
        <tr>
            <td colspan="4"><span>Note : Company Code will not be changed if the bill has already generated.</span></td>
        </tr>
        <tr>
            <td>Company Name<span class="sfRequired">*</span> :</td>
            <td>
                <asp:TextBox runat="server" ID="txtcompanyName" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            <td>Registration No<span class="sfRequired">*</span> :</td>
            <td>
                <asp:TextBox runat="server" ID="txtregNo" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
        </tr>

        <tr>
            <td>Address<span class="sfRequired">*</span> :</td>
            <td>
                <asp:TextBox runat="server" ID="txtadddress" ClientIDMode="Static" CssClass="required sfInputbox" /></td>

            <td>Code<span class="sfRequired">*</span> :</td>
            <td>
                <asp:TextBox runat="server" ID="txtCode" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
        </tr>
        <tr>
            <td>Country<span class="sfRequired">*</span> :</td>
            <td>
                <asp:TextBox runat="server" ID="txtcountry" ClientIDMode="Static" CssClass="required sfInputbox" /></td>

            <td>Logo<span class="sfRequired">*</span> :</td>
            <td rowspan="3">
                <div class="sfImagewrapper" style="margin: 0;">
                    <div id="dvPreview">
                    </div>
                    <asp:HiddenField ID="imageName" runat="server" />
                    <fieldset>

                        <%-- <div id="ImgPrv">--%>
                        <asp:Image ID="ImgPrvs" ClientIDMode="Static" runat="server" class="userlogo" Style="height: 90px; width: auto;" />
                        <%-- </div>--%>
                        <asp:FileUpload ID="fupUploader" runat="server" onchange="ShowImagePreview(this);" />

                    </fieldset>
                </div>


            </td>
        </tr>
        <tr>
            <td>Default Currency<span class="sfRequired">*</span> :</td>
            <td>
                <asp:DropDownList runat="server" ID="ddlCurrency" Width="150px" CssClass="required sfInputbox" /></td>

        </tr>
        <tr>
            <td>Phone No<span class="sfRequired">*</span> :</td>
            <td>
                <asp:TextBox runat="server" ID="txtphoneNo" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
        </tr>
        <tr>
            <td>VAT / PAN<span class="sfRequired">*</span> :</td>
            <td class="vatpan">
                <asp:RadioButtonList runat="server" ID="rbVatPan">
                    <asp:ListItem Value="VAT" class="vatpan1">VAT</asp:ListItem>
                    <asp:ListItem Value="PAN" class="vatpan1">PAN</asp:ListItem>
                </asp:RadioButtonList>
            </td>

            <td>VAT / Pan No:<span class="sfRequired">*</span> :</td>
            <td>
                <asp:TextBox runat="server" ID="txtpanNo" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
        </tr>
        <tr>
            <td>CBMS UserName :</td>
            <td>
                <asp:TextBox runat="server" ID="txtCBMSUserName" ClientIDMode="Static" CssClass="sfInputbox" /></td>

            <td>CBMS Password :</td>
            <td>
                <asp:TextBox runat="server" ID="txtCBMSPassword" ClientIDMode="Static" CssClass="sfInputbox" /></td>
        </tr>

        <tr>
            <td>Is Abbreviated</td>
            <td>
                <asp:CheckBox ID="isAbbreviated" runat="server" ClientIDMode="Static" CssClass="sfCheckbox" />
            </td>
        </tr>

        <tr>
            <td></td>
            <td>
                <asp:Button runat="server" ID="btnsave" Text="Save" CssClass="sfLocale icon-save sfBtn" OnClick="btnsave_Click1" />
                <asp:Button Text="Cancel" ID="btncancel" ClientIDMode="Static" OnClientClick="HideTable(this)" class="sfLocale icon-close sfBtn" runat="server" OnClick="btncancel_Click" />

            </td>
        </tr>
    </table>

    <div id="companyTable" class="thbg">

        <asp:GridView ID="gvcompany" runat="server" PagerSettings-Visible="true" DataKeyNames="companyId" AutoGenerateColumns="false" OnRowCommand="gvcompany_RowCommand" RowStyle-CssClass="ROGrid" GridLines="None">
            <AlternatingRowStyle BackColor="white" />
            <Columns>
                <asp:TemplateField HeaderText="Id" Visible="false">
                    <ItemTemplate>
                        <%# Eval("companyId") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Company Name">
                    <ItemTemplate>
                        <%# Eval("Name") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Regd No">
                    <ItemTemplate>
                        <%# Eval("RegistrationNo") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Address">
                    <ItemTemplate>
                        <%# Eval("Address") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Code">
                    <ItemTemplate>
                        <%# Eval("Code") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Country">
                    <ItemTemplate>
                        <%# Eval("Country") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Phone No.">
                    <ItemTemplate>
                        <%# Eval("PhoneNo") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Pan No.">
                    <ItemTemplate>
                        <%# Eval("Pan") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Registeren On">
                    <ItemTemplate>
                        <%# (Convert.ToBoolean(Eval("IsPan")) ? "PAN" : "VAT") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Edit">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="EditUser" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" autoPostback="true" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfEdit" />
                </asp:TemplateField>
            </Columns>
            <FooterStyle BackColor="#ff9933" Font-Bold="false" ForeColor="White" />
            <HeaderStyle BackColor="#ff9933" Font-Bold="false" ForeColor="White" />
            <RowStyle BackColor="#f5f5f5" Font-Bold="false" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="false" ForeColor="Navy" />
            <SortedAscendingCellStyle BackColor="#FDF5AC" />
            <SortedAscendingHeaderStyle BackColor="#4D0000" />
            <SortedDescendingCellStyle BackColor="#FCF6C0" />
            <SortedDescendingHeaderStyle BackColor="#820000" />
        </asp:GridView>
    </div>

  <%--  <input type="button" value="Back" class="sfLocale icon-close sfBtn" onclick="window.top.location.reload();">--%>
</div>

