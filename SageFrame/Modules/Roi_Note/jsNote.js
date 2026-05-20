(function ($) {
    $.Note = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Roi_Note/'
             }, p);
        var v = 0;
        //var ArrayNote = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceForNote.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0


            },
            InitialSetup: function () {
                eventFunction.getNoteList();
            },
            init: function () {
                eventFunction.InitialSetup();
                $("#btnSaveNote").click(function () {
                    eventFunction.saveNote();
                });
            },

            getNoteList: function () {
                eventFunction.config.method = "getNoteList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindNoteList: function (result) {
                var data = result.d;
                var htmls = "";
                htmls+="<table><thead><tr><th>Note</th><th>isCoin?</th><th>Delete</th></tr></thead><tbody>"
                $.each(data, function (index, value) {
                    htmls += "<tr><td>" + value.Note + "</td><td>" + value.iscoins + "</td>";
                    htmls += "<td>" + "<img src='/images/delete.png' class='ItemDelete' type='button'  id=_" + value.NoteID + " value='Delete' /></td></tr>";
                });
                htmls += "</tbody></table>";
                $("#divForNoteList").html(htmls);
            },

            CheckIfCoin: function () {
                if ($('#ckbIsCoin').prop("checked") == true) {
                    return true;
                }
                else {
                    return false;
                }
            },
            saveNote: function () {
                var note = $("#txtNote").val();
                var isCoin = eventFunction.CheckIfCoin();
                eventFunction.config.method = "saveNote";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ note: note, iscoin: isCoin });
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
                        eventFunction.bindNoteList(data);
                        break;
                    case 2:
                        jAlert('Saved Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.InitialSetup();
                        break;

                }
            },
            ajaxFailure: function () {
            },
            reset: function () {
                $("#txtNote").val("");
                $('#ckbIsCoin').prop("");
            },
        };
         eventFunction.init();
    };
    $.fn.Notes = function (p) {
        $.Note(p);
    };
})(jQuery);
