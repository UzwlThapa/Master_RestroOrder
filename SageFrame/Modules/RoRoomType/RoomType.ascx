<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RoomType.ascx.cs" Inherits="Modules_RoRoomType_RoomType" %>

<script>
    $(document).ready(function () {
        $(this).companyProfEDIT({
        });
        $("#<%=txtTitle.ClientID%>").focusout(function () {
            var values = $('#txtTitle').val();
            $.ajax({
                type: "POST",
                url: "/Modules/RoRoomType/RoRoomTypeWebService.asmx/DoesRoomTypeExist",
                data: JSON.stringify({ roomType: values }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                  //if (msg.d != "")
                  //  {
                      <%--  $("#<%=lblFortxtTitle.ClientID%>").show();--%>
                        $("#<%=lblFortxtTitle.ClientID%>").text(msg.d);
                    //}
                  

            }
        });

    });
    });
</script>
<div class="RO_wrapper">
<div class="restro-title clearfix">
         <input type="button" id="btnRoomTypeAdd" class="sfLocale icon-addnew sfBtn" value="Add">
         </div>
         <table id="tblroom" style="display:none;">
             <tr>
                 <td>
                     Title<span style="color:red">*</span>:
                 </td>
                 <td>
                     <%-- OnTextChanged="txtTitle_TextChanged" AutoPostBack="true"--%>
                    <asp:TextBox ID="txtTitle" runat="server" ClientIDMode="Static"  CssClass="sfInputbox"></asp:TextBox>
                       <asp:Label ID="lblFortxtTitle" runat="server" ForeColor="red" ClientIDMode="Static" ></asp:Label>
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtTitle" ErrorMessage="Room Type is required" Display="dynamic"></asp:RequiredFieldValidator>
                 </td>
             </tr>
             <tr>
                 <td>
                     Description :
                 </td>
                 <td>
                     
                    <asp:TextBox TextMode="MultiLine" ID="txtDescription" runat="server" ClientIDMode="Static" CssClass="sfInputbox" style="width:400px;height:100px;"></asp:TextBox>
                 </td>
                 </tr>
             <tr>
                 <td></td>
                 <td>
                     <label id="btnRoomTypeSave" class="sfLocale icon-save sfBtn restro-btn">Save</label>
                     <label id="btnRoomTypeCancel" class="sfLocale icon-close sfBtn restro-btn">Cancel</label>
                 </td>
                 
             </tr>
                 
         </table>
    <div id="divGrid" class="thbg">
    </div>
    

