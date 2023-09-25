<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CakeOrder.ascx.cs" Inherits="Modules_CakeOrder_CakeOrder" %>
<script type="text/javascript">
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

        if (getUrlVars()["id"] != null) {
            sentdata = queryString["id"];
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
<div class="RO_wrapper">
    <div class="sfCol_60 menu-bg">
        <div id="tabs" class="order-tab">
            <ul style="display: none;">
                <li><a href="#tabs-1">Restro Menu</a></li>
                <li><a href="#tabs-2">Restro Combo</a></li>

            </ul>
            <div id="tabs-1">

                <div class="lan_selection"><select id="selLanguage" class="sfInputbox" style="width:200px;" ></select></div>
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


    <div class="sfCol_40 order-list-bg" id="#OrderList1">
        <div id="OrderList" class="order-list">
            <table id="tableData" style="display: none; padding: 0px; margin-bottom: 0px; margin-top: 0px;">
                <tr class="tabledet">                    
                    <td style="padding: 0px; margin-bottom: 0px; margin-top: 5px; padding-bottom: 5px;"><span id="CustomerID" style="display: none;"></span></td>
                </tr>
                <tr>
                    <td hidden>
                        <input type="text" id="txtOrderMasterId" hidden /></td>
                    <td style="padding: 0px; margin-bottom: 10px; padding-bottom: 5px; margin-right: 5px;">Customer Name<input type="text" id="txtCustName" class="sfInputbox" name="CustName" /></td>                   
                    <td style="padding: 0px; margin-bottom: 10px; margin-top: 5px; padding-bottom: 5px; margin-right: 5px;">Contact No<input type="text" id="txtContactNo" class="sfInputbox" /></td>
                </tr>
                <tr>
                    <%--<td>Delivery Date and Time<input type="datetime-local" id="txtDeliveryDateTime" class="sfInputbox" autocomplete="off" style="width: 200px;" /></td>--%>
                    <td style="padding: 0px; margin-bottom: 10px; margin-top: 5px; padding-bottom: 5px; margin-right: 5px;">Address<input type="text" id="txtAddress" class="sfInputbox" /></td>
                    <td style="padding: 0px; margin-bottom: 10px; margin-top: 5px; padding-bottom: 5px; margin-right: 5px;">Advance Amount<input type="number" id="txtAdvanceAmount" value="0" class="sfInputbox" /></td>
                </tr>
                <tr>
                    <td style="padding: 0px; margin-bottom: 10px; margin-top: 5px; padding-bottom: 5px; margin-right: 5px;">Delivery Service
                    <select class="sfInputbox" id="txtDeliveryService">
                        <option value="self" selected>Self</option>
                        <option value="delivery">Delivery</option>
                    </select>
                    </td>
                    <%--<td style="padding: 0px; margin-bottom: 10px; margin-top: 5px; padding-bottom: 5px; margin-right: 5px;">Advance Amount<input type="number" id="txtAdvanceAmount" value="0" class="sfInputbox" /></td>--%>
                    <td>Delivery Date and Time<input type="datetime-local" id="txtDeliveryDateTime" class="sfInputbox" autocomplete="off" style="width: 200px;" /></td>
                </tr>


            </table>

            <div id="OrderTab" class="order-tab" style="display: none;">
                <ul>
                    <li><a href="#OrderedTab">Ordered Items</a></li>
                    <!--  <li><a href="#InPrgTab">Inprogress</a></li>
                <li><a href="#CompTab">Completed</a></li> -->

                </ul>
                <div id="OrderedTab">
                    <table id="orderlist-table">
                        <thead>
                            <tr>
                                <th style="width: 40px;">S.N.</th>
                                <th>Items</th>
                                <th style="width: 100px;">Quantity</th>
                                <th style="width: 100px;">Rate</th>
                                <th style="width: 60px;">Extra</th>
                                <%--<th style="width: 80px;">Status</th>--%>
                            </tr>
                        </thead>
                        <tbody class="bindorderlist" style="overflow: scroll;">
                        </tbody>
                        <tfoot class="bindorderlistfoot">
                            <tr>
                                <td colspan='4' style='font-size: 13px;'>Please click the Images on Left Side to Order Items.</td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <!-- <div id="InPrgTab">
                <table id="prevInPrgOrdersTable">
                    <thead>
                        <tr>
                            <th style="width: 40px;">S.N.</th>
                            <th>Items</th>
                            <th style="width: 100px;">Quantity</th>
                            <%--<th style="width: 80px;">Status</th>--%>
                        </tr>
                    </thead>
                    <tbody id="bindInPrgOrders" style="overflow: scroll;">
                    </tbody>
                </table>
            </div>
            <div id="CompTab">
                <table id="prevCompOrdersTable">
                    <thead>
                        <tr>
                            <th style="width: 40px;">S.N.</th>
                            <th>Items</th>
                            <th style="width: 100px;">Quantity</th>
                            <%--<th style="width: 80px;">Status</th>--%>
                        </tr>
                    </thead>
                    <tbody id="bindCompOrders" style="overflow: scroll;">
                    </tbody>
                </table>
            </div> -->
            </div>
            <div class="splitMainView clearfix" style="display: none;">
                <div class="sfCol_33" style="padding: 6px;">
                    <input type="checkbox" id="splitcheckbox" />
                    <label for="splitcheckbox" style="color: #575757;">Split Bills</label>
                </div>

                <%-- <div class="sfCol_13" style="padding:6px;">
                    
             <input type="checkbox" id="splitdisplayall" />
    		<label for="splitdisplayall" style="color:#575757;">All</label> </div>--%>

                <div class="splitdiv sfCol_37" style="display: none;">
                    <label style="width: 40%; float: left; padding: 6px 0px;">Bill Number:</label>
                    <select id="billno" class="sfInputbox" style="width: 55%;">
                        <option value="1">1</option>
                    </select>
                </div>
                <div class="billdialogue"></div>
                <div class="extradiv"></div>
                <div id="NoOfBill" class="sfBtn restro-btn sfCol_30">Change Bill No.</div>
            </div>
            <div class="orderlist-btn">
                <input type="button" id="SendOrder" value="Confirm Order" class="sfBtn restro-btn">
                <%--<input type="button" id="CancelOrder" value="Cancel Order" class="sfBtn restro-btn">--%>
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

        <label>Reason</label><textarea id="canceltextarea" class="sfInputbox"></textarea>
        <input type="button" value="OK" id="btnSumbit" class="icon-save sfBtn restro-btn" style="margin-top: 20px;" />
    </div>
    <div id="canceledOrderItem" class="canceledOrderItemA" style="display: none">
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
    <div id="DialogOrderDetail"></div>
    <div id="membeshipformlist" style="display: none;">
    </div>
    <div id="BillingView" style="display: none;">
        <input type="button" id="btnPrints" value="Print" class="sfBtn restro-btn" />
        <div id='customer-bill' style='text-align: center; width: 100%;'></div>
    </div>
</div>
<%--<script>
    $(document).ready(function () {
        $("tbody.bindorderlist tr:even").css("background-color", " #000000");
    });
</script>--%>

