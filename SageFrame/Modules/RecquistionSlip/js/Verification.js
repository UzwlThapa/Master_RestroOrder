
(function ($) {
    var tabs = $("#tabs").tabs();
    $('#tabs').css('display', 'block');
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 Username: '',
                 ModulePath: '/Modules/RecquistionSlip/'
             }, p);
        var verifiedList = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "RecquistionService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },
            InitialSetup: function () {
               
               
            },

            init: function () {
                eventFunction.InitialSetup();
                eventFunction.GetRoleNames();
                
                $('#txtSearch').on('keyup', function () {
                    eventFunction.GetAllForVerifiying();
                });

                //$("#ddlRecievedBy option:contains(" + SageFrameUserName + ")").attr("selected", "selected");
                $('#btnView').on('click', function () {
                    $("#tabs").tabs({ active: 0 });
                    if ($('#ddlRecievedBy').val() != null && $('#ddlRecievedBy').val() != '') {
                        eventFunction.GetDetailsByUserID();
                       
                    } else {
                        jAlert('Please Select The  Receiver Name.', 'Alert!', function () { });
                    }
                });

                $("#tblForVerification").on('click', '.IssueView', function () {
                    var imid = $(this).attr('id');
                    eventFunction.config.method = "GetIssueDetailsbyId";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ imid: imid });
                    eventFunction.config.ajaxCallMode = 4;
                    eventFunction.ajaxCall(eventFunction.config);
                });

                $("#tblVerified").on('click', '.IssueView', function () {
                    var imid = $(this).attr('id');
                    eventFunction.config.method = "GetIssueDetailsbyId";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ imid: imid });
                    eventFunction.config.ajaxCallMode = 6;
                    eventFunction.ajaxCall(eventFunction.config);
                });


             
            },
            ajaxCall: function (config) {
                $.ajax({
                    type: eventFunction.config.type,
                    contentType: eventFunction.config.contentType,
                    async: eventFunction.config.async,
                    cache: eventFunction.config.cache,
                    url: eventFunction.config.url,
                    data: eventFunction.config.data,
                    dataType: eventFunction.config.dataType,
                    success: eventFunction.ajaxSuccess,
                    error: eventFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    case 0:
                      
                        break;
                    case 1:
                        eventFunction.ResetAll();
                        break;
                    case 2:
                        eventFunction.BindUsers(data);
                        break;
                    case 3:
                        verifiedList = JSON.parse(data.d);
                        eventFunction.GetAllForVerifiying();

                    case 4:
                        eventFunction.BindIssueFromId(data.d);
                        break;

                    case 5:
                        jAlert('Verified successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        $("#issueDialog").dialog('close');
                        eventFunction.GetDetailsByUserID();
                        break;

                    case 6:
                        eventFunction.BindIssueId(data.d);
                        break;
                    case 7:
                        eventFunction.BindRoles(data);
                        eventFunction.GetAllUsers();
                        break;

                }
            },
            ajaxFailure: function () {
            },

            BindRoles: function (data) {
             
                var datas = data.d;
                $("#Roles").val(datas);
            },

            GetRoleNames: function () {
            var receiver = SageFrameUserName;
            eventFunction.config.method = "GetRoleNames";
            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            eventFunction.config.data = JSON2.stringify({ UserName: receiver, PortalID: 1 });
            eventFunction.config.ajaxCallMode = 7;
            eventFunction.ajaxCall(eventFunction.config);
            },

            GetAllUsers: function () {
                eventFunction.config.method = "GetAllUsers";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDetailsByUserID: function () {
                var receivedBy = $('#ddlRecievedBy').val();

                eventFunction.config.method = "getForVerification";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ receivedBy: receivedBy });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },


            //<<-----------------------------------BindTable Herere ------------------------------------->>


            BindUsers: function (result) {
                var datas = result.d;
                var htmls = "";
                if ($("#Roles").val() == "Super User" || $("#Roles").val() == "Site Admin") {
                $("#ddlRecievedBy").html('');            
                if (datas.UserList.length > 0) {
                    $.each(datas.UserList, function (index, value) {
                        htmls += "<option value='" + value.UserName + "'>" + value.UserName + "</option>";
                    });
                }
                $("#ddlRecievedBy").html(htmls);
                $("#ddlRecievedBy").val(SageFrameUserName);
                }
                else {
                    $("#ddlRecievedBy").html('');
                    htmls += "<option value='" + SageFrameUserName +"'>" + SageFrameUserName +"</option>";
                     
                    
                    $("#ddlRecievedBy").html(htmls);
              
                }
            },

            GetAllForVerifiying: function (result) {
                $("#Verification-list").html('');
                $("#Verified-list").html('');
                var verification = verifiedList;             
                if (verification.length > 0) {
                    $.each(verification, function (index, item) {
                        var htmls = '';
                        var search = $('#txtSearch').val().toLowerCase();
                        var date = item.IssuedOn;
                        var nowDate = new Date(parseInt(date.substr(6)));
                        if (item.ISNo.toLowerCase().includes(search) || item.StName.toLowerCase().includes(search) || item.IssToStName.toLowerCase().includes(search) || search == '') {                     
                            htmls += '<tr id="' + item.IMId + '">';
                            htmls += '<td>' + item.ISNo + '</td>';
                            htmls += '<td>' + item.StName + '</td>';
                            htmls += '<td>' + item.IssToStName + '</td>';
                            htmls += '<td>' + nowDate.format("dd/mm/yyyy") + '</td>';
                            htmls += '<td class="tdcenter">';
                            htmls += "<img src='/images/view.png' class='IssueView preview-icon' type='button'  id='" + item.IMId + "' value='View'  />";
                            htmls += '</td>';
                            htmls += '</tr>';

                            if (item.IsVerified == false) {
                                $('#Verification-list').append(htmls);
                            } else {
                                $('#Verified-list').append(htmls);
                            }
                        }
                    });
                }

                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='6' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                    $('#Verification-list').append(htmls);
                    $('#Verified-list').append(htmls);
                }

                  
            },

            BindIssueFromId: function (data) {
                $("#issueDialog").html('');
                var issuedetails = JSON.parse(data);
                if (issuedetails.length > 0) {
                    if (issuedetails[0].ITName == null) {
                        $('#issueDialog').hide();
                    }
                    else {
                    htmls = "<h5> Issue No : " + issuedetails[0].ISNo + "</h5>";
                    htmls = "<div class='dataTables_wrapper no-footer'><table id='unitTable' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Item Name</th><th>Qnty</th><th>Unit</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    $.each(issuedetails, function (index, value) {
                        htmls += "<tr class='tableItem' id=''>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.Qnty + "</td>";
                        htmls += "<td>" + value.Symbol + "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "<tr>";
                    htmls += "<td><input id='" + issuedetails[0].IMId +  "' type='button' class='btnVerify sfBtn restro-btn' value='Verify' /></td>";
                    htmls += "</tr>";
                    htmls += "</tbody>";
                    htmls += "</table>";
                    htmls += "</div>";
                    $('#issueDialog').html(htmls);
                    $("#issueDialog").dialog({
                        'title': 'Issue Details : ' + issuedetails[0].ISNo,
                        'width': 500,
                        modal: true,
                        dialogClass: 'popup-titlebg',
                        "jQueryUI": true
                    });
                }
                }

                $(".btnVerify").on('click', function () {
                    debugger;
                    var Username = SageFrameUserName;
                    var reciever = $("#ddlRecievedBy :selected").text();
                    if (reciever == Username) {
                        var imid = $(this).attr('id');
                        eventFunction.config.method = "UpdateVerification";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON.stringify({ imid: imid });
                        eventFunction.config.ajaxCallMode = 5;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                    else {
                        jAlert('Please Login from your name for Verification', 'Information!!', function () { $.alerts.dialogClass = null; });
                    }
                  
                    
                });

            },
            


            BindIssueId: function (data) {
                $("#issueDialog").html('');
                var issuedetails = JSON.parse(data);
                if (issuedetails.length > 0) {
                    if (issuedetails[0].ITName == null) {
                        $('#issueDialog').hide();
                    }
                    else {
                        htmls = "<h5> Issue No : " + issuedetails[0].ISNo + "</h5>";
                        htmls = "<div class='dataTables_wrapper no-footer'><table id='unitTable' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                        htmls += "<thead>"
                        htmls += "<tr>"
                        htmls += "<th>Item Name</th><th>Qnty</th><th>Unit</th>";
                        htmls += "</tr>"
                        htmls += "</thead>"
                        htmls += "<tbody>"
                        var count = 1;
                        $.each(issuedetails, function (index, value) {
                            htmls += "<tr class='tableItem' id=''>";
                            htmls += "<td>" + value.ITName + "</td>";
                            htmls += "<td>" + value.Qnty + "</td>";
                            htmls += "<td>" + value.Symbol + "</td>";
                            htmls += "</tr>"
                            count++;
                        });
                      
                        htmls += "</tbody>";
                        htmls += "</table>";
                        htmls += "</div>";
                        $('#issueDialog').html(htmls);
                        $("#issueDialog").dialog({
                            'title': 'Issue Details : ' + issuedetails[0].ISNo,
                            'width': 500,
                            modal: true,
                            dialogClass: 'popup-titlebg',
                            "jQueryUI": true
                        });
                    }
                }

           

            },

            ResetAll: function () {
             
                $('#ddlRecievedBy').val();

            },



        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
