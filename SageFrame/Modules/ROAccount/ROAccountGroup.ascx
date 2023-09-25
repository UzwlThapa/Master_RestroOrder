<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROAccountGroup.ascx.cs" Inherits="Modules_ROAccount_ROAccountGroup" %>



<script type="text/javascript">
    $(function () {

        $(this).companyProfEDIT({


        });
    });


</script>
 
<div id="tabs">
    <ul>
        <li><a href="#tab1" > Account Group</a></li>
    </ul>
    <div id="tab">
    <label id="AddAccountGroup" class="sfLocale icon-addnew sfBtn">Add</label>
           <div id="AccountGroupTable">
        <table id="RO-AccountGroup">
            <tr>
                <td>
                     <asp:HiddenField ID="hdfpriceid" runat="server" />
                    <label>Code</label></td>
                <td>
                    <input type="text" Placeholder="Enter Code" ID="txtCode" Class="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>
                    <label>Name</label></td>
                <td>
                    <input type="text" Placeholder="Enter Name" ID="txtName" Class="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>
                    <label>Schedule</label></td>
                <td>
                    <input type="text" Placeholder="Enter Name" ID="txtSchedule" Class="required sfInputbox" /></td>
            </tr>
             <tr>
                <td>
                     
                    <label>Type</label></td>
                <td>
                    <select id="ddlType" name="unit" class="required sfInputbox">
                        <option value="1">1</option>
                        <option value="2">2</option>
                    </select>
                   <%--<input type="text" runat="server" id="txtrestrotable" />--%>
                   <%-- <input type="text" Placeholder="Enter Type" ID="txtType"  Class="required sfInputbox" /></td>--%>
            </tr>
             
          
        </table>
               </div>
         <div id="AccountGroupButton">
            <label id="btnAccountGroupSave" class="sfLocale icon-save sfBtn">Save</label>
            <label id="btnAccountGroupCancel" class="sfLocale icon-close sfBtn">Cancel</label>
        </div></div>
         <div id="accountgroupdata"></div>
    </div>
  