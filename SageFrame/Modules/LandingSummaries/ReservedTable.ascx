<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ReservedTable.ascx.cs" Inherits="Modules_LandingSummaries_ReservedTable" %>

<script type="text/javascript">
    $(document).ready(function () {
        myAjaxCall();
        window.setInterval(function () {
            myAjaxCall();
        }, 30000);
    });

   function myAjaxCall() {
            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                url: SageFrameHostURL + "/Modules/LandingSummaries/webservice/wsLandingSummaries.asmx/getReservedTable",
                data: "",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    $("#ReservedTablesList").html("");
                    datas = JSON.parse(data.d);
                    if (datas.length > 0) {
                       
                        var htmls = '';
                        htmls += "<ul class='mCustomScrollbar' id='reserveList'>"
                        $.each(datas, function (index, value) {
                            var date = new Date(value.ReservedDateTime);
                            htmls += "<li><a class='todayEvent' style='color:inherit;cursor:pointer;' id=" + value.Phone + "_" + value.NoOfPeople + "_" + value.ReservedDateTime + "><span class=tableName'>" + value.Tablename + " will be reserved in </span><span class='Time'>" + value.Time + " minutes by </span><span class='customerName'>" + value.CustomerName + "</span> <span class='ReserveDate'>" + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + "</span> </a></li>"
                        });
                        htmls += "</ul>"
                        $("#ReservedTablesList").append(htmls)
                    } else {
                        $("#ReservedTablesList").append("No ReservedTables!");
                    }
                },
                failure: function (response) {
                    jAlert("Sorry some error occured. Contact the support team.", "Error!!");
                }
            });

            $("#ReservedTablesList").on('click', '.todayEvent', function (event) {
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                var data = $(this).attr('id');
                var info = data.split("_");
                var mobile = info[0];
                var date = new Date(info[2]);
                var hours = date.getHours()
                var minutes = date.getMinutes()
                if (minutes < 10)
                    minutes = "0" + minutes;

                var suffix = "AM";
                if (hours >= 12) {
                    suffix = "PM";
                    hours = hours - 12;
                }
                if (hours == 0) {
                    hours = 12;
                }
                var current_time = hours + ":" + minutes + " " + suffix;
                var list = $(this).parents('li');
                var name = list.find('span.customerName').text();
                var message = '';
                message += 'Dear ' + name + ', \n';
                message += 'Your ' + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + ' ' + current_time + ' reservation';
                message += ' of table ' + info[1] + ' at ' + companyInfo.Name + ' has been booked.';
                message += ' Please ! Confirm your reservation 30 minutes before ' + current_time + '. \n';
                message += ' Thank you!!';
                if (mobile.length > 0) {
                    $('#mblnum').val(mobile);
                    $('#sms').val(message);

                    $("#sendSms").dialog({
                        'title': 'Send SMS',
                        width: 500,
                       // modal: true,
                        resizable: true,
                        dialogClass: 'popup-titlebg'
                    });

                }
                else {
                    jConfirm('Add mobile number before sending message?', 'Confirm!', function (confirm) {
                        if (confirm) {
                            $.colorbox({ width: "750", height: "96%", iframe: true, href: "/Add-Customer.aspx?ID=" + info[1] });


                        }
                    })
                }
            });

            $('#btnCancelReserve').on('click', function () {
                $('#mblnum').val('');
                $('#sms').val('');
               $("#sendSms").dialog('close');
            });

            $("#btnSendReserve").on('click', function () {
                var mob = $('#mblnum').val();
                var msg = $('#sms').val();
                $.ajax({
                    type: "POST",
                    url: SageFrameHostURL + "/Modules/CustomerBalanceReport/WebServiceForCusBalanceReport.asmx/sendSMS",
                    dataType: "json",
                    data: JSON2.stringify({ to: mob, text: msg }),
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        jAlert(data.d, "INFORMATION!!");
                        $('#mblnum').val('');
                        $('#sms').val('');
                       $("#sendSms").dialog('close');
                    },
                    failure: function () {
                        jAlert("Sorry some error occured. Contact the support team.", "Error!!");
                    }
                });
            });
     
    };
</script>
<div class="event-sec start-right">
    <div class="dbsum-title">Reserved Tables</div>

    <div id="ReservedTablesList" class="dbsum-popular" style="color:#FFFFFF;"></div>

    <div id="sendSms" style="display:none;">
        <table style="width:auto">
            <tr>
                <td>Mobile Number :</td>
                <td><input id="mblnum" type="text" class="sfInputbox" /></td>
            </tr>
            <tr>
                <td>Message:</td>
                <td><textarea id="sms" rows="3" class="sfInputbox" style="width:350px;height:150px;"></textarea></td>
            </tr>
            <tr><td></td>
            <td> <input id="btnSendReserve" type="button" value="Send" class="sfBtn restro-btn" />
        <input id="btnCancelReserve" type="button" value="Cancel" class="sfBtn restro-btn" /></td>
        </table>
       
    </div>
</div>
