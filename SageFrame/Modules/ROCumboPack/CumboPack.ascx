<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CumboPack.ascx.cs" Inherits="Modules_ROCumboPack_CumboPack" %>
<style type="text/css">
    
    
   .userlogo {
    position: absolute;
    top: 18px;
    left: 50%;
    transform: translateX(-50%);
    -webkit-transform:translateX(-50%);
    -moz-transform:translateX(-50%);
}
</style>
<script>
    $(document).ready(function () {
        $("#tabs").tabs();
        $("#tabss").tabs();
        $('#tabss').css('display', 'block');
        $(this).companyProfEDIT({
            Username: '<%=Username%>'
        });

        //var tabs = $("#tabs").tabs();
        

    });

 
</script>

<div class="RO_wrapper">
<div class="restro-title clearfix">
        <input id="btnShowForm" type="button" class="sfLocale icon-addnew sfBtn" value="Add" />
        </div>
        
        <div id="roiitemtable" style="display: none;" class="sfformwrapper">
            <table>
                <tr>
                    <td>Name<span style="color: red">*</span> :
                    </td>
                    <td>
                        <input name="txtName" type="text" class="sfInputbox" id="cmbName" />

                </td>
                <td>ComboCode<span style="color: red">*</span> :
                </td>
                <td>
                    <input type="text" name="txtComboCode" id="cmbCode" class="sfInputbox" />
                </td>
            </tr>
            <tr>
                <td>Image:
                </td>
            
                   <%-- <ul class="upload-part">
                        <li>
                            <input type="text" id="txtFile" name="path" class="sfInputbox" /></li>
                        <li>
                            <div id="fileuploaderMain">Upload</div>
                        </li>
                    </ul>--%>
                      <td>
                        <div class="sfImagewrapper" style="margin:0;">
                     <div id="dvPreviewItem">
                    </div>
                            <img id="ImgPrvs" class="userlogo" style="height:90px;width:auto;" />
                            <input type="file" id="fileImage" />
                            <input type="hidden" id="txtImage" />
                        
                        </div>

                </td>

                <td>Description:
                </td>
                <td>
                    <textarea class="sfInputbox" id="cmbDescriptoin" style="width:100%;"> </textarea>
                </td>

            </tr>
            <tr>
                <td>Start Date<span style="color: red">*</span> :
                </td>
                <td>
                    <input name="txtStart" type="text" class="endate sfInputbox" id="startDate" />

                </td>
                <td>EndDate<span style="color: red">*</span> : 
                </td>
                <td>
                    <input name="txtEnd" type="text" class="endate sfInputbox" id="endate" />

                </td>
            </tr>

            <tr>
                <td>Cost Center<span style="color: red">*</span> :
                </td>
                <td>
                    <select id="SelCostCenter" name="SelCostCenter" class="sfInputbox" style="width:150px;"></select>
                </td>
                <td>IsActive
                </td>
                <td>
                    <input type="checkbox" id="isactive" value="second_checkbox" checked="checked">
                </td>
            </tr>
        </table>
       

        <div id="AddTempTable" style="margin-top: 20px;">
            <table id='cumbotable' class='sfGridwrapper display tablee-section' cellspacing='0'>
                <thead>
                    <tr>

                        <th>Item Name
                        </th>
                        <th style="width: 100px;">Rate
                        </th>
                        <th style="width: 100px;">Qty
                        </th>
                        <th style="width: 150px;">Amount
                        </th>
                        <th>Action
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr data-id="0">

                        <td>
                            <input type="text" class="sfInputbox autopickitem" id="autopickid" style="width: 94%;" />
                        </td>

                        <td>
                            <input type="text" class="sfInputbox Rate" disabled style="width: 100px;" />

                        </td>
                        <td>
                            <input type="text" class="sfInputbox Quantity"  onkeypress='return isNumber(event)' style="width: 100px;" />
                        </td>
                        <td>
                            <input type="text" class="sfInputbox TotalPrice" disabled style="width: 150px;" />
                        </td>
                        <td>
                            <input type="button" id="btnAdd" value="Add" class="sfLocale icon-addnew sfBtn" />
                        </td>

                    </tr>
                </tbody>

            </table>
            <table style="display:block;">
                <tr>
                    <td>Items Sales Cost:
                    </td>
                    <td>
                        <input name="txtSaleCost" type="text" id="ItemsSalesCost" class="sfInputbox" readonly="readonly" />
                    </td>
                    <td>Sales Price<span style="color: red">*</span> :
                    </td>
                    <td>
                        <input name="txtSalePrice" onkeypress="return IntDec(event, this);"  type="text" class="sfInputbox" id="salesprice" />

                    </td>
                </tr>
            </table>
            <input type="button" id="btnSave" value="Save" class="sfLocale icon-save sfBtn" style="margin-bottom:15px;" />
            <input type="button" id="btnCancel" value="Cancel" class="sfLocale icon-close sfBtn" style="margin-bottom:15px;" />
        </div>
        </div>
     
        <div id="comboDialog"  title="Basic dialog"></div>

      <div id="tabss" class="tabsForlist" style="display:none;">
            <ul>
                <li ><a href="#tabs-2">Ongoing ComboList</a></li>
                <li><a href="#tabs-3">Completed ComboList</a></li>
                <li><a href="#tabs-4">UpComing ComboList</a></li>
                  <li><a href="#tabs-5">Cancelled ComboList</a></li>
            </ul>
            
               <div id="tabs-2" style="padding: 1px">
                      <div id="comboListing" class="restrowrapper"></div>
        </div>
        <div id="tabs-3" style="padding: 1px">
           <div id="InactivecomboList" class="restrowrapper"></div>
        </div>
             <div id="tabs-4" style="padding: 1px">
           <div id="UpcomingcomboList" class="restrowrapper"></div>                     
        </div>
                <div id="tabs-5" style="padding: 1px">
           <div id="CancelledcomboList" class="restrowrapper"></div>                     
        </div>
        </div>
    </div>

