<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderItem.ascx.cs" Inherits="Modules_RoOrderItemProcessing_OrderItem" %>


<style>
    .yourCSSClass {text-decoration: line-through;}
</style>
<div class="RO_wrapper">
<!-- <h4 class="billing-table">
    <asp:Literal ID="litTitle" runat="server"></asp:Literal></h4> -->
 <!--    <label>List By Item:  </label>
    <input type="checkbox" id="Checklist" /> -->

<div id="list_grid"><span>Display : </span>
 <div class="list_grid_icon"><label class="btn" id="listviewcc"><i class="fa fa-bars"></i> List</label> 
<label class="btn" id="gridviewcc"><i class="fa fa-th-large"></i> Grid</label></div>
</div>
<div id="tabs" class="order-tab" style="display: none;padding-top:15px;">
    <ul>
        <li><a href="#tabs-1">Queued Orders</a></li>
        <li><a href="#tabs-2">InProgress Orders</a></li>
        <li><a href="#tabs-3">Completed Orders</a></li>
        <li><a href="#tabs-4">Cancelled Orders</a></li>
        <li><a href="#tabs-5">Complementary Orders</a></li>
    </ul>
    <div id="tabs-1">
        <div class="ordered-items">
             <table id="orderedTbl">
                    <thead class="hide">
                    <tr>
                    <th>Item Image</th>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Time</th>
                    <th>Room/Table</th>
                    <th>Action</th>
                    </tr>
                    </thead>
                    <tbody id='orderedList'>
                    </tbody>
                </table>
        </div>
    </div>
    <div id="tabs-2">
        <div class="inprogress-items">
             <table id="inprogressTbl">
                    <thead class="hide">
                    <tr>
                    <th>Item Image</th>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Time</th>
                    <th>Room/Table</th>
                    <th>Action</th>
                    </tr>
                    </thead>
                    <tbody id='inprogressList'>
                    </tbody>
                 </table>
        </div>
    </div>
    <div id="tabs-3">
        <div class="completed-items">
             <table id="completedTbl">
                    <thead class="hide">
                    <tr>
                    <th>Item Image</th>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Time</th>
                    <th>Room/Table</th>
                    </tr>
                    </thead>
                    <tbody id='completedList'>
                    </tbody>
                </table>
        </div>
    </div>
    <div id="tabs-4">
        <div class="cancelled-items">
             <table id="cancelledTbl">
                    <thead class="hide">
                    <tr>
                    <th>Item Image</th>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Time</th>
                    <th>Room/Table</th>
                    </tr>
                    </thead>
                    <tbody id='cancelledList'>
                    </tbody>
                </table>
        </div>
    </div>
     <div id="tabs-5">
        <div class="complementary-items">
            <table id="complementaryTbl">
                    <thead class="hide">
                    <tr>
                    <th>Item Image</th>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Time</th>
                    <th>Room/Table</th>
                    <th>Action</th>
                    </tr>
                    </thead>
                    <tbody id='complementaryList'>
                    </tbody>
                 </table>
        </div>
    </div>
</div>
<div id="callwaiterDiv"></div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $(this).companyProfEDIT({
            costcenterRefreshInterval:'<%=costcenterRefreshInterval%>',
            costcenter: '<%=costcenter%>'
         });
       
    });
</script>


