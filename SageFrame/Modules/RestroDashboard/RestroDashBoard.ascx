<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RestroDashBoard.ascx.cs" Inherits="Modules_RestroDashboard_RestroDashBoard" %>

<style>
    div#CusOrder img {
        position: absolute;
        right: 10px;
        top: 10px;
        cursor: pointer;
    }

    input#setTimeButton {
        float: right;
    }

    .comment-section1 {
        position: fixed;
        right: 0px;
        bottom: 20px;
        width: 5%;
        background: #FFFFFF;
        border-radius: 0px 0px 0px 0px;
        box-shadow: 0px 1px 1px #888888;
        border: none;
        padding: 5px;
        cursor: pointer;
        font-size: 15px;
        outline: none;
    }

 .comment-section1 img {
            height: 35px;
        }


    .comment1 {
        width: 30%;
        right: 0px;
        position: fixed;
        bottom: 0px;
        z-index: 9999;
    }

    div#CusOrder {
        position: fixed;
        right: 73px;
        bottom: 0;
        width: 30%;
        background: #FFFFFF;
        padding: 1px 5px;
        box-shadow: 0px 0px 3px #888888;
        border-radius: 3px 0px 0px 3px;
        z-index: 9999;
    }

        div#CusOrder table {
            margin-bottom: 0px;
        }

            div#CusOrder table td, div#CusOrder table th {
                font-family: 'El Messiri', sans-serif;
                white-space: nowrap;
            }

        div#CusOrder .sfBtn {
            margin: 5px;
        }

    #cusorder-part {
        width: 100%;
    }

    .sfInputbox, .sfInputbox[readonly] {
        background: rgba(255,255,255,0.6);
    }
</style>
<script type="text/javascript">

    $(function () {
        $(this).companyDashboardEDIT({
            HostUrl: "<%= HostUrl %>",
            TypeId: "<%=TypeId%>"
        });

    });
</script>

<script>

    $(document).ready(function () {
        if("<%= notification %>" == "true"){
            $('#callwaiter').show();
        }
        $("#txtOrderDate").datepicker();
        $('#CusOrder').hide();
        $("#txtAppReceiveDate").datepicker();
        $('#txtAppReceiveTime').timepicker({
            interval: 20,
            dynamic: false,
            dropdown: true,
            scrollbar: true,
            setTime: new Date()
        });
        $('#txtOrderTime').timepicker({
            interval: 20,
            dynamic: false,
            dropdown: true,
            scrollbar: true,
            setTime: new Date()
        });
        $('#setTimeButton').on('click', function () {
            $('#txtOrderTime').timepicker('setTime', new Date());
            $("#txtCommentDate").datepicker().datepicker("setDate", new Date());
        });
        
        $('.OccupiedRooms li , .Tables li , .Roomtype li ').click(function () {
            $(this).siblings('li').removeClass('active');
             $(this).addClass('active');
        });

    });
</script>



<div id="UnpaidBills" style="display:none;"></div>
<div id="DialogOrderDetail"></div>
<div id="MembershipPopTable"></div>

<div class="sfCol_25 side-menuu">
<div class="sidemenu-content">
    <asp:Image ID="ImgPrvs" runat="server" style="width:auto;height:70px;"/><asp:Literal ID="ltrRoomType" runat="server" /><div class="powered-by">
        <h5 style="color: #FFFFFF">Powered By</h5>
        <a href="http://danfesolution.com/" target="_blank">
            <img src="Modules/Logo/image/danfe-logo.png"></a>
    </div>
    </div>
</div>
<div class="sfCol_75 dashboard">
  <div id="tabs" class="hometab" style="display: none;">
        <ul>
            <li><a href="#OccupiedTablesdiv">Occupied Table ( <span id='OccTablesLength'></span> )</a></li>
            <li id='OccTab' style="display:none;"><a href="#OccupiedRoomsdiv">Occupied Rooms ( <span id='OccRoomsLength'></span> )</a></li>
             <li id='bookRoomTab' style="display:none;"><a href="#BookedRoomsdiv">Booked Rooms ( <span id='BookRoomsLength'></span> )</a></li>

        </ul>
    <div id='OccupiedTablesdiv'></div>
    <div id='OccupiedRoomsdiv'></div>
    <div id='BookedRoomsdiv'></div></div>
    <asp:Literal ID="ltrtable" runat="server" />
    <asp:Literal ID="ltrOccupied" runat="server" />
    <asp:Literal ID="ltrRoom" runat="server" />
</div>

<!-- <div class="comment1">
    <div class="comment-section1" id="btnview1">

        <label id="commentit1" class="parent sfLevel1 hide-comment commentname active"><span class="parent sfLevel1"></span></label>
        <img src="images/order-icon.png" />
    </div> -->

<div class="restro-offer">
    <ul>
         <li id="complementary">
            <img src="images/complimentary.png" /><h6>Complimentary</h6>
        </li>
        <li id="mergeTable">
            <img src="images/merge.png" /><h6>Merge Tables</h6>
        </li>
         <li id="unpaid-bills">
            <img src="images/unpaid-bill.png"><h6>Unpaid Bills</h6>
        </li>
