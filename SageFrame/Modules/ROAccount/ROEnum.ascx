<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROEnum.ascx.cs" Inherits="Modules_ROAccount_ROEnum" %>

<script type="text/javascript">
    $(function () {

        $(this).companyProfEDIT({


        });
    });


</script>

<div id="tabs">
    <ul>
        <li><a href="#tab1">Account Enum</a></li>
    </ul>
    <div id="tab">
        <label id="AddEnum" class="sfLocale icon-addnew sfBtn">Add</label>
        <div id="EnumTable">
            <table id="RO-Enum">
                <tr>
                    <td>
                        <asp:HiddenField ID="hdfpriceid" runat="server" />
                        <label>C Value</label></td>
                    <td>
                        <asp:TextBox runat="server" Placeholder="Enter CValue" ID="txtCValue" ValidationGroup="tezt" CssClass="required sfInputbox" /></td>
                </tr>
                <tr>
                    <td>

                        <label>Type</label></td>
                    <td>
                        <%--<input type="text" runat="server" id="txtrestrotable" />--%>
                        <asp:TextBox runat="server" Placeholder="Enter Type" ID="txtType" ValidationGroup="tezt" CssClass="required sfInputbox" /></td>
                </tr>
                <tr>
                    <td>
                        <label>Order By</label></td>
                    <td>
                        <asp:TextBox runat="server" Placeholder="Enter Order By" ID="txtOrder" ValidationGroup="tezt" CssClass="required sfInputbox" /></td>
                </tr>
                <tr>
                    <td></td>
                    <td>

                        <asp:Button OnClick="btnsave_Click" OnClientClick="Show_Hide_Display()" runat="server" ID="btnsave" Text="Save" ValidationGroup="tezt" class="sfLocale icon-save sfBtn"></asp:Button>
                        <asp:Button runat="server" OnClick="btncancel_Click" CausesValidation="false" OnClientClick="Show_Hide_Display()" ID="btncancel" CssClass="sfLocale icon-close sfBtn" Text="Cancel"></asp:Button></td>

                </tr>

            </table>
        </div>
        <div id="EnumButton">
            <label id="btnEnumSave" class="sfLocale icon-save sfBtn">Save</label>
            <label id="btnEnumCancel" class="sfLocale icon-close sfBtn">Cancel</label>
        </div>
    </div>
    <div id="enumdata"></div>
</div>
