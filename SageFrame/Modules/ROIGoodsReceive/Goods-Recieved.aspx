<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Goods-Recieved.aspx.cs" Inherits="Modules_ROIGoodsReceive_Goods_Recieved" %>

<%@ Register Src="~/Modules/ROIGoodsReceive/GoodsReceivedRe.ascx" TagPrefix="uc1" TagName="GoodsReceivedRe" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <uc1:GoodsReceivedRe runat="server" ID="GoodsReceivedRe" />
    </div>
    </form>
</body>
</html>