<%--        <li id="dinee-inn">
            <img src="images/dine-in.png"><h6>Dine In</h6>
        </li>--%>
        <li id="take-awayy">
            <img src="images/take-away.png"><h6>Take Away</h6>
        </li>
        <%--<li id="delieveryy">
            <img src="images/delievery.png"><h6>Delievery</h6>
        </li>--%>
        <!--  <li><img src="images/room-service.png"><h6>Room Service</h6></li>
            <li><img src="images/call-waiter.png"><h6>Call Waiter</h6></li> -->
             <li id="callwaiter" style="display:none;">
            <img src="images/waiter-call.png"><h6>Call Waiter</h6>
            </li>
    </ul>
</div>
<div id="CusOrder" style="display:none;">
    <img src="images/closee.png" id="btnCloseOrder">
    <table id="cusorder-part">
        <h3 style="text-align: center;">Order</h3>
        <tr>
            <td>Name:
            </td>
            <td>
                <input type="text" id="txtCusName" name="CusName" class="sfInputbox" />
            </td>
        </tr>
        <tr>
            <td>Order Date:
            </td>
            <td>
                <input type="text" id="txtOrderDate" name="OrderDate" class="sfInputbox" readonly />
            </td>
        </tr>
        <tr>
            <td>Order Time:
            </td>
            <td class="clearfix">
                <input type="text" id="txtOrderTime" name="OrderTime" class="sfInputbox" style="float: left; width: 45%" />
                <input type="button" id="setTimeButton" style="float: right; width: 50%; height: 33px; background: #e27800; border: 0px solid; border-radius: 3px; padding: 10px; color: #FFFFFF; outline: 0;" value="Set Current Time" />
            </td>
        </tr>

        <tr>
            <td>
                <label>Type:</label>
            </td>
            <td>
                <input type="radio" class="dineIn" name="gender" value="0">
                Dine In
                    <input id="rdoTakeAway" type="radio" class="takeaway" name="gender" value="1">
                Take Away
                    <input type="radio" class="delivery" name="gender" value="2">
                Delivery
            </td>
        </tr>
    </table>
    <table class="main" style="display: none;">
        <tr class="dine">
            <td>
                <label>No. Of People</label>
            </td>
            <td>
                <input type="text" id="txtPeople" name="People" class="sfInputbox" />
            </td>
        </tr>
        <tr class="com">
            <td>
                <label class="deli">Deliver Time</label>
            </td>
            <td>
                <input type="text" id="txtAppReceiveTime" name="AppReceiveTime" class="sfInputbox" />
            </td>
        </tr>
        <tr class="com">
            <td>
                <label class="deli">Deliver Date</label>
            </td>
            <td>
                <input type="text" id="txtAppReceiveDate" name="AppReceiveDate" class="sfInputbox" readonly />
            </td>
        </tr>
        <tr class="com">
            <td>
                <label class="deli">Cell</label>
            </td>
            <td>
                <input type="text" id="txtCell" name="cell" class="sfInputbox" />
            </td>

        </tr>
        <tr class="com">
            <td>
                <label class="deli">Address</label>
            </td>
            <td>
                <input type="text" id="txtAddress" name="address" class="sfInputbox" />
            </td>
        </tr>
        <tr class="com">
            <td class="deli">
                <label>Message</label>
            </td>
            <td>
                <textarea id="txtmsg" name="address" class="sfInputbox"></textarea>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <input type="button" id="btnSaveOrder" value="SAVE" class="sfLocale icon-save sfBtn restro-btn" /></td>
        </tr>
    </table>
</div>
<div id="callwaiterDiv"></div>

<div id="membeshipformlist" style="display:none;">
</div>

<div id="membeshipformlist2" style="display:none;">
</div>
<div id="DisplayCancel" style="display: none">
    <label>Canceled By : </label>
    <label id="cancelby"></label>
    <div style='display:flex'>
    <label>Split No : </label>
    <select id="splitNoCancel" class='sfInputbox' style='width:100px;margin-left:2px;'></select>
    </div>
    <label>Reason</label><textarea id="canceltextarea" class="sfInputbox"></textarea>
    <input type="button" value="OK" id="btnSumbit" class="icon-save sfBtn restro-btn" style="margin-top:20px;"/>
</div>
<div id="divForRoomTableMerge" class="" style="display: none">
    <div class="">
        <table style="display:block;">
            <tr>
                <asp:Literal ID="ltrMerge" runat="server" />
                <asp:Literal ID="ltrRoomForMerge" runat="server" />
            </tr>
        </table>
    </div>
    <div >
        <div class ='TablesForMerge'></div>
    </div>
        <label class="sfBtn btnMerge restro-btn">Merge Tables</label>
</div>
<div id="divForRoomTableShift" class="" style="display: none">
        <table>
            <tr>
                <asp:Literal ID="ltrShift" runat="server" />
                <asp:Literal ID="ltrRoomForShift" runat="server" />
            </tr>
        </table>

        <div class ='TablesForShift'></div>
