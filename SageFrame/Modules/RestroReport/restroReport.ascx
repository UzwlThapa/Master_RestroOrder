<%@ Control Language="C#" AutoEventWireup="true" CodeFile="restroReport.ascx.cs" Inherits="Modules_RestroReport_restroReport" %>
<script>
    $(document).ready(function () {
        $("#yearvalue").val("2016");
        var tabs = $("#tabs").tabs();
        $("#txtfromdate").datepicker({
            changeYear: true,
            changeMonth: true,
        });
        //$("#txtfromdate").css("display", "none");
        //$(".abc").css("display", "none");
        //$(".monthly").css("display", "none");

        for (i = new Date().getFullYear() ; i > 2015; i--) {
            $('#ddlyear').append($('<option/>').val(i).html(i));
        }

        $("#ddlyear").on('change', function () {
            var a = $("#ddlyear :selected").val();
            $("#yearvalue").val(a);
        });

        $("#ddlmonth").on('change', function () {
            var a = $("#ddlmonth :selected").val();
            $("#monthvalue").val(a);
        });

        $("#ddlreporting").on('change', function () {
            var a = $("#ddlreporting :selected").val();
            $("#rtId").val(a);
            if(a==1)
            {
                $(".abc").css("display","inline-block");
                $(".monthly").css("display", "none"); 
                $(".month").css("display", "none");
            }
            else if(a==2)
            {
                $(".abc").css("display","inline-block");
                $(".monthly").css("display", "none");
                $(".month").css("display", "none");

            }
            else if(a==3)
            {
                $(".monthly").css("display","inline-block");
                $(".abc").css("display", "none");
                $(".month").css("display","inline-block");
            }
            else if(a==4)
            {
                $(".monthly").css("display","inline-block");
                $(".month").css("display", "none");
                $(".abc").css("display", "none");
                //$("#ddlmonth").hide();
            }
        });
    });
</script>
<style>
    .ui-datepicker .ui-datepicker-prev,
    .ui-datepicker .ui-datepicker-next {
        display: none;
    }
</style>
<div id="tabs">
<ul>
            <li><a href="#tabs-1">Reporting</a></li>
    
          </ul>
          <div id="tabs-1"> 
     
    <table style="display:block">
        <tr>
          
            <td>
                <asp:HiddenField ID="rtId" runat="server" ClientIDMode="Static"/>
                 <asp:DropDownList ID="ddlreporting" runat="server" ClientIDMode="Static" CssClass="sfInputbox" style="width:100px;">
                <asp:ListItem Value="0">--Select--</asp:ListItem>
                <asp:ListItem Value="1">Daily</asp:ListItem>
                <asp:ListItem Value="2">Weekly</asp:ListItem>
                <asp:ListItem Value="3">Monthly</asp:ListItem>
                <asp:ListItem Value="4">Yearly</asp:ListItem>
                <%--<asp:ListItem Value="4">Range</asp:ListItem>--%>
            </asp:DropDownList>
        </asp:HiddenField>
        </td>
            <td class="abc" style="display:none;">Date:</td><td class="abc" style="display:none;"><asp:TextBox ID="txtfromdate" runat="server" CssClass="sfInputbox" ClientIDMode="Static" style="width:120px;"/></td>
            <td class="monthly" style="display:none;">
                <asp:HiddenField ID="yearvalue" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="monthvalue" runat="server" ClientIDMode="Static" /></td>
             <td class="monthly" style="display:none;">Year:</td><td class="monthly" style="display:none;"> <span class="year"> <asp:DropDownList ID="ddlyear" runat="server" ClientIDMode="Static" /></span> 
              </td><td class="month monthly" style="display:none;">Month:</td><td class="month monthly" style="display:none;"><asp:DropDownList ID="ddlmonth" runat="server" ClientIDMode="Static" />
            </td>
            <td><asp:Button runat="server" ID="Button1" Text="View" CssClass="sfBtn" OnClick="btnView_Click" style="padding:9px;"/></td>
        </tr>
    </table>
    
  
</div>
<div id="divGrid">
    <asp:Literal ID="lireport" runat="server" />
</div>
</div>