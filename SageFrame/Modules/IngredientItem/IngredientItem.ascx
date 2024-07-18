<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IngredientItem.ascx.cs" Inherits="Modules_IngredientItem_IngredientItem" %>

<style type="text/css">
    
    div#tableForItemList_wrapper.dataTables_wrapper , div#tableForInventoryList_wrapper.dataTables_wrapper{
        padding: 0;
    }

    .userlogo {
    position: absolute;
    top: 18px;
    left: 50%;
    transform: translateX(-50%);
    -webkit-transform: translateX(-50%);
    -moz-transform: translateX(-50%);
}
</style>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            userName: '<%=userName%>',
        });



        $("#chkbxIsExtra").click(function () {
            if ($("#chkbxIsExtra").is(':checked') == true) {
                $(".ForExtra").show();
            } else {
                $(".ForExtra").hide();
            }
        });

        $(".Vitemrate").datepicker({ minDate: 0 }).datepicker("setDate", new Date());

  
        $("#btnForNewRowExtra").click(function () {
            $("#tableForExtra").each(function () {
                var tds = '<tr>';
                jQuery.each($('tr:last td', this), function () {
                    tds += '<td>' + $(this).html() + '</td>';
                });
                tds += '</tr>';
                if ($('tbody', this).length > 0) {
                    $('tbody', this).append(tds);
                } else {
                    $(this).append(tds);
                }
            });
        });

        $("#tableForExtra").on("click", "#btnForRemoveRowExtra", function () {
            var rowCount = $('#tableForExtra tr').length;
            if (rowCount > 2)
                $(this).closest('tr').remove();
            else
                jAlert('You cannot remove all the row of table!', 'Alert!!', function () { $.alerts.dialogClass = null; });
        });

        $("#btnForNewRow").click(function () {
            //$("#btnForNewRow").remove();
            $("#tableForExtra").each(function () {
                var tds = '<tr>';
                jQuery.each($('tr:last td', this), function () {
                    tds += '<td>' + $(this).html() + '</td>';
                });
                tds += '</tr>';
                if ($('tbody', this).length > 0) {
                    $('tbody', this).append(tds);
                } else {
                    $(this).append(tds);
                }
            });
            $('input[type=radio]').removeAttr("checked");
            $('input[type=radio]').attr('checked', 'checked');

            $('.Vitemrate').removeClass('hasDatepicker');
            $('.Vitemrate').each(function () {
                $(this).datepicker();
            });

        });

        $("#tableForSubtable").on('click', "#btnForRemoveRow", function () {
            var rowCount = $('#tableForSubtable tr').length;
            if (rowCount > 2)
                $(this).closest('tr').remove();
            else
                jAlert('You cannot remove all the row of table!', 'Alert!!', function () { $.alerts.dialogClass = null; });
        });

        $("#fileuploaderMain").on('click', function () {

            $("#fileuploaderMain").uploadFile({
                url: SageFrameHostURL + "/Modules/ROI_Item/ImageUpload.ashx",
                dragDrop: false,
                fileName: "myfile",
                showDelete: true,
                showDownload: true,
                statusBarWidth: 600,
                maxFileCount: 1,
                maxFileSize: 512000,

                onSuccess: function (files, data, xhr) {
                    $(".ajax-file-upload").hide();
                    $(".less").hide();
                    var filename = (data);
                    $("#txtImage").val(filename);
                    $("#ImgPrvs").attr("src", "/Modules/ROI_Item/ImageItem/" + filename);
                    //console.log(filename);
                },
                deleteCallback: function (data, pd) {
                    $(".ajax-file-upload").show();
                    $(".ajax-file-upload-statusbar").hide();
                    $("#txtImage").val("");
                    $("#ImgPrvs").attr("src", "");
                }
            });
        });
    });
</script>

