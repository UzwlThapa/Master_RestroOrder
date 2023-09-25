<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomerDetails.ascx.cs" Inherits="Modules_AddCustomer_CustomerDetails" %>

<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            UserModuleID: '<%=userModuleID %>',
            Customer: 1
        });

        //$("#txtAnniversary").datepicker({
        //    changeYear: true,
        //    changeMonth: true,
        //    yearRange: "1951:2030",
        //});


    });
</script>
<style>
    input[readonly] {
        cursor: pointer !important;
    }

    #txtCardNumber {
        text-transform: uppercase;
    }
</style>
<div class="RO_wrapper">
    <div id="divForMember" style="display: none;">
        <div class="loyaltycheckbox drawer-radio-btn">
        </div>
        <div class="main" style="display: none; margin: 15px; margin-bottom: 0px;">
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
                        <input type="text" id="txtPhoneMobile" class="sfInputbox " onkeypress='return IntegerAndDecimal(event,this);' name="PhoneMobile" />
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

                <tr>
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
                <tr>
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
                <tr>
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
                        <input type="text" id="txtDiscount" class="sfInputbox " name="Discount" placeholder="percentage" />
                    </td>
                </tr>

                <tr class="custo">
                    <td>Date Of Expiry :
                    </td>
                    <td>
                        <input type="text" id="txtDateOfExpiry" class="sfInputbox " name="DateOfExpiry" readonly />
                    </td>

                    <td></td>
                    <td></td>
                </tr>

                <tr>
                    <td>Opening Balance :
                    </td>
                    <td>
                        <input type="text" id="txtOpeningBalance" class="sfInputbox " value="0" />
                    </td>

                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="button" id="btnSaveMembershipApplication" value="Save" class="sfLocale icon-save sfBtn" />
                        <input type="button" id="btnCancelItem" class="sfLocale icon-close sfBtn" value="Cancel"></td>
                </tr>
            </table>

        </div>
    </div>
    <div>
        <input id="btnSendSms" type="button" value="Send SMS" class="sfBtn restro-btn" style="float: right" />
        <div class="report-view">
            <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right: 2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport" style="margin-right: 2px;">Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right: 2px;">PDF</button>
            </div>
        </div>

        <div class="report-filter">
            <span>Search :</span>
            <input type="text" class="sfInputbox" id="txtSearch" />
        </div>
        <div id="membeshipformlist" class="fpwrapper"></div>
    </div>
    <div id="sendSmsDialog" style="display: none;">
        <table style="width: auto">
            <tr>
                <td>Mobile Number :</td>
                <td>
                    <input id="mobileNumber" type="text" class="sfInputbox" disabled /></td>
            </tr>
            <tr>
                <td>Message:</td>
                <td>
                    <textarea id="smsMessage" rows="3" class="sfInputbox" style="width: 300px;"></textarea></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <input id="btnSend" type="button" value="Send" class="sfBtn restro-btn" />
                    <input id="btnCancel" type="button" value="Cancel" class="sfBtn restro-btn" /></td>
        </table>

    </div>
</div>
