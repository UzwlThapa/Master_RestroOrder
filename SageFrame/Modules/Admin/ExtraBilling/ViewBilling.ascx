<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ViewBilling.ascx.cs" Inherits="Modules_ExtraBilling_ViewBilling" %>

<style type="text/css">
    table.summation {
    display: block;
}

</style>

<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
        });
    });

</script>


<script>
    $(document).ready(function () {
        sum();
        $("#txtRate, #txtQts").on("keydown keyup", sum);
    });

    function sum() {
        $("#txtTotal").val(Number($("#txtRate").val()) * Number($("#txtQts").val()));
    }
</script>

<div id="tabs">
    <ul>

        <li><a href="#tabs-7">Restro Billing</a></li>


    </ul>
    <div id="tabs-7">
    <table style="display:block;">
        <tr>
            <td style="width:150px;">
                <label>Customer Name :</label>

            </td>
            <td>
                <input type="text" id="txtCusName" class="sfInputbox" style="float:left;width:150px;" />
                <input type="button" id="btnAddCus" value="Add Customer" class="sfBtn" style="float:left;height:20px;margin-left:5px;"/>
            </td>
            
                
            </tr>
            <tr>
            <td>
                <label>Issue Date :</label>

            </td>
            <td>
                <input type="text" id="txtIssueDate" class="sfInputbox" style="width:150px;" readonly />
            </td>
             </tr>
            <tr>
            <td>
                <label>Pan :</label>

            </td>
            <td>
                <input type="text" id="txtPan" class="sfInputbox" style="width:150px;"/>
            </td>
            
        </tr>
        
    </table>
    <table>
        <tr>
            <td style="width:150px;">Item Name :</td>
            <td>
                <input type="text" id="txtItem" name="Item" class="sfInputbox" style="width:150px;" />
            </td>
            <td>Rate :</td>
            <td>
                <input type="text" id="txtRate" name="Rate" class="sfInputbox" style="width:80px;"/>
            </td>
            <td>Quantity :</td>
            <td>
                <input type="text" id="txtQts" name="Quantity" class="sfInputbox" style="width:80px;"/>
            </td>
            <td>Total :</td>
            <td>
                <input type="text" id="txtTotal"  readonly class="sfInputbox" style="float:left;width:80px;"/>
                <input type="button" id="btnAddItem" value="Add" class="sfBtn" style="float:left;height:20px;"/>
            </td>
        </tr>
    </table>

    <div id="AddTempTable" style="padding:0">
                <table id='purchaseTempTable' class='sfGridwrapper display tablee-section' cellspacing='0'>
                    <thead>
                    <tr>
                    <th >Item</th><th style="display:none">PurchaseDetailID</th> <th>Rate</th>  <th>Qty</th> <th id="total">Total</th> <th style="display:none">ItemID</th>  <th>Edit</th><th>Delete</th>
                    </tr>
                   </thead>
                   <tbody>

                   </tbody>
                     
                  </table>
              </div>

   <table class="summation clearfix">
   <tbody>
       <tr>
            <td style="width:150px;">Sub Total :</td>
            <td> <input type="text" id="txtSubTotal" class="sfInputbox" style="width:100px;"/></td>
            
        </tr>
       <tr>
             <td>Discount (percentage) :</td>
            <td> <input type="text" id="txtDiscount" class="sfInputbox" style="width:100px;"/></td>
             
        </tr>
        <tr>
            <td>Total :</td>
            <td> <input type="text" id="txtAllTotal" class="sfInputbox" style="width:100px;"/></td>
            
        </tr>
       
       
        <tr>
             <td>Vat  (percentage) :</td>
            <td> <input type="text" id="txtVat"  value="13" class="sfInputbox" style="width:100px;"/></td>
             
        </tr>
       
        <tr>
            <td>Grand Total :</td>
            <td> <input type="text" id="txtGrandTotal" class="sfInputbox" style="width:100px;"/></td>
        </tr>
        </tbody>
    </table>
    <input class="sfLocale icon-save sfBtn" type="button" id="btnPurchaseSave" value="Save" />
<div id="membeshipformlist"></div>
</div>
</div>  
    