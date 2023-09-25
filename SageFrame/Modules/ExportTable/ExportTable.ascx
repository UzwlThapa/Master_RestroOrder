<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ExportTable.ascx.cs" Inherits="Modules_ExportTable_ExportTable" %>
<style type="text/css">
	.export-tbl .thbg{
    overflow-x: scroll;
    display: block;
}
</style>
<script>
	$(document).ready(function(){
			var tabs = $("#tabs").tabs();
	});
</script>

<div class="RO_wrapper">
        <div class="thbg">
<table style="display:block;">
<tr>
<td><asp:DropDownList ID="DropDownList1" runat="server" Cssclass="sfInputbox" style="width:200px;"></asp:DropDownList></td>
<td><asp:Button ID="btn_GetTable" runat="server" Cssclass="sfBtn restro-btn" Text="Get Data" OnClick="btn_GetTable_Click" />
<asp:Button ID="btn_Excel" runat="server" Cssclass="sfBtn restro-btn" Text="Excel" OnClick="btn_Excel_Click" />
<asp:Button ID="btn_xml" runat="server" Cssclass="sfBtn restro-btn" Text="Xml" OnClick="btn_xml_Click" />
<asp:Button ID="btn_txt" runat="server" Cssclass="sfBtn restro-btn" Text="txt" OnClick="btn_txt_Click" /></td></tr>
</table>
<div class="export-tbl">
<asp:GridView ID="GridViewTables" CssClass="thbg" runat="server" OnPageIndexChanging="OnPaging" gridlines="none">
</asp:GridView>
</div>
</asp:Button>
</div>

