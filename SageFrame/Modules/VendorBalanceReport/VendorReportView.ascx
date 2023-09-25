 <%@ Control Language="C#" AutoEventWireup="true" CodeFile="VendorReportView.ascx.cs" Inherits="Modules_VendorBalanceReport_VendorReportView" %>

<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            UserModuleID: '<%=userModuleID %>',
            Username: '<%=Username%>',
        });
      

 //var dateFormat = "mm/dd/yy",
 // from = $( "#dateStartDate" )
 //   .datepicker({
 //       //defaultDate: "-1w",
 //       changeYear: true,
 //       changeMonth: true
 //   })
 //   .on( "change", function() {
 //       to.datepicker( "option", "minDate", getDate( this ) );
 //   }),
 // to = $( "#dateEndDate" ).datepicker({
 //     //defaultDate: "+1w",
 //     changeYear: true,
 //     changeMonth: true
 // })
 // .on( "change", function() {
 //     from.datepicker( "option", "maxDate", getDate( this ) );
 // });
 
 //       function getDate( element ) {
 //           var date;
 //           try {
 //               date = $.datepicker.parseDate( dateFormat, element.value );
 //           } catch( error ) {
 //               date = null;
 //           }
 
 //           return date;
 //       }
 //   } );
       
        $("#dateStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#dateEndDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#dateStartDate,#dateEndDate").datepicker("setDate", new Date());
    });
</script>


<div class="RO_wrapper">
    <div id="div1">
 <table class="salesTable" style="display:block;">

  
            <tr>
                <td>Reporting Days :
                </td>
                <td>
                     <input type="text" class="sfInputbox" placeholder="Start Date" id="dateStartDate" name="startdate" required style="width:100px;float:left;"/>
                     <input type="text" class="sfInputbox" placeholder="End Date" id="dateEndDate" name="enddate" required style="width:100px;float:left;margin-left:10px;"/>
                    

                   <td>
            <label>Vendor Name :</label>
        </td>
        <td>
            <select id="ddCusName" class="sfInputbox" style="width:150px;" >

            </select>
        </td>
        <td>
            <button type="button" class="sfBtn restro-btn fa fa-eye" id="viewReport">View</button>
        </td>
            </table>
        <div class="report-view" style="display:none;">
        
                       <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>
          <div id="membeshipformlist"> </div>
    </div>
</div>
 