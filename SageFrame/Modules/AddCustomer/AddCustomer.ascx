<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddCustomer.ascx.cs" Inherits="Modules_AddCustomer_AddCustomer" %>
<style>
    input[readonly] {
        cursor: pointer !important;
    }

    #txtCardNumber {
        text-transform: uppercase;
    }
</style>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            UserModuleID: '<%=userModuleID %>',
        });
        $("#txtAnniversary").datepicker({
            changeYear: true,
            changeMonth: true,
            // maxDate: '0',
            yearRange: "1951:2030",
        });
        $("#tabss").tabs();
        resizeIframe();
    });
</script>

<div class="RO_wrapper">
    <div id="divForMember">
        <div class="main">
            <table style="display: block;">
                <tr>
                    <td class="custo">First Name :
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
                        <input type="text" id="txtPhoneHome" class="sfInputbox " onkeypress='return IntegerAndDecimal(event,this);' name="PhoneHome" />
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
                        <input type="text" id="txtPhoneMobile" class="sfInputbox" onkeypress='return IntegerAndDecimal(event,this);' name="PhoneMobile" />
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

                <tr class="custo">
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
                <tr class="custo">
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
                <tr class="custo">
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
                    <td>LoyalityCard Type:
                    </td>
                    <td>
                        <select id="selLoyalityCardType" class="sfInputbox"></select>
                    </td>

                    <td>Discount Percentage :
                    </td>
                    <td>
                        <input type="text" id="txtDiscount" class="sfInputbox " name="Discount" onkeypress='return IntegerAndDecimal(event,this);' placeholder="percentage" />
                    </td>
                </tr>
                <tr class="custo">
                    <td>Date Of Expiry :
                    </td>
                    <td>
                        <input type="text" id="txtDateOfExpiry" class="sfInputbox " name="DateOfExpiry" readonly />
                    </td>

                    <td>Opening Balance :
                    </td>
                    <td>
                        <input type="text" id="txtOpeningBalance" class="sfInputbox " value="0" />
                    </td>
                </tr>
                <tr>
                    <td>Extra Info :
                    </td>
                    <td>
                        <textarea type="text" id="txtExtraDetail" class="sfInputbox "></textarea>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="button" id="btnSaveMembershipApplication" value="Save" class="sfLocale icon-save sfBtn" />
                    </td>
                </tr>
            </table>

        </div>
    </div>

    <div class="report-filter" style="display: none;">
        <span>Search :</span>
        <input type="text" class="sfInputbox" id="txtSearch" />
    </div>
</div>
