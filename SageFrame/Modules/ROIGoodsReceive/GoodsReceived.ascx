<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GoodsReceived.ascx.cs" Inherits="Modules_ROIGoodsReceive_GoodsReceived" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            Username: '<%=Username%>'
        });
    });

    $(document).ready(function () {
        jQuery("#txtDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
            
        });
        $("#txtDate").datepicker("setDate", new Date());

    });
</script>
<div class="RO_wrapper">
            <input type="hidden" id="hdfVendorId" />
            <input type="hidden" id="hdfIsVat" />
        <table style="display: block;">
            <tr>
                <td>Purchase No:
                </td>
                <td>
                    <input type="text" id="txtPoNO" class="sfInputbox" />
                </td>
                <td style="display:none;">Goods Main No :
                </td>
                <td style="display:none;">
                    <asp:TextBox ID="txtGmNo" ReadOnly="true" ClientIDMode="Static" CssClass="sfInputbox required" runat="server"></asp:TextBox>
                    <%--<input type="text" id="txtGmNo" class="sfInputbox required" name="GmNo" />--%>
                </td>
                  <td>Invoice No:
                </td>
                 <td>
                    <input type="text" id="txtInvoiceno" name="txtInvoiceno" class="sfInputbox" />
                </td> 
                      
                  <td>Invoice Date:
                </td>
                 <td>
                    <input type="text" id="txtDate" class="sfInputbox" />
                </td>
                
               
           
                <td>Store :
                </td>
                <td>
                    <select id="ddlStore" class="sfInputbox Store" style="width: 150px"></select>
                </td>
                    <%--   <td>IsVAT:
                    </td>
                          <td>
                        <input type="checkbox" id="chkISVAT" />
                    </td>--%>
            </tr>
        </table>
        <%--<div id="AddTempTable" style="padding:0">
                <table id='purchaseTempTable' class='sfGridwrapper display tablee-section' cellspacing='0'>
                    <thead>
                    <tr>
                    <th >Item</th><th style="display:none">PurchaseDetailID</th>  <th>Qty</th> <th style="display:none">ItemID</th> <th>Expireable</th> <th>Edit</th><th>Delete</th>
                    </tr>
                   </thead>
                   <tbody>
                   </tbody>
                  </table>
              </div>--%>
              <div>
       <div class="report-filter">
             <span>Search :</span> <input type="text" class="sfInputbox" id="txtSearch" /></div>
<div id="goodsReceiveList" class="restrowrapper"></div>
     <div id="divForViewList" class="restrowrapper"></div>
     <div id="divForView"></div>
<input class="sfLocale icon-save sfBtn" type="button" id="btnPurchaseSave" value="Save"/>
<input class="sfLocale icon-close sfBtn" type="button" id="btnPurchaseCancel" value="Cancel"/>
</div>
<div id="membeshipformlist2"></div>
 <div id="VendorBox" class="restrowrapper"></div>
<div id="payOption" style="display: none;">
    <label>Select Pay Option:</label>
    <input type="radio" id="rdoPayOptionCash" name="PayOption" value="1" checked style="margin-right: 10px;" /><label for="rdoPayOptionCash" id="lblPayOptionCash">Cash</label> 
    <input type="radio" id="rdoPayOptionCredit" name="PayOption" value="4" /><label for="rdoPayOptionCredit" id="lblPayOptionCredit">Credit</label> 
    <br />
    <input type="button" id="btnPayOption" class="sfLocale sfBtn" value="OK" />
        <div id="GoodsViewReport" style="display:none;">
                  </div>
</div>
</div>