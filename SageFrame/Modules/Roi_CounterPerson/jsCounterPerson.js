(function ($) {
    $.CounterPerson = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Roi_CounterPerson/',
                 master: '0',
             }, p);
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsCounterPerson.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },
            InitialSetup: function () {
               eventFunction.getCounterPersonList();
            },
            init: function () {
                eventFunction.InitialSetup();
                $("#btnCPAdd").click(function(){
                    eventFunction.SaveCounterPerson();
                });
            },

            getCounterPersonList: function () {
                eventFunction.config.method = "getCounterPersonList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindCounterPersonList: function (result) {
                var data = result.d;
                if (!data) return;
                var htmls = "";
                var sn = 0;
                htmls+="<table id='tableForCounterPersonList'><thead><tr><th>S.N.</th><th>Name</th><th>Code No.</th></tr></thead><tbody>";
                $.each(data, function (index, value) {
                    sn++;
                    htmls += '<tr><td>' + sn + '</td>';
                    htmls += "<td>"+value.CPName+"</td>";
                    htmls += "<td>"+value.CPCode+"</td></tr>";
                });
                htmls += '</tbody></table>';
                $("#divForList").html(htmls);
                $("#tableForCounterPersonList").dataTable({
                    "jQueryUI": false,
                    "searching": true,
                    "ordering": true,
                    "lengthChange": true,
                });
            },

            SaveCounterPerson: function () {
                var person={};
                person.CPName=$("#txtCPName").val();
                person.CPCode=$("#txtCPCode").val();
                eventFunction.config.method = "SaveCounterPerson";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ person: person });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
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
                        eventFunction.bindCounterPersonList(data);
                        break;
                    case 2:
                        jAlert('Saved Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },
        };
        eventFunction.init();
    };
    $.fn.CounterPersons = function (p) {
        $.CounterPerson(p);
    };
})(jQuery);
