<%@ Control Language="C#" AutoEventWireup="true" CodeFile="companyInfoView.ascx.cs" ViewStateMode="Enabled" Inherits="Modules_ROCompanyInfo_companyInfoView" %>

<script>
    $(document).ready(function () {
        $(this).companyProfEDIT({

            
        });
         resizeIframe();
        var tabs = $("#tabs").tabs();
        $("#tbl1").hide();
        $("#ImgPrv").hide();

        //$("#btnadd").on('click', function () {
        //    $("#tbl1").show();
        //    //$("#ctl19_tbl1").Show();
        //    $("#tbl1").attr("display", "block");
        //    //$("#ctl19_tbl1").css('visibility', 'visible');
        //});ImgPrv
        $("#btncancel").on('click', function () {
            $("#tbl1").hide();
            $("#ImgPrv").hide();
        });

    });

    function HideTable(input)
    {
        $("#btncancel").on('click', function () {
            $("#tbl1").hide();
            $("#ImgPrv").hide();
        });
    }

</script>
<script> //$(document).ready(function () { $('#ImgPrv').hide(); });</script>

<script src="//code.jquery.com/jquery-1.11.2.min.js" type="text/javascript"></script>
<script type="text/javascript">
    function ShowImagePreview(input) {
        //$("#ImgPrv").hide();
        

        //$("#ImgPrv").attr("display");
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#<%=ImgPrvs.ClientID%>').prop('src', e.target.result)
                        .width(240)
                        .height(150);
                $("#ImgPrv").show();
            };
            reader.readAsDataURL(input.files[0]);
            $('<%=ImgPrvs.ClientID %>').style.display = 'block';
        }

    }
    //function showpreview(input)
    //{
    //    $("#ImgPrv").show();
    //}
</script>

<style>
    #img {
        width: 250px;
        height: 200px;
        background-position: center center;
        background-size: cover;
        -webkit-box-shadow: 0 0 1px 1px rgba(0, 0, 0, .3);
        display: inline-block;
    }
</style>
<div id="tabs">
    <ul>
        <li><a href="#div1">Company Setup</a>

        </li>
    </ul>
    <div id="div1">
       <%-- <asp:Button ID="btnadd" runat="server" CssClass="sfLocale icon-addnew sfBtn" Text="Add" OnClick="btnadd_Click"></asp:Button>--%>


        <table visible="true" runat="server" id="tbl1">
            <tr>
                <td>Company Name* :</td>
                <td>
                    <asp:TextBox runat="server" ID="txtcompanyName" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>Registration No* :</td>
                <td>
                    <asp:TextBox runat="server" ID="txtregNo" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>Address* :</td>
                <td>
                    <asp:TextBox runat="server" ID="txtadddress" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>Country* :</td>
                <td>
                    <asp:TextBox runat="server" ID="txtcountry" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>Default Currency* :</td>
                <td>
                    <asp:DropDownList runat="server" ID="ddlCurrency" Width="30%" CssClass="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>Logo* :</td>
                <td>

                    <asp:HiddenField ID="imageName" runat="server" />
                    <fieldset style="width: 300px;">

                        <div id="ImgPrv" style="text-align: center;">
                            <asp:Image ID="ImgPrvs" ClientIDMode="Static" Height="150px" Width="240px" runat="server" />
                        </div>
                        <asp:FileUpload ID="fupUploader" runat="server" onchange="ShowImagePreview(this);" />

                    </fieldset>


                    <%-- <asp:FileUpload id="fupUploader" runat="server"/>
                    <asp:Image ID="img" runat="server" />--%>
                    <%--<asp:FileUpload runat="server" ToolTip="Upload Image" accept="image/png, image/jpeg" ID="fupUploader" />--%>
                    <%--<asp:Button ID="btnUpload" runat="server" Text="Upload" OnClick ="btnUpload_Click" />--%>
                    <%--<asp:TextBox runat="server" ID="txtlogo" ClientIDMode="Static" CssClass="required sfInputbox" />--%>
                    <%--  <asp:Panel ID="Panel1" runat="server" Visible="true">
                        <asp:Image ID="Image1" runat="server" />
                        <br />
                        <asp:Button ID="Button1" runat="server" Text="Save" OnClick="Save" />
                        <asp:Button ID="Button2" runat="server" Text="Cancel" OnClick="Cancel" />
                    </asp:Panel>--%>

                    <div id="dvPreview">
                    </div>
                </td>
            </tr>
            <tr>
                <td>Phone No* :</td>
                <td>
                    <asp:TextBox runat="server" ID="txtphoneNo" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>Pan No* :</td>
                <td>
                    <asp:TextBox runat="server" ID="txtpanNo" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <%--<label id="btnsave" class="sfLocale icon-save sfBtn">Save</label>--%>
                    <asp:Button runat="server" ID="btnsave" Text="Save" CssClass="sfLocale icon-save sfBtn" OnClick="btnsave_Click1" />
                    <%--                      <asp:Button runat="server" ID="btnsave" Text="Save" CssClass="sfLocale icon-save sfBtn" OnClick="btnsave_Click" --%>
                    <asp:Button Text="Cancel" ID="btncancel" ClientIDMode="Static" OnClientClick="HideTable(this)" class="sfLocale icon-close sfBtn" runat="server" OnClick="btncancel_Click" />
                    <%--<label id="btncancel" class="sfLocale icon-close sfBtn">Cancel</label>--%>

                </td>
            </tr>
        </table>


    </div>
    <div id="companyTable">
        <asp:GridView ID="gvcompany" runat="server" PagerSettings-Visible="true" DataKeyNames="companyId" AutoGenerateColumns="false" OnRowCommand="gvcompany_RowCommand">
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
                <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Edit">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgEdit" OnClientClick="ShowImagePreview(input)" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="EditUser" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" autoPostback="true" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfEdit" />
                </asp:TemplateField>

              <%--  <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Delete">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgDelete" OnClientClick="return confirm('Are you sure you want to delete this project?'); " runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="DeleteUser" CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfDelete" />
                </asp:TemplateField>
                --%>
                
            </Columns>

        </asp:GridView>
    </div>
</div>

