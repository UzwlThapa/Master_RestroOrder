<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RestoLoyaltyView.ascx.cs" Inherits="Modules_RestoLoyalty_RestoLoyaltyView" %>

<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            UserModuleID: '<%=userModuleID %>'
        });
        $("#txtAnniversary").datepicker({
            changeYear: true,
            changeMonth: true,
            // maxDate: '0',
            yearRange: "1951:2030",
        });
        $("#tabss").tabs();
    });
</script>
<style>

    input[readonly] {
        cursor: pointer !important;
    }
</style>
    <div class="RO_wrapper">
<div class="restro-title clearfix">
<h3>Membership Form</h3>
        <input type="button" id="btnAddItem" value="Add" class="sfLocale icon-addnew sfBtn">
    </div>
    <div id="divForMember" style="display: none;">
        <div class="loyaltycheckbox drawer-radio-btn">
            Select :
                        <label class="control control--radio">
                            Customer<input type="radio" id="rdoCustomer" class="required" name="Customer" value="0" />
                            <div class="control__indicator"></div>
                        </label>
            <label class="control control--radio">
                Vendor<input type="radio" id="rdoVender" class="required" name="Customer" value="1" /><div class="control__indicator"></div>
            </label>
        </div>
        <div class="main" style="display: none;margin:15px;margin-bottom:0px;">
            <table>
                <tr>
                    <td><span class="custo">First Name :</span>
                        <span class="vend" style="display: none;">Name :</span>
                    </td>
                    <td>
                        <input type="text" id="txtFirstName" class="sfInputbox " name="FirstName" />
                    </td>
                    <td class="custo">Last Name :
                    </td>
                    <td class="custo">
                        <input type="text" id="txtLastName" class="sfInputbox " name="LastName" />
                    </td>
                </tr>
                <tr>
                    <td>Address :
                    </td>
                    <td>
                        <input type="text" id="txtAddress" class="sfInputbox " name="Address" />
                    </td>

                    <td>City :
                    </td>
                    <td>
                        <input type="text" id="txtCity" class="sfInputbox " name="City" />
                    </td>
                </tr>
                <tr>
                    <td>Country :
                    </td>
                    <td>
                        <input type="text" id="txtCountry" class="sfInputbox " name="Country" />
                    </td>

                    <td class="custo">Tel(Home) :
                    </td>
                    <td class="custo">
                        <input type="text" id="txtPhoneHome" class="sfInputbox " name="PhoneHome" />
                    </td>
                </tr>
                <tr>
                    <td>Tel(Work) :
                    </td>
                    <td>
                        <input type="text" id="txtPhoneWork" class="sfInputbox " name="txtPhoneWork" />
                    </td>
                    <td>Mobile :
                    </td>
                    <td>
                        <input type="text" id="txtPhoneMobile" class="sfInputbox " name="PhoneMobile" />
                    </td>
                </tr>
                <tr>
                    <td>Email :
                    </td>
                    <td>
                        <input type="text" id="txtEmail" class="sfInputbox " name="Email" />
                    </td>
                    <td class="custo">Occupation :
                    </td>
                    <td class="custo">
                        <input type="text" id="txtOccupation" class="sfInputbox " name="Occupation" />
                    </td>
                </tr>

                <tr style="display: none;" class="custo">
                    <td>Company :
                    </td>
                    <td>
                        <input type="text" id="txtCompany" class="sfInputbox " name="Company" />
                    </td>

                    <td>Birthday :
                    </td>
                    <td>
                        <input type="text" id="txtBirthday" class="sfInputbox " name="Birthday" />
                    </td>
                </tr>
                <tr style="display: none;" class="custo">
                    <td>Anniversary :
                    </td>
                    <td>
                        <input type="text" id="txtAnniversary" class="sfInputbox" name="Anniversary" readonly="readonly" />
                    </td>
                    <td>PAN :</td>
                    <td>
                        <input type="text" id="txtCustPan" class="sfInputbox " name="CustPan" />
                    </td>
                </tr>
                <tr class="custo" style="display: none;">
                    <td>Card Number :
                    </td>
                    <td>
                        <input type="text" id="txtCardNumber" class="sfInputbox " name="CardNumber" />
                    </td>
                    <td>Date Of Issue :
                    </td>
                    <td>
                        <input type="text" id="txtDateOfIssue" class="sfInputbox " name="DateOfIssue" readonly />
                    </td>
                </tr>
                <tr class="custo">
                    <td>Date Of Expiry :
                    </td>
                    <td>
                        <input type="text" id="txtDateOfExpiry" class="sfInputbox " name="DateOfExpiry" readonly />
                    </td>

                    <td>Discount Percentage :
                    </td>
                    <td>
                        <input type="text" id="txtDiscount" class="sfInputbox " name="Discount" placeholder="percentage" />
                    </td>
                </tr>
                <tr class="vend" style="display: none;">
                    <td>PAN :</td>
                    <td>
                        <input type="text" id="txtPan" class="sfInputbox " name="pan" /></td>
                </tr>
                  <tr class="vend" style="display: none;">
                    <td>Is VAT ? :</td>
                    <td>
                        <input type="Checkbox" id="ckboxIsVAT" name="IsVAT" /></td>
                </tr>
                <tr><td></td><td><input type="button" id="btnSaveMembershipApplication" value="Save" class="sfLocale icon-save sfBtn" />
            <input type="button" id="btnCancelItem" class="sfLocale icon-close sfBtn" value="Cancel"></td></tr>
            </table>
            
        </div>
    </div>
    <div id="tabss" style="display: none;">
        <ul>
            <li><a href="#tabs-2">CUSTOMER</a></li>
            <li><a href="#tabs-3">VENDOR</a></li>
        </ul>
        <div id="tabs-2" style="padding: 1px">
            <div id="membeshipformlist"></div>
        </div>
        <div id="tabs-3" style="padding: 1px">
            <div id="VenderListing"></div>
        </div>
    </div>
</div>
</div>
