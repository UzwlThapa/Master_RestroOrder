<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddVendor.ascx.cs" Inherits="Modules_AddVendor_AddVendor" %>

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
        resizeIframe();
    });
</script>
<style>

    input[readonly] {
        cursor: pointer !important;
    }
</style>
    <div class="RO_wrapper">
    <div id="divForMember">
        <div class="main" style="margin:15px;margin-bottom:0px;">
            <table style="display:block;">
                <tr>
                    <td>
                        <span class="vend">Name :</span>
                    </td>      
                    <td>
                        <input type="text" id="txtFirstName" class="sfInputbox " name="FirstName" />
                    </td>
               
                    <td>Address :
                    </td>
                    <td>
                        <input type="text" id="txtAddress" class="sfInputbox " name="Address" />
                    </td>
                     </tr>
                <tr>

                    <td>City :
                    </td>
                    <td>
                        <input type="text" id="txtCity" class="sfInputbox " name="City" />
                    </td>
               
                    <td>Country :
                    </td>
                    <td>
                        <input type="text" id="txtCountry" class="sfInputbox " name="Country" />
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
                
                    <td>PAN :</td>
                    <td class="vend">
                        <input type="text" id="txtPan" class="sfInputbox " name="pan" /></td>
                </tr>
                <tr >
                    <td>Opening Balance :
                    </td>
                    <td>
                        <input type="text" id="txtOpeningBalance" class="sfInputbox " value="0" />
                    </td>

                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                  <tr class="vend">
                    <td>Is VAT ? :</td>
                    <td>
                        <input type="Checkbox" id="ckboxIsVAT" name="IsVAT" /></td>
                </tr>

                <tr>
                    <td></td>
                    <td>
                        <input type="button" id="btnSaveMembershipApplication" value="Save" class="sfLocale icon-save sfBtn" />
                        <%--<input type="button" id="btnCancelItem" class="sfLocale icon-close sfBtn" value="Cancel">--%>
                    </td>
                </tr>
            </table>
            
        </div>
    </div>
</div>