(function ($) {
    var tabs = $("#tabs").tabs();
    $.fiscalYearSetting = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 Username: '',
                 ModulePath: '/Modules/Admin/FiscalYearSetting/'
             }, p);
        var v = 0;
        var ArrayData = [];
        var arraycount = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0,
                Username: p.Username
            },
            InitialSetup: function () {
                jQuery("#txtStartDate").datepicker({
                    dateFormat: 'mm/dd/yy',
                    changeMonth: true,
                    changeYear: true,
                    onClose: function (selectedDate) {
                        jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
                    }
                });
                jQuery("#txtEndDate").datepicker({
                    dateFormat: 'mm/dd/yy',
                    changeMonth: true,
                    changeYear: true,
                    onClose: function (selectedDate) {
                        jQuery("#txtStartDate").datepicker("option", "maxDate", selectedDate);
                    }
                });
                $('#btnAddfy').click(function () {
                    eventFunction.ResetAll();
                    $('#frmInput tr:eq(0)').hide();
                    $('#frmInput').show();
                    $('#btnAddfy , .restrowrapper').hide();
                });
                $('#btnPurchaseCancel').click(function () {
                    $('#frmInput').hide();
                    $('#btnAddfy , .restrowrapper').show();
                });
                $('#btnPurchaseAdd').click(function () {
                    if (eventFunction.validation()) {
                        eventFunction.saveFiscal();
                    }
                });
                $('#tblFiscalData').on('click', '.icon-edit', function (x) {
                    $('#frmInput tr:eq(0)').show();
                    eventFunction.ResetAll();
                    $('#frmInput').show();
                    $('#btnAddfy , .restrowrapper').hide();
                    var row = $(this).parents('tr');
                    $('#txtFyId').val(row.attr('data'));
                    $('#txtFyName').val(row.find('td:eq(1)').text());
                    $('#txtStartDate').val(row.find('td:eq(2)').text().split(' ')[0])
                    $('#txtEndDate').val(row.find('td:eq(3)').text().split(' ')[0])
                    $('#chkIsActive').prop('checked', row.find('td:eq(4)').text())
                });
            },
            validation: function () {
                var valid = true;
                if ($('#txtFyName').val().trim().length <= 3) {
                    jAlert("Enter valid Year Name. ", "Warning!!");
                    return false;
                }
                if ($('#txtStartDate').val().trim().length <= 7) {
                    jAlert("Enter valid Start Date.", "Warning!!");
                    return false;
                }
                if ($('#txtEndDate').val().trim().length <= 7) {
                    jAlert("Enter valid End Date.", "Warning!!");
                    return false;
                }
                return valid;
            },
            saveFiscal: function () {
                var info = {
                    AddedBy: eventFunction.config.Username,
                    fyId: $('#txtFyId').val(),
                    fyName: $('#txtFyName').val(),
                    StartDate: $('#txtStartDate').val(),
                    EndDate: $('#txtEndDate').val(),
                    isActive: $('#chkIsActive').prop('checked'),
                };
                eventFunction.config.method = "SaveFiscalYear";
                $('.restrowrapper').show();
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ info: info });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            init: function () {
                eventFunction.InitialSetup();
                eventFunction.GetItem();
            },
            BindData: function (data) {
                var html = '';
                $.each(data, function (x, d) {
                    var c = x % 2 == 0 ? "even" : "odd";
                    html += '<tr class=' + c + ' data=' + d.fyId + '><td>' + d.fyId + '</td><td>' + d.fyName + '</td><td>' + d.StartDate + '</td><td>' + d.EndDate + '</td><td>' + d.isActive + '</td><td><a class="icon-edit"></a></td></tr>';
                });
                $('#tblFiscalData tbody').html(html);
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
                        eventFunction.BindData(data.d);
                        break;
                    case 1:
                        jAlert("Fiscal Year Save Successfully.", "Information");
                        $('#frmInput').hide();
                        $('#btnAddfy').show();
                        eventFunction.ResetAll();
                        eventFunction.GetItem();
                        break;
                }
            },
            ajaxFailure: function (data) {
                jAlert("Somethings went wrong.", "Error !!");
            },
            GetItem: function () {
                eventFunction.config.method = "GetAllFiscalYear";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            ResetAll: function () {
                $('#txtFyId').val(0);
                $('#txtFyName').val('');
                $('#txtStartDate').val('');
                $('#txtEndDate').val('');
                $('#chkIsActive').prop('checked', true);
                $('#btnPurchaseAdd').text('Add');
            }
        };
        eventFunction.init();
    };
    $.fn.FiscalYearEDIT = function (p) {
        $.fiscalYearSetting(p);
    };
})(jQuery);