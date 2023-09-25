<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderDeliveryStatus.ascx.cs" Inherits="Modules_OrderDelivery_OrderDeliveryStatus" %>
<style>
    div#CusOrder img {
        position: absolute;
        right: 10px;
        top: 10px;
        cursor: pointer;
    }DisplayCancel

    .sfInputbox, .sfInputbox[readonly] {
        background: rgba(255,255,255,0.6);
    }
 
}
</style>
<script type="text/javascript">
    $(function () {
        $("#tabs").tabs();
        $("#tabss").tabs();
        $('#tabss').css('display', 'block');
        $(this).companyProfEDIT({
              HostUrl: "<%= HostUrl %>"
        });

    });


</script>
<div class="RO_wrapper">
    <div id="tabss" class="tabsForlist" style="display: none;padding:10px;">
        <ul>
            <li><a href="#tabs-2">Delivery Orders</a></li>
            <li><a href="#tabs-3">Dispatched Orders</a></li>
              <li><a href="#tabs-4">Delivered Orders</a></li>
        </ul>

        <div id="tabs-2" style="padding: 1px">
            <div id="OrderDelieverydiv" class="restrowrapper"></div>
        </div>
        <div id="tabs-3" style="padding: 1px">
            <div id="DispatchDelieverydiv" class="restrowrapper"></div>
        </div>
        <div id="tabs-4" style="padding: 1px">
            <div id="OrderDelievereddiv" class="restrowrapper"></div>
        </div>
    </div>
    <div id="DialogOrderDetail"></div>
</div>
<div id="BillingView" style="display: none;">
    <input type="button" id="btnPrints" value="Print" class="sfBtn restro-btn" />
    <div id='customer-bill' style='text-align: center; width: 100%;'></div>
</div>
<div id="membeshipformlist">
</div>

<div id="DisplayCancel" style="display: none">
    <label>Canceled By : </label>
    <label id="cancelby"></label>
    <div style='display:flex'>
    <label>Split No : </label>
    <select id="splitNoCancel" class='sfInputbox' style='width:100px;margin-left:2px;'></select>
    </div>
    <label>Reason</label><textarea id="canceltextarea" class="sfInputbox"></textarea>
    <input type="button" value="OK" id="btnSumbit" class="sfBtn restro-btn" style="margin-top:20px;"/>
</div>










