<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderViews.ascx.cs" Inherits="Modules_Order_OrderView" %>

<script type="text/javascript">
    var sentdata = 0;
    var roomdata = 0;
    var OID = 0;
    var queryString = new Array();

    $(function () {

        if (queryString.length == 0) {

            if (window.location.search.split('?').length > 1) {

                var params = window.location.search.split('?')[1];
                var key = params.split('=')[0];
                var value = decodeURIComponent(params.split('=')[1]);
                queryString[key] = value;
            }
        }

        if (queryString["ID"] != null) {
            sentdata = queryString["ID"];
        }
        if (queryString["RID"] != null)
        {
            roomdata = queryString["RID"]
        }
        if(queryString["OID"] != null)
        {
            
            OID = queryString["OID"];
        }
        $(this).companyOrderItemEDIT({
            HostUrl: "<%= HostUrl %>",
            sentData: sentdata,
            roomData: roomdata,
            OID: OID
        });

    });

</script>

<script>
    $(document).ready(function () {
        $('.menu li').click(function () {
            $(this).siblings('li').removeClass('active');
            $(this).addClass('active');
        });
    });
</script>
<div class="sfCol_60 menu-bg">
    <div id="Menushow" class="restaurant-part-menu"></div>
    <div id="Categoryshow" class="restaurant-part-menu"></div>
    <div id="Itemshow" class="restaurant-part-menu"></div>
</div>

<div class="sfCol_40 order-list-bg" id="#OrderList1">

    <div id="OrderList" class="order-list">
        <h3>Orderlist</h3>
        <h6>Room Name:<span id="OLroomname"></span></h6>
        <h6>Table Name:<span id="OLTablename"></span></h6>
        <h6>Order ID:<span id="OLOrdername"></span></h6>
        <table id="orderlist-table">
            <tr>
                <th style="width:40px;">S.N.</th>
                <th>Items</th>
                <th style="width:100px;">Quantity</th>
                <th style="width:60px;">Extra</th>
                <th style="width:80px;">Status</th>
            </tr>

            <tbody class="bindorderlist" style="overflow:scroll;">
            </tbody>
        </table>
        <div class="splitMainView">
            <input type="checkbox" id="splitcheckbox" />Split Bills 
           <div class="splitdiv" style="display:none;">
               Bill no 
            <select id="billno">
                <option value="1">1</option>
            </select>
               </div>
            <br />
               <div class="billdialogue"></div>
               <div id="NoOfBill" class="sfBtn1">Change Bill No.</div>
           </div><br />
            <div class="extradiv"></div>
            <span id="SendOrder" class="sfBtn1">Send Order</span>
            <span id="CancelOrder" class="sfBtn1">Cancel Order</span>
        </div>
    </div>

<%--<script>
    $(document).ready(function () {
        $("tbody.bindorderlist tr:even").css("background-color", " #000000");
    });
</script>--%>

