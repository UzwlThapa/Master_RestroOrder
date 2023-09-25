<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LoyalityCardType.ascx.cs" Inherits="Modules_LoyalityCardType_LoyalityCardType" %>


<script type="text/javascript">
    $(function () {
          $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            UserModuleID: '<%=userModuleID %>',          
        });
        resizeIframe();
    });
</script>
<style>

    input[readonly] {
        cursor: pointer !important;
    }
</style>
    <div class="RO_wrapper">
        <div class="restro-title clearfix">
         <input class="sfLocale icon-Add icon-addnew sfBtn" type="button" id="btnAddLoyalityCard" value="Add" />
        </div>
    <div id="divForcard" style="display:none;">
        <div class="main" style="margin:15px;margin-bottom:0px;">
            <table style="display:block;">
                <tr>
                    <td>
                       CardType Name :
                    </td>
                    <td>
                        <input type="text" id="txtName" class="sfInputbox " name="txtName"/>
                    </td>
                  </tr>
                <tr>
                    <td>Description :
                    </td>
                    <td>
                        <textarea id="txtDescription" class="sfInputbox " name="txtDescription"/ ></textarea>
                    </td>
                     </tr>
                <tr>
                    <td>Discount :
                    </td>
                    <td>
                        <input type="text" id="txtDiscount" class="sfInputbox " onkeypress='return IntegerAndDecimal(event,this);' name="txtDiscount" />
                    </td>                            
                <tr>
                    <td></td>
                    <td>
                        <input type="button" id="btnSaveCard" value="Save" class="sfLocale icon-save sfBtn" />
                        <input type="button" id="btnCancelCard" class="sfLocale icon-close sfBtn" value="Cancel">
                    </td>
                </tr>
            </table>
            
        </div>
    </div>


         <div id="divLoyalityCardType"> </div>
</div>