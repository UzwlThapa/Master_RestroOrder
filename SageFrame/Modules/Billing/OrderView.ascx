<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderView.ascx.cs" Inherits="Modules_Order_OrderView" %>

<script type="text/javascript">
    var totalItemsQntyVisible = true;
    var sentdata = 0;
    var roomdata = 0;
    var OID = 0;
    var name = '';
    var phoneNo = '';
    var NoOfGuest = 0;
    var membershipId = 0;
    var queryString = new Array();

    $(function () {

        function getUrlVars() {
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < hashes.length; i++) {
                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = hash[1];
            }
            return vars;
        };

        if (queryString.length == 0) {

            if (window.location.search.split('?').length > 1) {

                var params = window.location.search.split('?')[1];
                var key = params.split('=')[0];
                var value = decodeURIComponent(params.split('=')[1]);
                queryString[key] = value;
            }
        }

        if (getUrlVars()["ID"] != null) {
            sentdata = queryString["ID"];
            //
            //name = getUrlVars()["Name"];
            //phoneNo = getUrlVars()["phoneNo"];
            //NoOfGuest = getUrlVars()["NoOfGuest"];
            //membershipId = getUrlVars()["MembershipId"];
        }
        if (getUrlVars()["RID"] != null) {
            roomdata = queryString["RID"]
        }
        if (getUrlVars()["OID"] != null) {
            OID = queryString["OID"];
        }
        $(this).companyOrderItemEDIT({
            HostUrl: "<%= HostUrl %>",
            userName: "<%= userName %>",
            numpin: "<%=numpin%>",
            sentData: sentdata,
            roomData: roomdata,
            OID: OID,
            names: name,
            phoneNo: phoneNo,
            NoOfGuests: NoOfGuest,
            membershipId: membershipId
        });

    });

    function IntegerAndDecimal(evt, element) {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if ((charCode != 8) &&
            (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
            (charCode < 48 || charCode > 57))
            return false;
        return true;
    }
</script>

<script type="text/javascript">
    $(document).ready(function () {
        $('.menu li').click(function () {
            $(this).siblings('li').removeClass('active');
            $(this).addClass('active');
        });
    });
</script>

<style>

    .ui-state-focus
{
    color:White;
    background:#ff9933;
    outline:none;
}
</style>


<div class="RO_wrapper">
<div class="sfCol_60 menu-bg" style="height: 100%; padding: 0px;">
    <div id="DialogOrderDetail" style=" display:none; background-color: white;padding: 5px 10px 10px 10px;width: 100%; height:100vh"></div>
    <div id="OrderMenu" style="margin: 10px;">
    <div id="tabs" class="order-tab">
        <ul style="display: none;">
            <li><a href="#tabs-1">Restro Menu</a></li>
            <li><a href="#tabs-2">Restro Combo</a></li>

        </ul>
        <div id="tabs-1">
              <div class="lan_selection"><select id="selLanguage" class="sfInputbox" style="width:150px;" ></select></div>
            <div class="order-search">    
                <input type="text" id="txtSearch" class="sfInputbox" placeholder=" Search..." style="width: 180px;" />
                
                <!-- <input type="button" id="btnSearch" value="Cancel Search" class="icon-save sfBtn restro-btn" style="display:none;"> -->
            </div>
            <div id="Menushow" class="restaurant-part-menu"></div>
            <div id="Categoryshow" class="restaurant-part-menu"></div>
            <div id="Itemshow" class="restaurant-part-menu"></div>
            <div id="Itemshow2" class="restaurant-part-menu"></div>
        </div>
        <div id="tabs-2">
            <div id="ComboMenu" class="restaurant-part-menu"></div>
        </div>
    </div>
    </div>
</div>


<div class="sfCol_40 order-list-bg" id="#OrderList1">
    <div id="OrderList" class="order-list">
        <table id="tableData" style="display:none;padding:0px;margin-bottom:0px;margin-top:0px;">
            <tr>
                <td class="tbldet" style="padding:0px;margin-bottom:10px;margin-top:5px;padding-bottom:5px;">Is Customer : <input type="checkbox" style="display:initial;width:55px;" id="chkcustomerForCash" class="customerForOrder"></td>
                
                <td style="padding:0px;margin-bottom:10px;padding-bottom:5px;">Customer Name <span id="CustomerID" style="display:none;"></span> <input type="text" id="txtCustName" class="sfInputbox" style="margin-right:10px" name="CustName" /></td>
            </tr>
               <tr>
                <td style="padding:0px;margin-bottom:10px;margin-top:5px;padding-bottom:5px;">Contact No<input type="text" id="txtContactNo" onkeypress='return IntegerAndDecimal(event,this);' style="margin-right: 10px" class="sfInputbox"/></td>
                <td style="padding:0px;margin-bottom:10px;margin-top:5px;padding-bottom:5px;">Address<input type="text" id="txtCusAddress" class="sfInputbox" style="margin-right: 10px"/></td>
                <td style="padding:0px;margin-bottom:10px;margin-top:5px;padding-bottom:5px;">PAN<input type="text" id="txtPanNo" onkeypress='return IntegerAndDecimal(event,this);' style="margin-right: 10px" class="sfInputbox"/></td>
                 
                </tr>
                <tr class="tabledet">
                    <td colspan="3" style="padding:0px;margin-bottom:10px;margin-top:5px;padding-bottom:5px;">Bill No: <select id="billno" class="sfInputbox" style="display:initial;width:55px;margin-right:5px;"><option value="1">1</option></select><input type="button" id="NoOfBill" value="Add No. of Bills" class="sfBtn restro-btn" /></td>      
                 <td style="padding:0px;margin-bottom:0px;margin-top:5px;padding-bottom:5px;"></td>
            </tr>
        </table>
            <div class="billdialogue"></div>
        <div id="OrderTab" class="order-tab" style="display:none;">
            <ul >
                <li><a href="#OrderedTab">Ordered Items</a></li>
            </ul>
            <div id="OrderedTab">
                <table id="orderlist-table">
                    <thead>
                        <tr>
                            <th style="width: 40px;">S.N.</th>
                            <th>Items</th>
                            <th style="width: 100px;">Quantity</th>
                            <th style="width: 100px;">Rate</th>
                            <th style="width: 100px;">Extra</th>
                        </tr>
                    </thead>
                    <tbody class="bindorderlist" style="overflow: scroll;">
                    </tbody>
                </table>
            </div>
        </div>
        <div class="orderlist-btn clearfix">
            <button type="button" id="SendOrder" class="sfBtn restro-btn fa fa-send">Send Order</button>
            <!-- <input type="button" id="CancelOrder" value="Cancel Order" class="sfBtn restro-btn"> -->
        </div>
        <div class="totallist">
            <table>
                <tr>
                    <td class="totalamount"></td>
                </tr>
            </table>
        </div>
    </div>
</div>
  
<div id="DisplayCancel" class="canceledOrderItemA" style="display: none">
    <label>Canceled By:</label>
    <label id="cancelby"></label>
    <br />
    <label>Split No:</label>
    <label id="splitNoCancel"></label>
    <br />
    <label>Reason</label><textarea id="canceltextarea" class="sfInputbox"></textarea>
    <input type="button" value="OK" id="btnSumbit" class="sfBtn restro-btn" style="margin-top: 20px;" />
</div>
<div id="canceledOrderItem"  class="canceledOrderItemA" style="display: none">
    <table id="tblforcancelitem">
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Quantity</th>
                <th>Ordered By</th>
                <th>Reason</th>
                <th>Responsible</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <label class="sfBtn saveCanceledItem restro-btn">Done</label>
</div>

 
<div id="membeshipformlist" style="display:none;">
</div>
<div id="BillingView" style="display:none;">
    <input type="button" id="btnPrints" value="Print" class="sfBtn restro-btn" />
    <div id='customer-bill' style='text-align:center;width:100%;'></div>
</div>
</div>
<%--<script>
    $(document).ready(function () {
        $("tbody.bindorderlist tr:even").css("background-color", " #000000");
    });
</script>--%>

            <div class="extradiv"></div>
