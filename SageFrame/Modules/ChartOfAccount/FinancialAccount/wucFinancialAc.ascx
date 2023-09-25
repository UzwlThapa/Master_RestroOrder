<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucFinancialAc.ascx.cs" Inherits="Modules_Admin_ChartOfAccount_FinancialAccount_wucFinancialAc" %>
<style>
    div#popup_container {
    top: 10%!important;
}
</style>
<script>
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();

        


        $(".DatePick").datepicker({
            dateFormat: "yy-mm-dd",
            changeMonth: true,
            changeYear: true,
        }).datepicker("setDate", "0");

        $("#OpeningDate").datepicker({
            dateFormat: "yy-mm-dd",
            changeMonth: true,
            changeYear: true,
            autoclose: true
        }).datepicker("setDate", "0");
           
    });
</script>
<style type="text/css">
    .isGrouptrue {
        font-weight: bold;
    }
</style>
<div class="RO_wrapper">
<div class="restro-title clearfix">
        <input id="btnAdd" type="button" class="sfLocale icon-addnew sfBtn restro-btn" value="Add" />
        <input id="btnMerge" type="button" style="margin-bottom:5px" class="sfLocale icon-save sfBtn restro-btn" value="Merge" />
        <input id="btnOpening" type="button" style="margin-bottom:5px" class="sfLocale sfBtn restro-btn" value="Opening Balance" />
    <input id="btnAddOpening" type="button" style="margin-bottom:5px; display: none;" class="sfLocale sfBtn restro-btn" value="Add Opening" />
        </div>
        <div class="AccountForm" style="display: none;">
            <table style="display: block;">
                <tr>
                    <td>Account Name :</td>
                    <td>
                        <input type="text" class="sfInputbox" id="txtName" name="Name" /></td>
                </tr>
                <tr >
                    <td>Parent Account :</td>
                    <td>
                        <select id="selPName" name="PName" class="sfInputbox" style="width:200px;">
                        </select></td>
                </tr>
                <tr id="divFinancialSys" style="display: none;">
                    <td>Financial System :</td>
                    <td>
                        <select id="selFinancialSys" name="FinancialSys" class="sfInputbox" style="width:200px;">
                        </select></td>
                </tr>
                <tr id="divFinancialType" >
                    <td>Account Type :</td>
                    <td>
                        <select id="selFinancialType" name="FinancialSys" class="sfInputbox" style="width:200px;">
                            <option value="1">Trading A/C </option>
                            <option value="2">Profit & Loss </option>
                            <option value="3">Balance Sheet </option>
                        </select></td>
                </tr>
                <tr id="divFinancialTypeCol">
                    <td> Debit or Credit</td>
                    <td>
                            <span style="margin-right: 5px">
                                <label>Dr.</label>
                                <input value="true" checked type="radio" name="DrCrCol" /> 
                            </span>
                            <span>
                                <label>Cr. </label>
                                <input value="false" type="radio" name="DrCrCol" />
                            </span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table id="BankAccountForm" class="sfFormwrapper" style="display: none;">
                            <tr>
                                <th>
                                    <h4>Balance Account</h4>
                                </th>
                            </tr>
                            <tr>

                                <td><label>Phone No</label>
                    
                        <input type="text" class="sfInputbox" id="txtPhoneNo" name="PhoneNo" /></td>

                                <td><label>Branch </label>
                    
                        <input type="text" class="sfInputbox" id="txtBranch" name="Branch" /></td>
                            </tr>
                            <tr>
                                <td><label>Contact Person</label>
                    
                        <input type="text" class="sfInputbox" id="txtContactPerson" name="ContactPerson" /></td>

                                <td>Is Fixed :
                    
                        <input type="checkbox"  id="chkboxIsFixed" name="" /></td>
                            </tr>
                            <tr>
                                <td><label>Interest Rate</label>
                   
                        <input type="text" class="sfInputbox" id="txtInterestRate" name="InterestRate" value="0" style="width:110px;" /></td>

                                <td><label>Open Date</label>
                    
                        <input type="text" class="sfInputbox DatePick" id="txtOpenDate" name="" style="margin:0;" /></td>
                            </tr>
                            <tr>
                                <td><label>Mature Date</label>
                    
                        <input type="text" class="sfInputbox DatePick" id="txtMatureDate" name="" style="margin:0;"/></td>

                                <td><label>Minimum Balance</label>
                    
                        <input type="text" class="sfInputbox" id="txtMinimumBalance" name="MinimumBalance" value="0" style="width:110px;"/></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                                <td>
                                    <label class="icon-save sfBtn sfLocale restro-btn" id="btnSave">
                                        Save</label>
                                    <label class="icon-close sfBtn sfLocale restro-btn" id="btnCancel">
                                        Cancel</label>
                                </td>
                </tr>
            </table>
        </div>

     <div class="MergeForm" style="display: none;">
            <table style="display: block;">

                 <tr>
                    <td>Parent Account :</td>
                    <td>
                        <select id="selMergePName" name="PName" class="sfInputbox" style="width:200px;">
                        </select></td>
                </tr>
                <tr>
                    <td>New Account Name :</td>
                    <td>
                        <input type="text" class="sfInputbox" id="txtNewMergeName" name="Name" /></td>
                </tr>
                <tr>
                    <td>Merge Account One :

                    </td>
                    <td>
                                            <span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input type="text"  class="sfInputbox selFristFinancialAc ui-autocomplete-input" name="FinancialAc" autocomplete="off">
                                            
                                            <input type="hidden" id="selMergeOneFinancialAc" class="sfInputbox hdnFirstFinancialAcID" name="AcDescription" style="width: 460px;">
                                        </td>
                </tr>
                <tr>
                    <td>Merge Account Two  :</td>
                    <td>
                                            <span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span><input type="text"  class="sfInputbox selSecondFinancialAc ui-autocomplete-input" name="FinancialAc" autocomplete="off">
                                            
                                            <input type="hidden" id="selMergeTwoFinancialAc" class="sfInputbox hdnSecondFinancialAcID" name="AcDescription" style="width: 460px;">
                                        </td>
                </tr>
                <tr>
                                <td>
                                    <label class="icon-save sfBtn sfLocale restro-btn" id="btnMergeSave">
                                        Save</label>
                                    <label class="icon-close sfBtn sfLocale restro-btn" id="btnMergeCancel">
                                        Cancel</label>
                                </td>
                </tr>
            </table>
        </div>

    <div id="OpeningBalance" style="display: none">
        <table style="display: block;">
             <tr>
                 <td>

                        <input type="hidden" id="hdnOpeningDtId"/>
                 </td>
                </tr>
             <tr>
                    <td>Ledger :</td>
                    <td>
                        <span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span>
                        <input type="text"  class="sfInputbox selOpeningFinancialAc ui-autocomplete-input" name="FinancialAc" autocomplete="off">           
                        <input type="hidden" id="selOpeningFinancialAc" class="sfInputbox hdnOpeningFinancialAcID" name="AcDescription" style="width: 460px;">

                    </td>
                </tr>
             <tr>
                    <td>Date :</td>
                    <td>
                        <input class="sfInputbox" value=0.00 id="OpeningDate" name="Name" /></td>
                </tr>
                <tr>
                    <td>Opening Balance :</td>
                    <td>
                        <input type="number" class="sfInputbox" value=0.00 id="txtOpeningBalance" name="Name" /></td>
                </tr>
                 <tr id="divOpeningBlanceCol">
                    <td> Debit or Credit</td>
                    <td>
                            <span style="margin-right: 5px">
                                <label>Dr.</label>
                                <input class="DrOpen" value="true" checked type="radio" name="DrCrOpening" /> 
                            </span>
                            <span>
                                <label>Cr. </label>
                                <input class="DrOpen" value="false" type="radio" name="DrCrOpening" />
                            </span>
                    </td>
                </tr>
            <tr>
                                <td>
                                    <label class="icon-save sfBtn sfLocale restro-btn" style="display: none" id="btnOpeningSave">
                                        Save</label>
                                     <label class="icon-save sfBtn sfLocale restro-btn" style="display: none" id="btnOpeningUpdate">
                                        Update</label>
                                    <label class="icon-close sfBtn sfLocale restro-btn" id="btnOpeningCancel">
                                        Cancel</label>
                                </td>
                </tr>
            </table>
    </div>


        <div id="divForFinancialAc" class="restrowrapper"></div>
         <div id="divForOpeningBalance" class="restrowrapper"></div>
    </div>
