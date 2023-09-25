<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucForCReport.ascx.cs" Inherits="Modules_Roi_CReport_wucForCReport" %>
<script type="text/javascript">
    $(function () {
        $(this).CReports({
        });
    });
    $(document).ready(function () {
        $("#txtDate").val($.datepicker.formatDate('yy/mm/dd', new Date()));
        $("#txtDate").datepicker({ dateFormat: 'yy/mm/dd' });
        $("input[type=radio][name=option]").click(function () {
            if (this.value == '0') {
                $(".counter").hide();
            }
            if (this.value == '1') {
                $(".counter").show();
            }
        });
    });
</script>
<div id="tabs">
          <ul>
            <li><a href="#tabs-1">Vault And Counter Report</a></li>
    
          </ul>
          <div id="tabs-1"> 
          <div style="font-family: Arial;" id="myForm">
            <div class="drawer-radio-btn">
        Select :
                         <label class="control control--radio">Vault<input type="radio" id="rdoVault" class="required" name="option" value="0" checked/> <div class="control__indicator"></div>
                        </label>
                        <label class="control control--radio">Counter<input type="radio" id="rdoCounter" class="required" name="option" value="1" /> <div class="control__indicator"></div>
                        </label>
                        </div>
<div class="vaultt-counterr">
    <ul>
       
        <li class="counter" style="display: none;"><div class="vaultt-counter-part clearfix"><label>CostCenter:</label>
                 <select id="selCostCenter" class="sfInputbox">
                <option selected disabled value="">-select- </option>
            </select></div></li>
        <li class="counter" style="display: none;">
        <div class="vaultt-counter-part clearfix">
            <label>Select Counter No. :</label>
            <select id="txtCN" class="sfInputbox">
                <option selected disabled value="">-select- </option>
            </select>
            </div>
        </li>
        <li><div class="vaultt-counter-part clearfix"><label>Date :</label>
        <input type="text" id="txtDate" class="sfInputbox"></div>
        </li>
        <li>
        <div class="vaultt-counter-part clearfix">
            <input type="button" id="btnView" value="View" class="sfBtn" style="padding:9px;">
            </div>
        </li>
    </ul>
    </div>
    <div id="DivForView"></div>

</div>
</div>
</div>
