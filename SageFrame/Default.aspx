<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs"
    Inherits="SageFrame._Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Controls/TopStickyBar.ascx" TagName="TopStickyBar" TagPrefix="ucstickybar" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server" id="head" enableviewstate="false">
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
    <meta content="text/javascript" http-equiv="Content-Script-Type" />
    <meta content="text/css" http-equiv="Content-Style-Type" />
    <meta id="MetaDescription" name="DESCRIPTION" />
    <meta id="MetaKeywords" name="KEYWORDS" />
    <meta id="MetaCopyright" name="COPYRIGHT" />
    <meta id="MetaGenerator" name="GENERATOR" />
    <meta id="MetaAuthor" name="AUTHOR" />
    <meta name="RESOURCE-TYPE" content="DOCUMENT" />
    <meta name="DISTRIBUTION" content="GLOBAL" />
    <meta id="MetaRobots" runat="server" name="ROBOTS" />
    <meta name="REVISIT-AFTER" content="1 DAYS" />
    <meta name="RATING" content="GENERAL" />
    <meta http-equiv="PAGE-ENTER" content="RevealTrans(Duration=0,Transition=1)" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
    <link type="icon shortcut" runat="server" id="favicon" media="icon" href="favicon.ico" />

    <title>Restro Order</title>
    <link rel="stylesheet" href="css/FontAwesome.css" type="text/css" />
    <asp:Literal runat="server" ID="ltrJQueryLibrary"></asp:Literal>
    <asp:Literal ID="SageFrameModuleCSSlinks" EnableViewState="false" runat="server"></asp:Literal>
    <link href="/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css" />
    <link href="/css/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <link href="Modules/Admin/DashboardSummary/StyleSheet.css" rel="stylesheet" />
    <link href="/css/print.css" rel="stylesheet" type="text/css" media="screen" />
    <script type="text/javascript" src="/js/jquery.1.10.2.min.js"></script>
    <script type="text/javascript" src="/js/jquery.mCustomScrollbar.concat.min.js"></script>
    <script type="text/javascript" src="/Modules/ROMenu/js/jquery.colorbox.js"></script>
    <script type="text/javascript" src="/js/main.js"></script>
    <link href="/css/nepali.datepicker.v2.2.min.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <!--  <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager> -->
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="0">
            <ProgressTemplate>
                <div class="sfLoadingbg">
                    &nbsp;
                </div>
                <div class="sfLoadingdiv">
                    <asp:Image ID="imgPrgress" runat="server" AlternateText="Loading..." ToolTip="Loading..."
                        meta:resourcekey="imgPrgressResource1" />
                    <asp:Label ID="lblPrgress" runat="server" Text="Please wait..." meta:resourcekey="lblPrgressResource1"></asp:Label>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:PlaceHolder ID="message" runat="server"></asp:PlaceHolder>
        <asp:PlaceHolder ID="phdDefault" runat="server"></asp:PlaceHolder>
        <div id="divAdminControlPanel" runat="server" style="display: block;">
            <ucstickybar:TopStickyBar ID="topStickybar" runat="server" />
        </div>
        <noscript>
            <asp:Label ID="lblnoScript" EnableViewState="false" runat="server" Text="This page requires java-script to be enabled. Please adjust your browser-settings."></asp:Label>
        </noscript>
        <asp:Literal ID="ltrPlaceholders" runat="server"></asp:Literal>
        <div class="sfMessagewrapper" id="divMessage" runat="server">
        </div>
        <asp:PlaceHolder ID="pchWhole" runat="server"></asp:PlaceHolder>
        <asp:PlaceHolder ID="pchtest" runat="server"></asp:PlaceHolder>
        <asp:Literal ID="LitSageScript" runat="server"></asp:Literal>
        <iframe id="divFrame" style="display: none" width='100%'></iframe>
        <div class="sfCpanel sfInnerwrapper" runat="server" id="divActivation">
            <asp:Literal runat="server" ID="ltrActivation"></asp:Literal>
        </div>
        <div id="payment" style="display: none;"></div>
        <div id="memberList" style="display: none;"></div>
        <div id="shiftItems" style="display: none;">
            <table style="display: block;">
                <tr>

                    <td class="shiftType" style="display: none;">Shift Type :
                        <select id="selShiftType" class="sfInputbox" style="width: 150px;">
                            <option value="Regular" selected="selected">Regular</option>
                            <option value="Complementary">Complementary</option>
                        </select></td>

                    <td>Shift From :</td>
                    <td>Split No.<select id="fromSplitNo" class="sfInputbox" style="width: 100px;"></select></td>


                    <td class="shiftTo">Shift To :</td>
                    <td class="shiftTo">Room<select id="toRooms" class="sfInputbox"></select></td>
                    <td class="shiftTo">Table<select id="toTables" class="sfInputbox"></select>
                    </td>
                    <td class="shiftTo">Split No.
                        <select id="toSplitNo" class="sfInputbox" style="width: 100px;"></select></td>
                </tr>
            </table>


            <div class="dialogflex">

                <table id="tblOrderList" style="margin-left: 10px; border-right: 1px solid gainsboro; width: 50%;">
                    <thead>
                        <tr>
                            <td>S/N</td>
                            <td>Item Name</td>
                            <td>Quantity</td>
                            <td>Shift
                                <img src="/Images/shift.png" id="shiftAllItems" class="preview-icon" type="button" /></td>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <table id="tblitemsList" style="width: 50%;">
                    <thead>
                        <tr>
                            <td>S/N</td>
                            <td>Item Name</td>
                            <td>Quantity</td>
                            <td>Deduct
                                <img src="/Images/deduct.png" id="deductAllItems" class="preview-icon" type="button" /></td>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
            <label class="sfBtn restro-btn" id="btnShiftItem" style="margin-top: 10px;">Shift Items</label>
        </div>

        <div id="PINcode" style="display: none">
            <input type="hidden" id="hdnPinFor" />
            <input type="hidden" id="hdnPinBy" />
            <input type="hidden" id="hdnPinMatch" />
            <table id="pinpad">
                <tr>
                    <td colspan="3">
                        <input id='PINbox' class="sfInputbox" style='width: 200px' type='password' value='' onkeypress='return IntegerAndDecimal(event,this);' name='PINbox' />
                        <span id="pinError" style="color: red; display: none;">* Error Pincode</span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='1' value='1' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='2' value='2' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='3' value='3' /></td>
                </tr>
                <tr>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='4' value='4' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='5' value='5' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='6' value='6' /></td>
                </tr>
                <tr>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='7' value='7' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='8' value='8' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='9' value='9' /></td>
                </tr>
                <tr>
                    <td>
                        <input type='button' class='sfBtn clearpin' value='C' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='0' value='0' /></td>
                    <td>
                        <input type='button' class='sfBtn del' value='D' /></td>
                </tr>
            </table>
        </div>

        <div id="NumPad" style="display: none; position: absolute; z-index: 9999; width: 150px;">
            <div class="arrowup"></div>
            <table id="nummpad" runat="server">
                <tr>
                    <td colspan="3">
                        <input id='numbox' class="pincodetext" style='width: 100%;' type='text' value='' onkeypress='return IntegerAndDecimal(event,this);' /></td>
                </tr>
                <tr>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='1' value='1' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='2' value='2' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='3' value='3' /></td>
                </tr>
                <tr>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='4' value='4' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='5' value='5' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='6' value='6' /></td>
                </tr>
                <tr>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='7' value='7' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='8' value='8' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='9' value='9' /></td>
                </tr>

                <tr>
                    <td>
                        <input type='button' class='sfBtn Okaypin' value='Ok' /></td>
                    <td>
                        <input type='button' class='PINbutton sfBtn' name='0' value='0' /></td>
                    <td>
                        <input type='button' class='sfBtn del' value='Del' /></td>
                </tr>
            </table>
        </div>
        <script type="text/javascript" src="/js/payment.js"></script>
        <script type="text/javascript" src="/js/shiftItems.js"></script>
        <script type="text/javascript" src="/js/jquery.alerts.js"></script>
        <script type="text/javascript" src="/js/nepali.datepicker.v2.2.min.js"></script>
        <script type="text/javascript" src="/js/jquery.validate.js"></script>
        <script type="text/javascript">
            //<![CDATA[       
            function colorboxFrame(e) {
                var evtobj = window.event ? event : e
                if (evtobj.ctrlKey) {
                    if (evtobj.keyCode == 73 && evtobj.shiftKey && evtobj.ctrlKey) {
                        window.open(SageFrameHostURL + '/Ingredients.aspx');
                    }
                    if (evtobj.keyCode == 86 && evtobj.shiftKey && evtobj.ctrlKey) {
                        window.open(SageFrameHostURL + '/Add-Vendor.aspx');
                    }
                    if (evtobj.keyCode == 67 && evtobj.shiftKey && evtobj.ctrlKey) {
                        window.open(SageFrameHostURL + '/Add-Customer.aspx');
                    }

                    if (evtobj.keyCode == 71 && evtobj.shiftKey && evtobj.ctrlKey) {
                        $.colorbox({ iframe: true, href: "/Generate-Bill.aspx", width: "96%", height: "96%" });
                    }

                    if (evtobj.keyCode == 85 && evtobj.shiftKey && evtobj.ctrlKey) {
                        $.colorbox({ iframe: true, href: "/Unpaid-Bills.aspx", width: "900px", height: "96%" });
                    }
                }
            }
            $(function () {
                $(this).LoadFirst('<%=templatefavicon%>'); $(".sfLocalee").SystemLocalize();
                document.onkeydown = colorboxFrame;
            });
            //]]>
        </script>
    </form>
</body>
</html>
