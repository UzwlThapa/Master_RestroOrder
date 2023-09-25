<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemLedgerView.ascx.cs" Inherits="Modules_ItemLedger_ItemLedgerView" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            Username: '<%=Username%>',
        });
     
    });
    $(document).ready(function () {
        $("#txtStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtStartDate").datepicker().datepicker("setDate", new Date());
        $("#txtEndDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtEndDate").datepicker().datepicker("setDate", new Date());

    });
</script>

<div class="RO_wrapper">
       <div id="divForForm" class="sfformwrapper">
            <table style="display: block;">
                <tr>
                    <td>
                        <label>Item :</label>
                    </td>
                    <td>
                        <input type="text" id="itemName" class="sfInputbox" style="width: 200px;" />

                        <input type="hidden" id="dd_itemName" class="sfInputbox" />
                    </td>
            
                   <td>Date From:</td>
                <td> <input type="text" class="span2 sfInputbox" placeholder="Start Date" id="txtStartDate" style="width: 120px;"/></td>
        
                  <td>Date To:</td>
                <td><input type="text" class="span2 sfInputbox" placeholder="End Date" id="txtEndDate" style="width: 120px;"/></td>
             
                    <td>
                        <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                    </td>
                </tr>
            </table>
        </div>
    <div id="divItemledger" class="restrowrapper"></div>

    
</div>
