<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Events.ascx.cs" Inherits="Modules_LandingSummaries_Events" %>

<script type="text/javascript">
    $(function () {
        $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: SageFrameHostURL + "/Modules/LandingSummaries/webservice/wsLandingSummaries.asmx/getCustomerEvents",
            data: "",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                //$("#customerEventsList").html('');
                var datas = data.d;
                //var htmls = "";
                if (datas.length > 0) {
                    var htmls = "<ul class='mCustomScrollbar' id='eventsList'>"
                    $.each(datas, function (index, value) {
                        if (value.DaysRemaining == 0) {
                            htmls += "<li class='blink'><a class='todayEvent' style='color:inherit;cursor:pointer;' id=" + value.TelMobile + "_" + value.MembershipID + "><span class='customerName'>" + value.CustomerName + "</span>'s <span class='eventName'>" + value.Event + "</span> (<span class='daysRemaining' hidden>" + value.DaysRemaining + "</span> <span class='event-days'>TODAY </span>)</a></li>"
                        }
                        else if (value.DaysRemaining == 1) {
                            htmls += "<li><a class='todayEvent' style='color:inherit;cursor:pointer;' id=" + value.TelMobile + "_" + value.MembershipID + "><span class='customerName'>" + value.CustomerName + "</span>'s <span class='eventName'>" + value.Event + "</span> (<span class='daysRemaining' hidden>" + value.DaysRemaining + "</span> <span class='event-days'>TOMORROW </span>)</li>"
                        }
                        else {
                            htmls += "<li><a class='todayEvent' style='color:inherit;cursor:pointer;' id=" + value.TelMobile + "_" + value.MembershipID + "><span class='customerName'>" + value.CustomerName + "</span>'s <span class='eventName'>" + value.Event + "</span> (<span class='daysRemaining'>" + value.DaysRemaining + "</span> <span class='event-days'>DAYS REMAINING</span>)</li>"
                        }
                    });
                    htmls += "</ul>"
                    $("#customerEventsList").append(htmls)
                } else {
                    $("#customerEventsList").append("No Events!");
                }
            },
            failure: function (response) {
                jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });

        $("#eventsList").on('click', '.todayEvent', function (event) {
        
            var data = $(this).attr('id');
            var info = data.split("_");
            var mobile = info[0];
            var list = $(this).parents('li');
            var name = list.find('span.customerName').text();
            var event = list.find('span.eventName').text();
            var days = list.find('span.daysRemaining').text();
            var message = '';
            if (days == 0) {
                message = 'Happy ' + event + ' ' + name + ' !!';
            }
            else if (days == 1) {
                message = name + "'s " + event + " - Tomorrow.";
            }
            else {
                message = name + "'s " + event + " - " + days + " Days Remaining.";
            }
            if (mobile.length > 0) {
                $("#sendSmsDialog").dialog({
                    'title': 'Send SMS',
                    width: 500,
                    modal: true,
                    resizable: true,
                    dialogClass: 'popup-titlebg'
                });

                $('#mobileNumber').val(mobile);
                $('#smsMessage').val(message);
            }
            else {
                //jAlert('Add mobile number before sending message.', 'ALERT!!', function () { window.open('/Add-Customer.aspx?ID=' + info[1], '_blank'); });
                jConfirm('Add mobile number before sending message?', 'Confirm!', function (confirm) {
                    if (confirm) {    
                         $.colorbox({width:"750", height:"96%", iframe:true, href:"/Add-Customer.aspx?ID=" + info[1]});

                       
                    }
                })
            }
        });

        $('#btnCancel').on('click', function () {
            $('#mobileNumber').val('');
            $('#smsMessage').val('');
            $("#sendSmsDialog").dialog('close');
        });

        $("#btnSend").on('click', function () {
            var mob = $('#mobileNumber').val();
            var msg = $('#smsMessage').val();
            $.ajax({
                type: "POST",
                url: SageFrameHostURL + "/Modules/CustomerBalanceReport/WebServiceForCusBalanceReport.asmx/sendSMS",
                dataType: "json",
                data: JSON2.stringify({ to: mob, text: msg }),
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    jAlert(data.d, "INFORMATION!!");
                    $('#mobileNumber').val('');
                    $('#smsMessage').val('');
                    $("#sendSmsDialog").dialog('close');
                },
                failure: function () {
                    jAlert("Sorry some error occured. Contact the support team.", "Error!!");
                }
            });
        });
    });
</script>
<div class="event-sec start-right">
    <div class="dbsum-title">Events</div>

    <div id="customerEventsList" class="dbsum-popular" style="color:#FFFFFF;"></div>

    <div id="sendSmsDialog" style="display:none;">
        <table style="width:auto">
            <tr>
                <td>Mobile Number :</td>
                <td><input id="mobileNumber" type="text" class="sfInputbox" disabled /></td>
            </tr>
            <tr>
                <td>Message:</td>
                <td><textarea id="smsMessage" rows="3" class="sfInputbox" style="width:300px;"></textarea></td>
            </tr>
            <tr><td></td>
            <td> <input id="btnSend" type="button" value="Send" class="sfBtn restro-btn" />
        <input id="btnCancel" type="button" value="Cancel" class="sfBtn restro-btn" /></td>
        </table>
       
    </div>
</div>