</div>
<div id="BillingView" style="display:none;">
    <input type="button" id="btnPrints" value="Print" class="sfBtn restro-btn" />
    <div id='customer-bill' style='text-align:center;width:100%;'></div>
</div>

<div class='dashboardmain roomBookDash' style="display:none;">
    <input id='hdfRoomBookDetailId' type='hidden' value='' />
    <div id='BookingDetail-section' class='left-sec'>
        <div id='BookingRoom'>
            <table id='Roomtable' class='sfGridwrapper display tablee-section' cellspacing='0' style='display:block;'>
            <tbody>
                <tr>
                    <td> Room Name : <input type='text' id="txtRoomName" class='sfInputbox' value='' readonly style="width:150px;"/><input id='hdfRoomId' type='hidden' value='' /><input id='hdfTableId' type='hidden' value='' /></td>
                    <td> Book From (*) : <input type='text' id='txtBookFrom' name='BookedFromDate' class='sfInputbox' style="width:150px;"/></td>
                    <td> Book To (*) : <input type='text' id='txtBookTo' name='BookedToDate' class='sfInputbox' style="width:150px;"/></td>
                </tr>
                <tr>
                    <td> Rate : <input type='text' id='txtRate' class='sfInputbox' value='' disabled style="width:150px;"/></td>
                    <td> No of Instant : <input type='text' id='txtDays' class='sfInputbox' disabled style="width:150px;"/></td>
                    <td> Amount : <input type='text' id='txtAmount' class='sfInputbox' disabled style="width:150px;"/></td>
                </tr>
                <tr>
                    <td>Advance Pay: <input type="text" onkeypress="return IntegerAndDecimal(event,this);" class="sfInputbox" id="BookAdvancePay" value="0" /></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>


    <div id='BookingMember' class='right-sec'>

        <div id='LoyaltyMember' class='right-secA'>
        <table class='room-book-tbl' style='display:block;margin-bottom:0px;'>
            <tr>
                <td><input type='checkbox' id='Membercheckbox' /><label for='Membercheckbox' style='color:#575757;font-size:14px;'><span>Registered Member</span></label></td>
            </tr>
            <tr>
                <td>Customer Name(*) :</td><td><input id='MemberName' type='text' name='MemberName' class='sfInputbox'/><input id='MemberID' value='0' type='hidden' /></td>
            </tr>
            <tr>
                <td>Phone No(*) :</td>
                <td><input id='MemberPhone' type='text' name='MemberPhone' class='sfInputbox'/></td>
            </tr>
            <tr>
                <td>Email Address :</td>
                <td><input id='MemberEmail' type='text'  class='sfInputbox'/></td>
            </tr>
            <tr>
                <td>Citizenship/Passport No :</td>
                <td><input id='MemberIdCardNo' type='text'  class='sfInputbox'/></td>
            </tr>
        </table>
                  



        <input id='btnBook' type='button'  class='sfBtn btnBook restro-btn' value='Book Now ' style='margin-top:20px;' />
        <input id='btnCancelBook' type='button'  class='sfBtn btnCancelBook restro-btn' value='Cancel' style='margin-top:20px;margin-left:10px;'/>
        </div>
    </div>
</div>
<script>

    $('#CusOrder').hide(), { direction: 'right' };

    $('.restro-offer li#dinee-inn').click(function (e) {
        e.stopPropagation();
        var effect = 'slide';
        var options = { direction: 'right' };
        var duration = 700;
        if ($('#CusOrder').css("display") == 'none') {
            $('#CusOrder').toggle(effect, options, duration);
        }

        $('.dineIn').prop('checked', true);
        $(".com").hide();
        $(".dine").show();
    });


    //$('.restro-offer li#take-awayy').click(function (e) {
    //    e.stopPropagation();
    //    var effect = 'slide';
    //    var options = { direction: 'right' };
    //    var duration = 700;
    //    if ($('#CusOrder').css("display") == 'none') {
    //        $('#CusOrder').toggle(effect, options, duration);
    //    }
    //    $('.takeaway').prop('checked', true);
    //    $(".com").show();
    //    $(".dine").hide();
    //});

    $('.restro-offer li#delieveryy').click(function (e) {
        e.stopPropagation();
        var effect = 'slide';
        var options = { direction: 'right' };
        var duration = 700;
        if ($('#CusOrder').css("display") == 'none') {
            $('#CusOrder').toggle(effect, options, duration);
        }
        $('.delivery').prop('checked', true);
        $(".com").show();
        $(".dine").hide();
    });
    $('#CusOrder').click(function (e) {
        e.stopPropagation();
    });
    $("#btnCloseOrder").click(function () {
        $('#CusOrder').slideUp();
    });

    // $(document).click(function () {
    //    $('#CusOrder').slideUp();
    // });

</script>

<script>
    $(document).ready(function () {
        $('#btnview').click(function () {
            $('div#CusOrder').hide();
        });
    });

</script>
