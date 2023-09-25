 

<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROAdjustment.ascx.cs" Inherits="Modules_ROAdjustment_ROAdjustment" %>
<script type="text/javascript">
    $(function () {

        $(this).companyProfEDIT({
            Username: '<%=Username%>'

        });
    });


</script>
<style>
    #AdjustmentTempTable {
        display: none;
    }

    div#AdjustmentAdd .dataTables_wrapper{
        padding: 0;
    }
</style>
<div class="RO_wrapper">
<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Adjustment</a></li>
        <li><a href="#tabs-2">Types</a></li>

    </ul>
    <div id="tabs-1" style="text-align: left">
        <div id="adjustmentTable" style="display: none;">
        <table style="display: block;">
            <tr>
                <td class="hiden">AMNo :</td>
                <td class="hiden">
                    <asp:TextBox ID="txtAMNo" ReadOnly="true" class="sfInputbox required" runat="server" ClientIDMode="Static"></asp:TextBox>
                    <%--<input type="text" id="txtAMNo" class="sfInputbox required" name="AMNO" />--%>
                </td>

                <td>Store :</td>
                <td>
                    <select id="ddlSTId" class="fsUnit required sfInputbox" name="STId" style="width: 200px;">
                    </select>
                </td>


                <td>FY :</td>
                <td>
                    <select id="ddlFYId" class="sfInputbox required" name="FYId" style="width: 100px;">
                        <%--<option value="1">2070/2071</option>
                        <option value="2">2071/2072</option>--%>

                    </select>
                </td>
            </tr>
            <tr>
                <td>Remarks :</td>
                <td colspan="3">
                    <textarea id="txtarearemarks" name="Remarks" class="sfInputbox" style="width: 95%; height: 100px;"></textarea>
                </td>
                <td style="text-align:right;">
                    <input class="sfBtn restro-btn" type="button" id="btnAddItems" value="Add Items" />
                </td>

            </tr>
        </table>

        <hr style="border-color: #FFFFFF;">
        <div id="tblAddItem" class="ui-front">
        <table style="display: block;">
            <tr>
                <td>Item :</td>
                <td>
                    <input type="text" id="ddlItem" class="sfInputbox" name="itid>" />
                    <label id="lblid"></label>
                    <%--<select id="ddlItem" class="sfInputbox required" name="ITId" style="width:200px;">--%>

                    <%--</select>--%>
                </td>
                </tr>


                <tr>
                <td>Quantity :</td>
                <td>
                    <input type="text" class="sfInputbox" id="txtQnty" onkeypress='return isNumber(event)' style="width:100px;"/></td>
                    </tr>

                <tr>
                <td class="unitclass unit" style="display:none;">Unit :</td>
                <td class="unitclass unit" style="display:none;">
                    <%--<select id="ddlUserUnitId" class="sfInputbox" name="UserUnitId" style="width: 200px;">
                    </select>--%>
                    <%--<input type="text" class="sfInputbox" id="ddlUserUnit" style="width:100px;"/>--%>
                    <select id="ddlUserUnit" class="sfInputbox" style="width: 100px;">
                            </select>
                    <input type="hidden" id="ddlUserUnitId"/>

                </td>
            </tr>
            <tr>
                <td>Qty in Text :</td>
                <td>
                    <asp:TextBox ID="txtQntyInText" ReadOnly="true" runat="server" TextMode="MultiLine" ClientIDMode="Static" class="sfInputbox" Style="height: 70px;"></asp:TextBox>
                    <%--<input type="text" name="QntyInText" class="sfInputbox  required" id="txtQntyInText"/>--%>

                </td>
                </tr>

                <tr>
                <td>AdType :</td>
                <td>
                    <%--<input type="number" class="sfInputbox"  name="AdType" id="txtAdType" /></td>--%>
                <select id="txtAdType" name="AdType" class="sfInputbox" style="width:100px;">

                </select>
                </td>
                </tr>

                <tr>
                <td>IsAdd :</td>
                <td>
                    <input type="checkbox" id="chkAdd" /></td>
<%--            </tr>
            <tr>--%>
                <td>
                    <label id="podetailsID"></label>
                </td>
                    
            </tr>

        </table>
            <input type="button" class="sfBtn restro-btn" id="btnadd" value="Add" />
            <input class="sfBtn restro-btn" type="button" id="btnPurchaseClose" value="Close" />
            </div>


<div class="restrowrapper">
        <div id="AdjustmentTempTable" class='sfGridwrapper display' cellspacing='0'>
            <table style="margin-bottom:0px;">

                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th style="display:none;" >Item ID</th>
                        <th>Quantity</th>
                        <th style="display:none;">UnitID</th>
                        <th>Unit</th>
                        <th>Quantity in Text</th>
                        <th>Add Type</th>
                        <th>IsAdd</th>
                         <th style="display:none;">Add TypeID</th>
                        <th class="other tdcenter">Edit</th>
                        <th class="other tdcenter">Delete</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
                <tfoot id="tempFooter">
                    <tr><td colspan="8">Please Add Items.</td></tr>
                </tfoot>

            </table>

        </div>
        </div>

        <input type="button" class="sfLocale icon-save sfBtn" id="btnSave" value="Save" style="margin-left:10px;margin-top:10px;margin-bottom:10px;"/>

        <input type="button" class="sfLocale cancel icon-close sfBtn" id="btnCancel" value="Cancel" style="margin-top:10px;margin-bottom:10px;"/>
        </div>
        <input class="sfLocale icon-Add icon-addnew sfBtn" type="button" id="btnAddAdjustment" value="Add" style="margin-left:10px;margin-top:10px;" /> 
        <div id="AdjustmentAdd" class="restrowrapper"></div>
        <div id="divForAdjustmentView" class="restrowrapper" style="display:none;"></div>
    </div>
    <div id="tabs-2">
    
     <table style="display: block;">
            <tr>
                <td>Type Name :</td>
                <td>
                    <asp:TextBox ID="TxtTypeName"  class="sfInputbox required" ValidationGroup="type" runat="server" ClientIDMode="Static"></asp:TextBox>
                 <%-- <asp:RequiredFieldValidator ErrorMessage="This Field is Required" ControlToValidate="TxtTypeName" runat="server" ValidationGroup="type"/>--%>
                    <%--<input type="text" id="txtAMNo" class="sfInputbox required" name="AMNO" />--%>
                </td>
                </tr>
         <tr>
             <td>Is Active : </td>
             <td>
                 <asp:CheckBox  id="chktype"  ClientIDMode="Static" runat="server" />
             </td>
         </tr>
         <tr>
         <td></td>
             <td>
                 <asp:Button ID="btnTypeSave" Text="Save" ClientIDMode="Static"  Cssclass="sfLocale icon-save sfBtn" runat="server" CausesValidation="false" ValidationGroup="type" />
                 <input type="button" value="Update" class="sfLocale sfBtn" id="edittype" style="display:none" />
             </td>
         </tr>
         </table>
    
         <div id="AdjustmentTypes" class="restrowrapper"></div>
</div>
</div>
</div>
  
 