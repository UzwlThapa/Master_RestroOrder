<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RoiPurchase.ascx.cs" Inherits="Modules_RoiPurchase_RoiPurchase" %>
<style>
    /*#AddTempTable {
        display: none;
    }*/

    #LotNoTable {
        display: none;
    }

    .acc {
        display: none;
    }
</style>

<script type="text/javascript">
    $(function () {

        $(this).companyProfEDIT({
            Username: '<%=Username%>'
        });
        $("#btnAdd").click(function () {
            $("#btnAdd").hide();
            $("#divForPurchaseList").hide();
            $("#divForForm").show();
            $("#btnPurchaseSave").show();
            $('.report-filter').hide();
        });
    });
    jQuery(function ($) {
        $("#commentForm").validate({
            rules: {
                quentity: "required",
            },
            messages: {
                quentity: "Please specify your name",
            }

        });
    });

    //$(function () {

    //     resizeIframe();
    //});
</script>

<div class="RO_wrapper">
    <div class="restro-title clearfix">
        <input id="btnAdd" type="button" class="sfLocale icon-addnew sfBtn" value="Add" />
    </div>
    <div id="divForForm" style="display: none;" class="sfformwrapper">
        <table style="display: block;" class="container">
            <tr>
                <td style="display: none;" class="po">PO No. :
               
                    <input type="hidden" id="txtID" value="0" />
                    <asp:TextBox ReadOnly="true" ClientIDMode="Static" ID="txtPuno" runat="server" CssClass="sfInputbox po" Style="width: 100px;"></asp:TextBox>
                    <%--<input type="text" id="txtPuno" name="PuNo" class="sfInputbox required" />--%>
                    </td>
                <td>Bill Date:
                    </td>
                <td>
                    <input type="text" id="txtBillDate" name="Billdate" class="sfInputbox required" style="width: 100px;" />
                </td>

                <td>IV No:
                    </td>
                <td>
                    <input type="text" id="txtIvNo" name="ivno" class="sfInputbox" style="width: 100px;" />
                </td>
                <td>Vendor Name:
                    </td>
                <td>
                    <input type="checkbox" id="chkVendorBox" />

                    <input type="text" id="txtVendorName" class="sfInputbox txtVendor" style="display: none;" readonly="readonly" attr-id="" />
                    <input type="hidden" id="txtVendorNameID" value="0" />

                    <%--  <select id="ddlvendorID" name="vendor" class="required sfInputbox required" style="width: 100px;">
                        <option selected disabled>-Select-</option>
                        <option value="1">Reason</option>
                        <option value="2">Manoj</option>
                    </select>--%>
                    </td>
                <td>Fy:
                    </td>
                <td>
                    <select id="txtFyid" name="fyid" class="required sfInputbox" style="width: 100px;">
                        <option selected disabled>-Select-</option>
                    </select>
                </td>
                <td>Individual Discount:
                    </td>
                <td>
                    <span style=" margin-right: 5px;">
                                <input type="checkbox" id="chkBoxTotalDis" />
                            </span>
                </td>

            </tr>



        </table>
        <input class="sfBtn restro-btn" type="button" id="btnAddItems" value="Add Items" style="float: right;" />
        <div id="tblAddItem" class="ui-front">
            <form id="commentForm">
                <table id="tblItem" style="display: block; margin: 15px;">
                    <tr>
                        <td>Item
                        </td>
                        <td>
                            <input type="text" id="DdlItemid" class="sfInputbox" name="item" style="width: 200px;" />
                            <input type="hidden" id="lblItemid" />
                        </td>
                    </tr>
                    <tr>
                        <td class="unit">Unit:
                        </td>
                        <td class="unit">
                            <%--<input type="text" id="DdUnitFortextbx" name="quentity" class="sfInputbox" style="width: 100px;" />--%>
                            <select id="DdUnitFortextbx" class="sfInputbox" name="quentity" style="width: 100px;">
                            </select>
                            <input type="hidden" id="DdUnit" name="quentity" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>Quantity
                        </td>
                        <td>
                            <input type="text" id="txtQuentity" name="quentity" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                   
                    <tr>
                        <td>Rate
                        </td>
                        <td>
                            <input type="text" id="txtRate" name="rate" value="0" class="sfInputbox" style="width: 100px;" onkeypress='return IntegerAndDecimal(event,this);' />
                        </td>

                         <td>Previous Rate
                        </td>
                        <td>
                            <input type="text" id="txtOldRate" disabled name="rate" value="0" class="sfInputbox" style="width: 100px;" onkeypress='return IntegerAndDecimal(event,this);' />
                        </td>
                    </tr>
                    <tr>
                        <td class="unclick_show">Lot No
                        </td>
                        <td class="unclick_show">
                            <input type="text" id="txtLotNNo" name="lotNo" class="sfInputbox required" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td class="unclick_show">Batch No 
                        </td>
                        <td class="unclick_show">
                            <input type="text" id="txtBatchNo" name="BatchNO" class="sfInputbox required" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td class="unclick_show">Exp Date
                        </td>
                        <td class="unclick_show">
                            <input type="text" id="txtExpDate" name="ExpDate" class="sfInputbox" style="width: 100px;" readonly="readonly" />
                        </td>
                    </tr>
                    <tr>
                        <td>Total :
                        </td>
                        <td>
                            <input type="text" id="txtTotal" name="Total" class="sfInputbox" style="width: 100px;" onkeypress='return IntegerAndDecimal(event,this);' />
                        </td>
                    </tr>
                </table>
            </form>

            <table id="LotNoTable" style="display: block">
                <tr>
                </tr>
            </table>
            <input class="sfBtn restro-btn" type="button" id="btnPurchaseAdd" value="Add" style="margin-left: 15px;" />
            <input class="sfBtn restro-btn" type="button" id="btnPurchaseClose" value="Close" />
        </div>
        <div id="AddTempTable" style="margin-top: 20px;">
            <table id='purchaseTempTable' class='reportsprint' cellspacing='0'>
                <thead>
                    <tr>
                        <th>Item</th>
                        <th class="acc">ItemID</th>
                        <th>Unit</th>
                        <th class="acc">UnitID</th>
                        <th>Qty</th>
                        <th>Rate</th>
                        <%-- <th>LotNo</th>
                            <th>BatchNo</th>
                            <th>ExpDate</th>--%>
                        <th>Total</th>
                        <th class="divDis" style="display: none;">Discount</th>
                        <th>IsVat</th>

                        <th style='text-align: center;'>Delete</th>
                        <th class="acc">UnitID</th>
                        <th class="acc">Conversion</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
            <div class="tblseperate" style="display: flex;">
                <table style="display: block;">
                    <tr>
                        <td>Remarks:
                    </td>
                        <td>
                            <textarea id="txtRemarks" name="remarks" class="sfInputbox" style="width: 300px; height: 60px;"></textarea>
                        </td>


                    </tr>
                    <tr id="tblCheckGoods">
                        <td>Goods Received : </td>
                        <td>
                            <input type="checkbox" id="CheckBoxGoodReceived" />
                        </td>
                    </tr>
                    <tr id="checkStore" style="display: none;">
                        <td>Store : </td>
                        <td>
                            <select id="ddlStore" class="sfInputbox Store"></select>
                        </td>

                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <input class="sfLocale icon-save sfBtn" type="button" id="btnPurchaseSave" value="Save" />
                            <%--                         <input class="sfLocale icon-close sfBtn" type="button" id="btnPurchaseCancel" value="Cancel"/>--%>
                            <input id="CancelItems" class="sfLocale icon-close sfBtn" type="button" value="Cancel"></td>
                    </tr>
                </table>
                <table id="purchaseTempTablefoot">

                    <tr>
                        <td style="text-align: right;">VAT Item Total: </td>
                        <td class="vatamount" style="width: 80px; text-align: right;">Rs.
                            <label id="txtvatAmt"></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">Non-VAT Total : </td>
                        <td class="nonamount" style="width: 80px; text-align: right;">Rs.
                            <label id="txtnonAmt"></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">Basic Amount : </td>
                        <td class="nonamount" style="width: 80px; text-align: right;">Rs.
                            <label id="txtBasicAmt"></label>
                        </td>
                    </tr>
                    <tr>

                        <td style="text-align: right;">
                            
                            Total Discount (Rs.) : </td>
                        <td style="width: 80px; text-align: right;">
                            <input type="number" class="sfInputbox" style="width: 100px;" id="totaldiscount" />
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <td style="text-align: right;">Extra Discount: </td>
                        <td>
                            <input type="text" class="sfInputbox txtdiscount" id="txtdiscount" onkeypress='return IntegerAndDecimal(event,this);' value="0" style="width: 80px; text-align: right; float: right;" /></td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">Tax Amount : </td>
                        <td class="taxamount" style="width: 80px; text-align: right;">Rs.
                            <label id="txttaxAmt"></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">Total Amount : </td>
                        <td class="totalamount" style="width: 80px; text-align: right;">Rs.
                            <label id="txttotalAmt"></label>
                        </td>
                    </tr>

                </table>
            </div>

        </div>
    </div>
    <div>
        
        <div class="report-filter">
            <table class="" style="display: block;">
                <tbody>
                    <tr>

                        <td>Start Date:
                        </td>
                        <td>
                            <input type="date" value="" id="txtStartDate" class="sfInputbox" style="width: 100px;">
                        </td>
                        <td>End Date:
                        </td>
                        <td>
                            <input type="date" value="" id="txtEndDate" class="sfInputbox" style="width: 100px;">
                        </td>
                        <td>
                            <input type="button" class="sfBtn restro-btn fa fa-eye" id="btnView" value="Search" />
                        </td>
                    </tr>

                </tbody>
            </table>
            <span>Search :</span>
            <input type="text" class="sfInputbox" id="txtSearch" />
        </div>

        <div id="divForPurchaseList" class="restrowrapper"></div>
        <div id="VendorBox" class="restrowrapper"></div>
        <div id="membeshipformlist2">
        </div>
        <div id="payOption" style="display: none;">
            </br>
   
            <label>Select Pay Option:</label>
            <input type="radio" id="rdoPayOptionCash" name="PayOption" value="1" checked style="margin-right: 10px;" />Cash
   
            <input type="radio" id="rdoPayOptionCredit" name="PayOption" value="4" />Credit
   
            <br />
            <input type="button" id="btnPayOption" class="sfLocale sfBtn" value="OK" />
        </div>

        <div id="PurchaseViewReport" style="display: none;">
        </div>
    </div>
</div>

