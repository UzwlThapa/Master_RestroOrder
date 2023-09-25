<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Issue.ascx.cs" Inherits="Modules_ROIIssue_Issue" %>
<script type="text/javascript">
    $(function () {

        $(this).companyProfEDIT({
            Username: '<%=Username%>',
            Issue: 1
        });
    });


</script>
<div class="RO_wrapper">
        <div class="restro-title clearfix">
         <input class="sfLocale icon-Add icon-addnew sfBtn" type="button" id="btnAddIssue" value="Add" />
        </div>
        <div id="addIssueTable" style="display:none;" >
        <table >
            <tr>
              <%--  <td>Issue No :
                </td>
                <td>
                    <asp:TextBox ClientIDMode="Static" ID="issuNo" ReadOnly="true" CssClass="sfInputbox" runat="server"></asp:TextBox>
                </td>--%>
                <td>Issued From Store :
                </td>
                <td>
                    <asp:DropDownList ClientIDMode="Static" ID="ddlIssuedFrST" CssClass="sfInputbox required" runat="server" Style="width: 150px;"></asp:DropDownList>
                </td>
                 <td>Issued To Store :
                </td>
                <td>
                    <asp:DropDownList ClientIDMode="Static" ID="ddlIssuedToStore" CssClass="sfInputbox required" runat="server" Style="width: 150px;"></asp:DropDownList>
                </td>

                 <td>Recieved By :
                </td>
                <td>
                    <asp:DropDownList ClientIDMode="Static" ID="ddlRecievedBy" name="ddlRecievedBy" CssClass="sfInputbox required" runat="server" Style="width: 150px;"></asp:DropDownList>
                </td>
                <td >
                        <input class="sfLocale icon-Add sfBtn restro-btn" type="button" id="btnAddItems" value="Add Items" />
                </td>
            </tr>


        </table>
            </div>
       
        <div id="tblAddItem" class="ui-front" style="display: none;">
        <table style="display: block;">
            <tr>

                <td>Item :
                </td>
                <td>
                    <input type="text" id="textitem" class="sfInputbox" />
                    <label id="lblItemid"></label>
                    <%-- <asp:DropDownList ClientIDMode="Static" ID="ddlItem" Cssclass="sfInputbox"  runat="server" style="width:200px;"></asp:DropDownList>
              <asp:RequiredFieldValidator runat="server" id="RequiredFieldValidator3" controltovalidate="ddlItem" errormessage="Please enter Item!" Display="dynamic"/>--%>
                </td>
                </tr>
            <tr>
                <td Class="unit">Used Unit :
                </td>
                <td>
                    <%--<asp:DropDownList ID="ddlUnit" ClientIDMode="Static" CssClass="sfInputbox" runat="server" Style="width: 200px;"></asp:DropDownList>--%>
                    <%--<input type="text" id="DdUnitFortextbx" name="quentity" class="sfInputbox" style="width: 100px;"/>--%>

                     <%--<asp:TextBox ID="ddlUnitText" ClientIDMode="Static" CssClass="sfInputbox" runat="server"></asp:TextBox>--%>
                   <%-- <select id="ddlUnitText" class="sfInputbox" style="width: 100px;">
                            </select>--%>
                    <asp:DropDownList ID="ddlUnitText" runat="server" ClientIDMode="Static" CssClass="sfInputbox unit" style="width:100px;"></asp:DropDownList>
                     <asp:HiddenField ID="ddlUnit" ClientIDMode="Static" runat="server"></asp:HiddenField>

                </td>
                </tr>
            <tr>
                <td>Qty :
                </td>
                <td>
                    <asp:TextBox ID="txtqTY" ClientIDMode="Static" CssClass="sfInputbox" runat="server" style="width:100px;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ID="reqName" ControlToValidate="txtqTY" Display="Dynamic" ErrorMessage="Please enter Quentity !" />

                </td>

                <%--<td>Qty In Text :
                </td>
                <td>

                    <asp:TextBox ID="txtQtyInText" TextMode="MultiLine" ClientIDMode="Static" CssClass="sfInputbox" runat="server" Style="height: 70px;"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator1" ControlToValidate="txtQtyInText" ErrorMessage="Please enter Quentity in text !" Display="dynamic" />
                </td>--%>


                </tr>
            </table>
            
                    <%--<input type="button" Value="Add" id="BtnAddIsue" class="btn" />--%>
                    <%--<input type="button" Value="Save" id="BtnSaveIssue" class="btn" />--%>
                    <asp:Button ID="BtnAddIsue" ClientIDMode="Static" OnClientClick="return false" Text="Add" runat="server" class="sfBtn restro-btn" />
                    <input class="sfBtn restro-btn" type="button" id="btnPurchaseClose" value="Close" />
            </div>

        <div id="AddTempTable" class="restrowrapper"  style='display:none;' >
            <table id='IssueTempTable' class='sfGridwrapper display tablee-section' cellspacing='0'>
                <thead>
                    <tr>
                        <th style="display:none;">Item ID</th>
                        <th>Item Name</th>
                        <th style="display:none;">UnitID</th>
                        <th>Unit</th>
                        <th>Quantity</th>
                        <th style="display:none;">Quantity Text</th>
                        <th style="display:none;">conversion</th>
                        <th class="edit-heading tdcenter" style="width:20px;">Edit</th>
                        <th class="delete-heading tdcenter" style="width:20px;">Delete</th>
                    </tr>
                </thead>
                <tbody id="IssueTempBody">
                </tbody>
                <%--<tbody id="IssueTempBody">
                </tbody>--%>

            </table>
        </div>
            <input class="sfLocale icon-save sfBtn" type="button" id="btnIssuSave" value="Save"  style="margin-left:15px;margin-bottom:15px;display:none;" />
        <input class="sfLocale icon-close sfBtn" type="button" id="btnCancelIssue" value="Cancel" style="margin-left:15px;margin-bottom:15px;display:none;"/>
    
      <div class="report-filter">
             <span>Search :</span> <input type="text" class="sfInputbox" id="txtSearch" /></div>
    <div id="issuedata" class="restrowrapper"></div>
<div id="issueDialog"  title="Basic dialog">
    
</div>
</div>
