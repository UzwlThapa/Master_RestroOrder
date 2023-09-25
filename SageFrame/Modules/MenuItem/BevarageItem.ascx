<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BevarageItem.ascx.cs" Inherits="Modules_MenuItem_BevarageItem" %>
<style type="text/css">
    
    div#tableForItemList_wrapper.dataTables_wrapper , div#tableForInventoryList_wrapper.dataTables_wrapper{
        padding: 0;
    }

      .userlogo {
    position: absolute;
    top: 18px;
    left: 50%;
    transform: translateX(-50%);
    -webkit-transform:translateX(-50%);
    -moz-transform:translateX(-50%);
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
            // $("input[name=rdoDefaultPurchaseUnit]:checked").val()
            //$('input[type=radio]', this).get(0).checked = true;
            $('.Vitemrate').removeClass('hasDatepicker');
            $('.Vitemrate').each(function () {
                $(this).datepicker();
            });
            //$(this).append('<input type="button" id="btnForNewRow" value="Add" />');
            // $(".Vitemrate").datepicker({ dateFormat: 'yy/mm/dd' });
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
 <div class="RO_wrapper">
    <div class="restro-title clearfix">
        <input id="btnAdd" type="button" class="sfLocale icon-addnew sfBtn" value="Add" />
        </div>
        <div id="roiitemtable" style="display: none;" class="sfformwrapper">
            <table>
                <tr>
                    <td>Category Name <span style="color:red;">*</span>:
                    </td>
                    <td>
                        <select id="SelCategoryName" name="SelCategoryName" class="sfInputbox" style="width:150px;"></select>
                    </td>
                
                    <td>Item Name <span style="color:red;">*</span>:
                    </td>
                    <td>
                        <input type="text" id="txtItemName" name="txtItemName" class="sfInputbox txtItemName" />
                    </td>
                </tr>
                <tr>
                    <td>Item Code :
                    </td>
                    <td>
                        <input type="text" id="txtItemCode" name="txtItemCode" class="sfInputbox txtItemCode" />
                    </td>
               
                        <td>Image :
                    </td>

                        <td  rowspan="4">
                         <div class="sfImagewrapper" style="margin:0;">
                          <div id="dvPreviewItem">
                    </div>
                            <img id="ImgPrvs"  class="userlogo" style="height:90px;width:auto;" />
                    
                            <input type="file" id="fileImage" />
                            <input type="hidden" id="txtImage" />
                         </div>

                        </td>
                </tr>
        
                <tr>
                    <td>Is Expirable :
                    </td>
                    <td>
                        <input type="checkbox" id="chkbxIsExpirable" />
                    </td>
                </tr>
           
                <tr style="display: none;">
                    <td>Is Unit Wise Rate :
                    </td>
                    <td>
                        <input type="checkbox" id="chkbxIsUnitWiseRate" name="chkbxIsUnitWiseRate" />
                    </td>
                </tr>
                <tr>
                    <td>Cost Center <span style="color: red;">*</span>:
                    </td>
                    <td>
                        <select id="SelCostCenter" name="SelCostCenter" class="sfInputbox" style="width:150px;"></select>
                    </td>
               
                </tr>
                <tr>
                    <td>IsActive :
                    </td>
                    <td>
                        <input type="checkbox" id="chkbxIsActive" checked="checked"/>
                    </td>
                </tr>
                <tr>
                    <td>Small unit <span style="color:red;">*</span>:
                    </td>
                    <td>
                        <select id="SelSmallunit" name="SelSmallunit" class="sfInputbox" style="width:150px;"></select>
                    </td>
                    <td>Details :
                    </td>
                    <td rowspan="2">
                        <textarea id="txtDetails" class="sfInputbox" style="width:90%;height:100px"></textarea>
                    </td>
                </tr>
            
            </table>

            <table style='margin-top:10px;margin-bottom:0px;background: #F3F3F3;border-radius: 3px 3px 0px 0px;'>
                <tr>
                    <td style='width:100px;'>Extra Items : </td>
                    <td><div id="extraLists"></div></td>
                </tr>
            </table>
            <label id="btnForNewRow" class="sfLocale icon-addnew sfBtn" style="display: none;">Add</label>
            <table style="width: 100%; display:none; " class="sfGridwrapper display dataTable no-footer" >
                <tr style="">
                    <td>
                        <span style="padding-right: 15px;"><b>Is Extra?</b></span><input type="checkbox" id="chkbxIsExtra" />
                    </td>
                </tr>
                <tr class="ForExtra" style="">
                    <td>
                        <table id="tableForExtra" style="margin: 0;">
                            <thead>
                                <tr>
                                    <th>Item Name</th>
                                    <th>Price</th>
                                    <th>Is Active</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <input type="text" class="txtExtraItemName" style="width: 100px;" />
                                    </td>
                                    <td>
                                        <input type="text" class="txtExtraIPrice" style="width: 100px;" />
                                    </td>
                                    <td>
                                        <input type="checkbox" class="txtExtraIsActive" />
                                    </td>
                                    <td>
                                        <input type="button" id="btnForRemoveRowExtra" value="Remove" class="sfBtn icon-close" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr class="ForExtra" style="">
                    <td>
                        <label id="btnForNewRowExtra" class="sfLocale icon-addnew sfBtn">Add</label>
 
                    </td>
                </tr>
            </table>
            <div id="divForIngredient">
                    <h5>Ingredient Entry</h5>
                    <table id="tableForIngredient" style="margin: 0;display:block;background: #F3F3F3;border-radius: 3px 3px 0px 0px;" class="sfGridwrapper display dataTable no-footer">
                       
                            <tr>
                                <td style="background: #F3F3F3;">
                                <label>Ingredient</label>
                                    <input type="text" class="sfInputbox txtIngredient" style="width: 300px;" />
                                    <input type="hidden" class="hdnIngredientID" />
                                </td>
                    
                     
                            </tr>
                    
                    </table>
            </div>

                 <div id="divForSubMenu">
                    <h5>Sub Menu</h5>
                    <table id="tableForSubMenu" style="margin: 0;display:block;background: #F3F3F3;border-radius: 3px 3px 0px 0px;" class="sfGridwrapper display dataTable no-footer">
                        <thead>
                            <tr>
                                <th>MenuSub</th>
                                <th>ML</th>
                                <th>Rate</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="background: #F3F3F3;">
                                    <input type="text" class="sfInputbox txtMenuSub" style="width: 300px;" />
                                    <input type="hidden" class="hdnMenuSubID" />
                                </td>
                    
                                <td style="background: #F3F3F3;">
                                    <input type="text" class="sfInputbox txtMilliliter" onkeypress='return isNumber(event);' style="width: 100px;" />
                                 
                                </td>

                                <td style="background: #F3F3F3;">
                                    <input type="text" class="sfInputbox txtRate" onkeypress='return IntegerAndDecimal(event,this);' style="width: 100px" />
                                </td>
                                <td style="background: #F3F3F3;">
                                    <label class="sfLocale icon-addnew sfBtn restro-btn addSubMenu"></label>
                                </td>
                            </tr>
                        </tbody>
                    </table>
            </div>
            <table id="roiitemtable1" style="margin: 0;">
                <tr>
                    <td>
                        <label id="saveItems" class="sfLocale icon-save sfBtn restro-btn">Save</label>
                        <label id="CancelItems" class="sfLocale icon-close sfBtn restro-btn">Cancel</label>
                    </td>
                </tr>
            </table>
        </div>
        <div id="DivForItemlist"></div>
        <div id="DivForViewItemByID" style="display: none;"></div>
    </div>