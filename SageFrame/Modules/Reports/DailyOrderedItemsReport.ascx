<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DailyOrderedItemsReport.ascx.cs" Inherits="Modules_Reports_DailyOrderedItemsReport" %>
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtStartDate").datepicker().datepicker("setDate", new Date());
        $("#txtToDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtToDate").datepicker().datepicker("setDate", new Date());
        $(this).companyProfEDIT({});
        resizeIframe();
    });
</script>
<div class="RO_wrapper">
    <div id="div1">
        <table style="display:block;margin-bottom:0px;">
            <tr>
             <td>Start Date :</td>
                <td>
                    <input type="text" class="sfInputbox picker" id="txtStartDate" style="width:100px"/>
                </td>
                <td>
                    End Date :
                </td>
                <td>
                    <input type="text" class="sfInputbox picker" id="txtToDate" style="width:100px"/>
                </td>          
                <td>
                    <input type="button" class="sfBtn restro-btn" id="StartEndReportView" value="View" />
                </td>
            </tr>
        </table>
        <div class="sfGridwrapper" id="filter" style="display: none;">
            <table class="sfGridwrapper" style="display:block;">
                <tr>
                  <%-- <td><label>Filter By : </label></td>--%>
                    <td><label>Filter By :</label></td>
                        <td><select id="selResponsible" class="sfInputbox">
                            <option value="">All</option>
                            <option value="Kot">Kot</option>
                            <option value="Bar">Bar</option>
                            <option value="Bakery">Bakery</option>
                            <option value="Pizza">Pizza</option>
                        </select>
                    </td>
                  
                </tr>
            </table>
        </div>

        <div class="sfGridwrapper" id="DailyOrderReport" style="border: none;">
        </div>
    </div>
</div>