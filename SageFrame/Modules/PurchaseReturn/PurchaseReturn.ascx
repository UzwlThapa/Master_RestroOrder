<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PurchaseReturn.ascx.cs" Inherits="Modules_PurchaseReturn_PurchaseReturn" %>
<script type="text/javascript">
     $(document).ready(function () {
        $(this).companyProfEDIT({});
    });
 
</script>
<div class="RO_wrapper">
<div>
            <input type="hidden" id="hdfVendorId" />
            <input type="hidden" id="hdfIsVat" />
        <table style="display: block;">
            <tr>
                <td>Goods Main No :
                </td>
                <td>
                    <input type="text" id="txtGmNo" class="sfInputbox" />
                </td>
                   <td style="display:none;">
                    <asp:TextBox ID="txtPRNo" ReadOnly="true" ClientIDMode="Static" CssClass="sfInputbox required" runat="server"></asp:TextBox>
                </td>
               <td>
                 <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                   
                </td>
            </tr>

        </table>
     <div class="report-filter">
             <span>Search :</span> <input type="text" class="sfInputbox" id="txtSearch" /></div>
    <div id="PurchaseReturnViewReport" class="restrowrapper" style="display:none;"></div>
<div id="goodsReceiveList" class="restrowrapper" style="display:none;"></div>
 <input class="sfLocale icon-save sfBtn" type="button" id="btnSave" value="Save" style="margin-left:15px;margin-bottom:15px;display:none;"/>
     <input class="sfLocale icon-close sfBtn" type="button" id="btnCancel" value="Cancel" style="margin-left:15px;margin-bottom:15px;display:none;"/>
    <div id="divForViewList" class="restrowrapper"></div>
     
</div>   
        
</div>