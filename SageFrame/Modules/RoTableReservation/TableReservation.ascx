<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TableReservation.ascx.cs" Inherits="Modules_RoTableReservation_TableReservation" %>
<script type="text/javascript">

    $(function () {
        $(this).companyDashboardEDIT({
            HostUrl: "<%= HostUrl %>",
                Username: '<%=Username%>'
        });
    });
</script>
<div class="RO_wrapper">
      <div class="restro-title clearfix">
         <input class="sfLocale icon-Add icon-addnew sfBtn" type="button" id="btnAddReservation" value="Add" />
        </div>

<div id="divForRoomTablerReservation" Style="display:none;">
<div class="restroform_wrapper">
        <div class="form-group">
            
                <asp:Literal ID="ltrMerge" runat="server" /></div>
                 <asp:Literal ID="ltrRoomForMerge" runat="server" />
                      <div class="form-group"><label>Reservation DateTime : </label>
                    
                        <input type="text" id="txtReserveDateTime" class="sfInputbox" autocomplete="off" style="width: 100px;" name="DateTime" />
                    </div>
                    <div class="form-group">
                     <input type="checkbox" class="customerForCash">
                    <label>Customer Name : </label>
                        <input type="text" id="txtCustName" class="sfInputbox"  name="CustName" />
                    </div>
                <div class="form-group"><label> Phone : </label>
                        <input type="text" id="txtPhone" class="sfInputbox" style="width: 100px;" onkeypress='return IntegerAndDecimal(event,this);' name="Phone" />
                   </div>
                <div class="form-group"><label>No of People : </label>
                        <input type="text" id="txtPeople" class="sfInputbox" style="width: 100px;"  onkeypress='return IntegerAndDecimal(event,this);' name="People" />
                   </div>
                 <div class="form-group"><label>Notify Before Min : </label>
                        <input type="text" id="txtNotify" class="sfInputbox" style="width: 100px;"  onkeypress='return IntegerAndDecimal(event,this);' name="Notify" />
                   </div>
    </div>
        <div class ='TablesForMerge' style="display:none;"></div>
   
    <label class="sfBtn btnReserve restro-btn fa fa-ticket" style="display:none;">Reserve Tables</label>
     </div>
     <div class="sfGridwrapper" id="ViewReservedTable" style="border: none;">
    </div>
     <div id="membeshipformlist">
</div>
     <%--    <div id="divConfirm" Style="display:none;">
        <table>
            <tr>            
                     <td>IsConfirm:
                    </td>
                    <td>
                      <input type="checkbox" id="chkIsConfirm" />
                    </td>
                  </tr>
              <tr>  
                    <td>Confirmed By:
                    </td>
                    <td>
                        <input type="text" id="txtConfirmedBy" class="sfInputbox" style="width: 100px;" name="ConfirmedBy" />
                    </td>
            </tr>
            
        </table>
                <label class="sfBtn btnConfirm restro-btn">Confirm Table</label>
</div>--%>
   
    </div>
    </div>
