<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROItemDisplay.ascx.cs" Inherits="Modules_ROItemDisplay_ROItemDisplay" %>
<script type="text/javascript">

    $(function () {
        $(this).companyProfEDIT({
            modulePath: '<%=modulePath %>',
            userModuleID: '<%=userModuleID %>',
            RowTotal: '<%=RowTotal %>'
        });
    });
</script>


		<script type="text/javascript" src="https://code.jquery.com/jquery-2.1.3.min.js"></script>
		<%--<script type="text/javascript" src="js/html-table-search.js"></script>--%>
		<%--<script type="text/javascript">
		    $(document).ready(function () {
		        $('table.search-table').tableSearch({
		            searchText: 'Search Table',
		            searchPlaceHolder: 'Input Value'
		        });
		    });




		    (function ($) {
		        $.fn.tableSearch = function (options) {
		            if (!$(this).is('table')) {
		                return;
		            }
		            var tableObj = $(this),
                        searchText = (options.searchText) ? options.searchText : 'Search: ',
                        searchPlaceHolder = (options.searchPlaceHolder) ? options.searchPlaceHolder : '',
                        divObj = $('<div style="float:right;">' + searchText + '</div><br /><br />'),
                        inputObj = $('<input type="text" placeholder="' + searchPlaceHolder + '" />'),
                        //caseSensitive = (options.caseSensitive === true) ? true : false,
                        caseSensitive = false,
                        searchFieldVal = '',
                        pattern = '';
		            inputObj.off('keyup').on('keyup', function () {
		                searchFieldVal = $(this).val();
		                pattern = (caseSensitive) ? RegExp(searchFieldVal) : RegExp(searchFieldVal, 'i');
		                tableObj.find('tbody tr').hide().each(function () {
		                    var currentRow = $(this);
		                    currentRow.find('td').each(function () {
		                        if (pattern.test($(this).html())) {
		                            currentRow.show();
		                            return false;
		                        }
		                    });
		                });
		            });
		            tableObj.before(divObj.append(inputObj));
		            return tableObj;
		        }
		    }(jQuery));
		</script>--%>
    <div>
        <br />
      <%--  <asp:Panel ID="pnlGallery" runat="server">

        </asp:Panel>--%>
        <div>
        
        <asp:TextBox ID="txtSearch" runat="server" ></asp:TextBox>
        <asp:Button ID="btnSearch" runat="server" Text="Search Item" OnClick="btnSearch_Click" />

        </div>
        <asp:Literal ID="ltrGallery" runat="server"></asp:Literal>

         <%--<asp:Panel ID="pnlGallery1" runat="server" Width="50%" BorderStyle="Dotted" BorderColor="Green">
             <asp:Literal ID="ltrGallery" runat="server"></asp:Literal>
        </asp:Panel>--%>
        <br />
    </div>