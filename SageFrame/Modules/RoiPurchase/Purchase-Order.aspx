<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Purchase-Order.aspx.cs" Inherits="Modules_RoiPurchase_Purchase_Order" %>

<%@ Register Src="~/Modules/RoiPurchase/PurchaseOrder.ascx" TagPrefix="uc1" TagName="PurchaseOrder" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <uc1:PurchaseOrder runat="server" ID="PurchaseOrder" />

    </div>
    </form>
</body>
</html>
