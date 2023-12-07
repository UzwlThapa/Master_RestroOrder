<%@ Page Language="C#" AutoEventWireup="true" CodeFile="License-Expired.aspx.cs" Inherits="License_Expired" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>

<style type="text/css">
    .sfInputbox {
        display: block;
        width: 200px;
        height: 34px;
        padding: 0px 12px !important;
        font-size: 14px;
        line-height: 1.4;
        color: #555555;
        vertical-align: middle;
        background-color: #ffffff;
        background-image: none;
        border: 1px solid #cccccc;
        border-radius: 4px;
        -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
        box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
        -webkit-transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
        transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
    }

        .sfInputbox:focus {
            border-color: #aaa;
            outline: 0;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 4px rgba(0, 0, 0, 0.2);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 4px rgba(0, 0, 0, 0.2);
        }

    .restro-btn {
        background: #f9993d;
        border: 1px solid #f9993d;
        color: #FFF;
        padding: 8px 12px;
        border-radius: 3px;
        cursor: pointer;
    }

        .restro-btn:hover, .restro-btn:focus {
            background: #f3ab27;
            border: 1px solid #f3ab27;
            outline: 0;
        }
</style>
<body>
    <form id="form1" runat="server">
        <div>

            <div class="liscening">
                <div class="restrologO" style="background: #ff993e;">
                    <img src="images/restroorder-white.png" alt="logo" />
                </div>
                <div class="liscening-content" style="display: flex; height: 400px;">
                    <div class="logoo" style="width: 40%; margin: auto; text-align: center;">
                        <img src="Modules/Logo/image/logo.png" style="width: 300px;" />
                    </div>
                    <div id="divDaysLeft" runat="server" style="width: 60%; margin: auto;">
                        <div class="liscening-detail">
                            <h2>Your software license has Expired!</h2>
                            <h4>You may no longer use the software.</h4>
                            <h4>Please contact to Restro Order Support 01-4422345 (or dial 9841134945) to renew your Subscription</h4>
                            <p>If you would like to continue Restro Order software please contact Restro Order Support 01-4422345 to renew your Subscription.</p>
                            <input type="button" value="Continue" class="restro-btn" onclick="javascript: window.location='/'" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
