<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SalesReturn.ascx.cs" Inherits="Modules_RoBikriReport_salesreturn" %>
<script type="text/javascript">
    $(document).ready(function () {
        $(".ReportDate").datepicker({

        });

        $(this).companyProfEDIT({
            CompanyName: '<%=CompanyName%>',
            Pan: '<%=PanNo%>'
        });
         resizeIframe();
    });
</script>
<div class="RO_wrapper">
        <table style="display: block;">
            <tr>
                <td>Start Date :
                </td>
                <td>
                    <input type="text" id="txtStartDate" class="sfInputbox ReportDate" style="width: 100px" />
                </td>
                <td>End Date :
                </td>
                <td>
                    <input type="text" id="txtEndDate" class="sfInputbox ReportDate" style="width: 100px" />
                </td>
                <td>
                    <input type="button" id="btnviewreportR" value="View" class="sfBtn" />
                </td>
                <td> <div id="Exports" style="display: none;">
        <a href="#" class="sfBtn" onclick="$('#displayreports').tableExport({type:'excel',escape:'false'});">Excel</a>
        <a href="#" class="sfBtn" onclick="$('#displayreports').tableExport({type:'xml',escape:'false'});">XML</a>
        <a href="#" class="sfBtn" onclick="$('#displayreports').tableExport({type:'txt',escape:'false'});">TEXT</a>
    </div></td>
            </tr>
        </table>
    </div>

   
    <div id="displayreports"></div>
</div>
