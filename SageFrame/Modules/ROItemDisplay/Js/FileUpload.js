//$(document).on('click', '#btnUpload', function () {
//    var fileUpload = $("#fileUpload").get(0);
//    var file = fileUpload.files[0];
//    if (file != null) {
//        if (FileUploadChecker == false) {
//            var datas = new FormData();
//            datas.append('file', file);
//            //$('#btnUpImageFile').attr('disabled', 'disabled');
//            //$('#btnUpDocFile').attr('disabled', 'disabled');
//            UploadFile(datas);
//        }
//        else
//            alert("Your File Already Uploaded");
//    }
//    else alert("Please chose image first.");


//});

//function UploadFile(datas) {
//    $.ajax({
//        url: "/Modules/ImsVendor/FileUploadHandler.ashx",
//        type: "POST",
//        data: datas,
//        contentType: false,
//        processData: false,
//        success: function (result) {
//            alert(result);
//            DocName = result;
//            //$('#btnUpImageFile').removeAttr('disabled');
//            //$('#btnUpDocFile').removeAttr('disabled');
//           // FileUploadChecker = true;

//        },
//        error: function (err) {
//            FileUploadChecker = false;
//            alert(err);
//        }
//    });

//};
