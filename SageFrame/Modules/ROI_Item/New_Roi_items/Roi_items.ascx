<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Roi_items.ascx.cs" Inherits="Modules_ROI_Item_Roi_items" %>

<style type="text/css">
    
    div#tableForItemList_wrapper.dataTables_wrapper , div#tableForInventoryList_wrapper.dataTables_wrapper{
        padding: 0;
    }
</style>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            userName: '<%=userName%>',
        });
          resizeIframe();



        $("#chkbxIsExtra").click(function () {
            if ($("#chkbxIsExtra").is(':checked') == true) {
                $(".ForExtra").show();
            } else {
                $(".ForExtra").hide();
            }
        });

        //$('.Vitemrate').datepicker();
        $(".Vitemrate").datepicker({ minDate: 0 }).datepicker("setDate", new Date());

        //if ($(".Vitemrate").val() == "")
        //    $(".Vitemrate").datepicker({ dateFormat: 'yy/mm/dd' }).datepicker("setDate", "0");
        //else
        //    $(".Vitemrate").datepicker({ dateFormat: 'yy/mm/dd' });



        $("#btnAdd").click(function () {
            $("#btnAdd").hide();
            $("#DivForItemlist").hide();
            $("#roiitemtable").show();
        });

        $("#btnInventoryAdd").click(function () {
            $("#btnInventoryAdd").hide();
            $("#DivGetInventoryList").hide();
            $("#addInventoryTable").show();
        });

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
<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Menu</a></li>
       <%-- <li><a href="#tabs-2">Item Group</a></li>--%>
        <li><a href="#tabs-2">Inventory</a></li>
    </ul>
    <div id="tabs-1">
        <input id="btnAdd" type="button" class="sfLocale icon-addnew sfBtn" value="Add" />
        <div id="roiitemtable" style="display: none;" class="sfformwrapper">
            <table>
                <tr>
                    <td>Category Name <span style="color:red;">*</span>:
                    </td>
                    <td>
                        <select id="SelCategoryName" name="SelCategoryName" class="sfInputbox" style="width: 200px;"></select>
                    </td>
                
                    <td>Item Name <span style="color:red;">*</span>:
                    </td>
                    <td>
                        <input type="text" id="txtItemName" name="txtItemName" class="sfInputbox" />
                    </td>
                </tr>
                <tr>
                    <td>Item Code :
                    </td>
                    <td>
                        <input type="text" id="txtItemCode" name="txtItemCode" class="sfInputbox" />
                    </td>
               
                        <td>Image :
                    </td>
                        <td  rowspan="4">
                            <img id="ImgPrvs" height="150px" width="225px" />
                            <br />
                            <input type="file" id="fileImage" />
                            <input type="hidden" id="txtImage" />
                           <%--<input type="file" id="fupload" />--%>
                            <%--<input type="text" id="txtImage" class="sfInputbox" />--%>
                           <%-- <div id="btnUpload" class="sfBtn">Upload</div>--%>
                        <%--<label class="less">(*Image Size must be less then 0.5 MB )</label>--%>

                        <!-- <td><img id="imgprv" src="#" style="Height:90px; Width:75px" alt="your image"/></td> -->
                       <%-- <img id="imgprv" style="height: 90px; width: 75px" alt="your image" />
                        <input type="hidden" id="hdnOfficInfoLogo" />
                        <input type="button" id="btnUpload" value="Upload Selected File" class="sfBtn" />
                        <input type="hidden" id="hdnOfficInfoID" />--%>

                        </td>
                </tr>
                <%--<tr>
                    <td>Image :
                    </td>
                    <td style="background: #FFFFFF;">
                        <img id="ImgPrvs" height="150px" width="225px" />
                        <br />
                        <input type="text" id="txtImage" class="sfInputbox" />
                        <div id="fileuploaderMain" class="sfBtn">Upload</div>
                        <label class="less">(*Image Size must be less then 0.5 MB )</label>
                    </td>
                </tr>--%>
                <%--<tr>
                    <td>Is Menu :
                    </td>
                    <td>
                        <input type="checkbox" id="chkbxIsMenu" checked="checked"/>
                    </td>
                </tr>--%>
                <tr>
                    <td>Is Expirable :
                    </td>
                    <td>
                        <input type="checkbox" id="chkbxIsExpirable" />
                    </td>
                </tr>
                <%--<tr>
                    <td>Is Inventory Item :
                    </td>
                    <td>
                        <input type="checkbox" id="chkbxIsProductMaterial" />
                    </td>
                </tr>--%>
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
                        <select id="SelCostCenter" name="SelCostCenter" class="sfInputbox" style="width: 200px;"></select>
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
                        <select id="SelInvSmallunit" name="SelSmallunit" class="sfInputbox" style="width: 200px;"></select>
                    </td>
                    <td>Details :
                    </td>
                    <td rowspan="2">
                        <textarea id="txtDetails" class="sfInputbox" style="width:90%;height:100px"></textarea>
                    </td>
                </tr>
                 <%--<tr class="minStock" style="display:none;">
                    <td>Min. Stock Quantity :
                    </td>
                    <td>
                        <input type="text" id="txtMinStkQnty" value="0" />
                    </td>
                </tr>
                 <tr class="minStock" style="display:none;">
                    <td>Min. Stock Unit :
                    </td>
                    <td>
                        <select id="SelMinStkUnit" name="" class="sfInputbox" style="width: 200px;"></select>
                    </td>
                </tr>--%>
            </table>

            <table id="tableForSubtable" class="sfGridwrapper display dataTable no-footer" style="border-collapse: collapse; border: none;display:block;">
                <thead>
                    <tr style="color: White; background-color: #990000; font-weight: bold;">
                       <%-- <th>Large Unit</th>
                        <th>Quantity</th>
                        <th>Is Default Purchase Unit</th>
                        <th>Is Default Sales Unit</th>--%>
                        <th>Sales Rate(*Excluded Tax)</th>
                        <th>Valid From</th>
                       
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <input type="text" class="sritemrate" style="width: 100px;" name="sritemrate" placeholder="0" />
                            <label></label>
                        </td>
                        <td>
                            <input type="text" class="Vitemrate" style="width: 100px;" name="Vitemrate" readonly="readonly" />
                        </td>
                       <!--  <td>
                            <input type="button" id="btnForRemoveRow" style="display: none;" value="Remove" />
                        </td> -->
                    </tr>
                </tbody>
            </table>
            <table style='margin-top:10px;margin-bottom:0px;'>
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
                        <!--  <label id="btnForCancelExtra" class="sfLocale icon-close sfBtn">Cancel</label> -->
                    </td>
                </tr>
            </table>
            <br />
            <br />
            <div id="divForIngredient">
                    <h3>Ingredient Entry</h3>
                    <table id="tableForIngredient" style="margin: 0;display:block;" class="sfGridwrapper display dataTable no-footer">
                        <thead>
                            <tr>
                                <th>Ingredient</th>
                               <%-- <th class="unit">Units</th>--%>
                                <th>Quantity</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <input type="text" class="sfInputbox txtIngredient" style="width: 300px;" />
                                    <input type="hidden" class="hdnIngredientID" />
                                </td>
                                <%-- <td>
                            <label class="lblIngredientUnit"></label>
                        </td>--%>
                                <%--<td class="unit">
                                    <select id="selIngredientUnit" class="sfInputbox" name="quentity" style="width: 100px;">
                                    </select>
                                </td>--%>
                                <td>
                                    <input type="text" class="txtIngredientQuantity" style="width: 100px;" />
                                    <input type="hidden" class="hdnItemID" value="" />
                                </td>
                                <td>
                                    <label class="sfLocale icon-addnew sfBtn addTextboxIngredient"></label>
                                </td>
                            </tr>
                        </tbody>
                    </table>
            </div>
            <table id="roiitemtable1" style="margin: 0;">
                <tr>
                    <td>
                        <label id="saveItems" class="sfLocale icon-save sfBtn">Save</label>
                        <label id="CancelItems" class="sfLocale icon-close sfBtn">Cancel</label>
                    </td>
                </tr>
            </table>
        </div>
        <div id="DivForItemlist"></div>
        <%--<div id="DivForViewItemByID" style="display: none;"></div>--%>
    </div>

    <%--<div id="tabs-2">
        <table style="display: block;">
            <tr>
                <td>
                    <label>Group Name :</label>
                </td>
                <td>
                    <input type="text" id="txtGroupName" class="sfInputbox" />
                </td>
            </tr>
            <tr>
                <td>
                    <label>Group Code :</label>
                </td>
                <td>
                    <input type="text" id="txtGroupCode" class="sfInputbox" />
                </td>
            </tr>
            <tr>
                <td>
                    <label>Items :</label>
                </td>
                <td>
                    <table id="divForAdd">
                        <tr>
                            <td>
                                <input type="text" class='txtItem' />
                                <input type="hidden" class="hdnItemID" />
                               
                                <label class="sfLocale icon-addnew sfBtn addTextbox"></label>
                               
                            </td>
                        </tr>
                    </table>
                    
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <label id="saveGroupItem" class="sfLocale icon-save sfBtn">Save</label>
                    <label id="CancelGroupItem" class="sfLocale icon-close sfBtn">Cancel</label>
                </td>
            </tr>
        </table>

        <div id="divForListing"></div>
    </div>--%>

    <div id="tabs-2">
        <input id="btnInventoryAdd" type="button" class="sfLocale icon-addnew sfBtn" value="Add" />
        <div id="addInventoryTable" style="display: none;" class="sfformwrapper">
            <table>
                <tr>
                    <td>Category Name <span style="color:red;">*</span>:
                    </td>
                    <td>
                        <select id="SelInvCategoryName" name="SelInvCategoryName" class="sfInputbox" style="width: 200px;"></select>
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
                            <img id="InvImgPrvs" height="150px" width="225px" />
                            <br />
                            <input type="file" id="fileInvImage" />
                            <input type="hidden" id="txtInvImage" />

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
                        <select id="SelInvCostCenter" name="SelInvCostCenter" class="sfInputbox" style="width: 200px;"></select>
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
                        <select id="SelSmallunit" name="SelInvSmallunit" class="sfInputbox" style="width: 200px;"></select>
                    </td>
                    <td>Details :
                    </td>
                    <td rowspan="3">
                        <textarea id="txtInvDetails" class="sfInputbox" style="width:90%;height:150px"></textarea>
                    </td>
                </tr>
