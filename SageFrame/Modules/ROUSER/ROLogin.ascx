<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROLogin.ascx.cs" Inherits="Modules_ROUSER_ROLogin" %>

<script src="Js/login1.js"></script>
<%--<script type="text/javascript">
    $(function () {

        $(this).companyProfEDIT({


        });
    });


</script>--%>
<div id="tabs">
    <ul>
        <li><a href="#tab">User</a></li>
    </ul>
    <div id="tab">

        
        <div id="UnitTable">
            <table>
                <tr>
                    <td>UserName :
                    </td>
                    <td>
                        <asp:TextBox runat="server"  id="txtUser" class="required"/>
                    </td>
                </tr>
                <tr>
                    <td>Password:
                    </td>
                    <td>
                        <asp:TextBox runat="server" id="txtPass" class="required"/>
                    </td>
                </tr>
            </table>
        </div>
        <div id="UnitButton">
            <asp:Button ID="btnCheckUser" runat="server"  OnClick="btnCheckUser_Click"/>
            <label id="btnUnitSave" class="sfLocale icon-save sfBtn">Save</label>
            <label id="btnUnitCancel" class="sfLocale icon-close sfBtn">Cancel</label>
        </div>
    </div>
    <div id="unitdata"></div>
</div>
