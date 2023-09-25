<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RestroRoom.ascx.cs" Inherits="Modules_RORoom_RestroRoom" %>

<script>
    $(document).ready(function () {
        $(this).companyProfEDIT({
        });
    });
    
    //function Show_Hide_Display() {
    //    $("#btnsave").on('click', function () {
    //        $("#tbl1").hide();
    //    });
    //}
</script> 
<div class="RO_wrapper">
<div class="restro-title clearfix">
         <input type="button" id="btnadd" class="sfLocale icon-addnew sfBtn" value="Add"></div>
    
        <table id="tbl1" style="display:none;">
            <tr>
                <td>
                    <label>Restro Room<span style='color:red;'>*</span> :</label></td>
                <td>
                  <%--<input type="text" runat="server" Class="sfInputbox" id="txtRoom" Placeholder="Enter Room Name"  />--%>
                    <asp:TextBox runat="server" ClientIDMode="Static" CssClass="sfInputbox" id="txtRoom" ></asp:TextBox>
                     <asp:Label ID="lblFortxtRoom" runat="server" ForeColor="red" ClientIDMode="Static" ></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtRoom" ErrorMessage="Room Name is required" Display="dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>

              <tr>
                <td>
                    <label>Room Type :</label></td>
                <td>
                    <select id="ddlRoomType" class="sfInputbox" style="width:150px;"></select>
                </td>
            </tr>

            <tr>
                 <td></td>
                <td>
                 <label id="btnsave" class="sfLocale icon-save sfBtn restro-btn">Save</label>
                 <label id="btncancel" class="sfLocale icon-close sfBtn restro-btn">Cancel</label></td>

            </tr>


        </table>
    <div id="divGrid" class="thbg"></div>
    </div>
    