<%--                 <tr class="minStock">
                    <td>Min. Stock Quantity :
                    </td>
                    <td>
                        <input type="text" id="txtMinStkQnty" value="0" />
                    </td>
                </tr>
                 <tr class="minStock">
                    <td>Min. Stock Unit :
                    </td>
                    <td>
                        <select id="SelMinStkUnit" name="" class="sfInputbox" style="width: 200px;"></select>
                    </td>
                </tr>--%>
               <tr>
                   <td></td>
                   <td></td>
                   <td></td>
                   <td>
                   <input class="sfLocale icon-Add sfBtn" type="button" id="btnAddItems" value="Add Min. Stock for Store" />
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
                        <label id="saveInvItems" class="sfLocale icon-save sfBtn">Save</label>
                        <label id="CancelInvItems" class="sfLocale icon-close sfBtn">Cancel</label>
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
                            <select id="SelStoreName" name="SelStoreName" class="sfInputbox" style="width: 200px;"></select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Unit:
                        </td>
                        <td>
                          <select id="SelUnit" name="SelUnit" class="sfInputbox" style="width: 200px;"></select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Quantity
                        </td>
                        <td>
                              <input type="text" id="txtValue" name="txtValue" class="sfInputbox" />
                        </td>
                    </tr>
                   
                        </table>
              <input class="sfLocale icon-Add sfBtn" type="button" id="btnPurchaseAdd" value="Add" />
      <%--      <input class="sfLocale icon-close sfBtn" type="button" id="btnPurchaseClose" value="Close" />--%>
            </div>
      
    </div>
          
    <div id="DivForViewItemByID" style="display: none;"></div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

    });
</script>