<div id="tabs-2" class="RO_wrapper">
<div class="restro-title clearfix">
        <input id="btnInventoryAdd" type="button" class="sfLocale icon-addnew sfBtn" value="Add" /></div>
        <div id="addInventoryTable" style="display: none;" class="sfformwrapper">
            <table>
                <tr>
                    <td>Category Name <span style="color:red;">*</span>:
                    </td>
                    <td>
                        <select id="SelInvCategoryName" name="SelInvCategoryName" class="sfInputbox" style="width:150px;"></select>
                    </td>
                
                    <td>Item Name <span style="color:red;">*</span>:
                    </td>
                    <td>
                        <input type="text" id="txtInvItemName" name="txtInvItemName" class="sfInputbox" />
                    </td>
                </tr>
                <tr>
                    <td>Item Code :
                    </td>
                    <td>
                        <input type="text" id="txtInvItemCode" name="txtInvItemCode" class="sfInputbox" />
                    </td>
               
                    <td>Image :
                    </td>
                        <td rowspan="4">
                        <div class="sfImagewrapper" style="margin:0;">
                     <div id="dvPreviewItem">
                    </div>
                            <img id="InvImgPrvs" class="userlogo" style="height:90px;width:auto;"  />
                           
                            <input type="file" id="fileInvImage" />
                            <input type="hidden" id="txtInvImage" />
                            </div>
                        </td>
                </tr>

                <%--Added for HS Code--%>
                <tr>
                    <td>HS Code :</td>
                    <td>
                         <input type="text" id="txtInvHsCode" name="txtInvHsCode" class="sfInputbox" />
                    </td>
                </tr>

                <tr>
                    <td>Is Expirable :
                    </td>
                    <td>
                        <input type="checkbox" id="chkbxInvIsExpirable" />
                    </td>
                </tr>
                <tr>
                    <td>Cost Center <span style="color: red;">*</span>:
                    </td>
                    <td>
                        <select id="SelInvCostCenter" name="SelInvCostCenter" class="sfInputbox" style="width:150px;"></select>
                    </td>
                </tr>
                <tr>
                    <td>IsActive :
                    </td>
                    <td>
                        <input type="checkbox" id="chkbxInvIsActive" checked="checked"/>
                    </td>
                </tr>
                <tr>
                    <td>Small unit <span style="color:red;">*</span>:
                    </td>
                    <td>
                        <select id="SelSmallunit" name="SelInvSmallunit" class="sfInputbox" style="width:150px;"></select>
                    </td>
                    <td>Details :
                    </td>
                    <td rowspan="3">
                        <textarea id="txtInvDetails" class="sfInputbox" style="width:90%;height:80px"></textarea>
                    </td>
                </tr>
<tr>
                   <td></td>
                   <td></td>
                   <td></td>
                   <td>
                   <input class="sfBtn restro-btn" type="button" id="btnAddItems" value="Add Min. Stock for Store" />
                   </td>
               </tr>
            </table>
               <div id="AddTempTable" style="margin-top: 20px;">
                <table id='purchaseTempTable' class='sfGridwrapper display tablee-section' cellspacing='0'>
                    <thead>
                        <tr>                            
                            <th>StoreName</th>
                            <th>Unit</th>
                            <th>Quantity</th>
                            <th>Action</th>
                          
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <table id="actionInvTable" style="margin: 0;">
                <tr>
                    <td>
                        <label id="saveInvItems" class="sfLocale icon-save sfBtn restro-btn">Save</label>
                        <label id="CancelInvItems" class="sfLocale icon-close sfBtn restro-btn">Cancel</label>
                    </td>
                </tr>
            </table>
        </div>


        <div id="DivGetInventoryList"></div>
        <%--<div id="DivGetInventoryByID" style="display: none;"></div>--%>
        <div id="DivStoreItem" class="ui-front" style="display: none;">
                    <table>
        
                            <tr>
                        <td>
                           Store
                        </td>
                        <td>
                            <select id="SelStoreName" name="SelStoreName" class="sfInputbox" style="width:150px;"></select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Unit:
                        </td>
                        <td>
                          <select id="SelUnit" name="SelUnit" class="sfInputbox" style="width:150px;"></select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Quantity
                        </td>
                        <td>
                              <input type="text" id="txtValue" name="txtValue" onkeypress="return IntegerAndDecimal(event,this);"  class="sfInputbox" />
                        </td>
                    </tr>
                   
                        </table>
              <input class="sfLocale icon-Add sfBtn restro-btn" type="button" id="btnPurchaseAdd" value="Add" />
      <%--      <input class="sfLocale icon-close sfBtn" type="button" id="btnPurchaseClose" value="Close" />--%>
            </div>
      
    </div>
          
    <div id="DivForViewItemByID" style="display: none;"></div>