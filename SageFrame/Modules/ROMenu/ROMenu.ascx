<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROMenu.ascx.cs" Inherits="Modules_ROMenu_ROMenu" %>
<script>
	$(document).ready(function(){
	    $(this).SageMenuBuilder({
            ContainerClientID: '<%=ContainerClientID %>',
            MenuType: '<%=menuType%>'
        });

        

			$(".iframe").colorbox({iframe:true, width:"98%" , height:"98%", escKey: true,
    overlayClose: false});
            $(".iframe.Dining , .iframe.Food-Court , .iframe.Complementary , .iframe.Take-Away").colorbox({iframe:true, width:"96%" , height:"96%" , escKey: true,
    overlayClose: false});
            $(".iframe.Add-Vendor").colorbox({iframe:true, width:"640px", escKey: true,
    overlayClose: false});
            $(".iframe.Add-Customer").colorbox({iframe:true, width:"550px"});
            $(".iframe.Customer-Details , .iframe.Vendor-Details , .iframe.Customer-Balance").colorbox({iframe:true, width:"96%"});
            $(".iframe.KOT , .iframe.Bar , .iframe.Bakery , .iframe.Pizza ").colorbox({iframe:true, width:"80%"});
            $(".iframe.Unpaid-Bills , .iframe.Billing-Term").colorbox({iframe:true, width:"900px"});
            $(".iframe.Call-Waiter").colorbox({iframe:true, width:"640px"});
            $(".iframe.Room-Types , .iframe.Company-Info , .iframe.Cost-Center , .iframe.Restro-Rooms , .iframe.Table-Info , .iframe.Provider-List , .iframe.Store , .iframe.Fiscal-Year-Settings").colorbox({iframe:true, width:"800px"});
            $(".iframe.CloseDay").colorbox({iframe:true, width:"750px"});
             $(".iframe.Call-Waiter").colorbox({iframe:true, width:"300px"});
               $(".iframe.User-Profile").colorbox({iframe:true, width:"900px"});
               $(".iframe.Restro_support").colorbox({iframe:true, width:"400px", height:"96%", escKey: true,
                   overlayClose: true
               });

        

            
	});
                    			</script>

<asp:Literal ID="ltrNav" runat="server" EnableViewState="false"></asp:Literal>
