<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LiscenseExpired.ascx.cs" Inherits="Modules_LiscenseExpired_LiscenseExpired" %>
<script type="text/javascript">
    
    function checkLiscense(evt) {
        jAlert('Invalid Liscence Key', 'Alert!!', function () { $.alerts.dialogClass = null; });

    }
</script>

<div class="liscening">
	<div class="restrologO" style="background:#ff993e;">
	<img src="images/restroorder-white.png" alt="logo">
	</div>
	<div class="liscening-content" style="display:flex;height: 400px;">
	<div class="logoo" style="width:40%;margin:auto;text-align:center;">
	<img src="Modules/Logo/image/logo.png" style="width:300px;">
	</div>
	<div class="liscening-detail" style="width:60%;margin:auto;">
		<h3>Restro Order Subscription has been expired!!!</h3>
		<h5>You may no longer use the software.</h5>
		<p>If you would like to continue Restro Order software please contact Restro Order Support 01-4422345 to renew your Subscription.</p>
		<p>If you have already renewed your Subscription for the application, Enter the serial number below and click Activate:
	</p>
	<div class="licening-btn" style="display:flex;text-align:center;">
		 <input id="txtLiscenseKey" type="text" class="sfInputbox" placeholder="XXXX-XXXX-XXXX-XXXX"style="width:400px;margin-right:10px;height:auto;" />
		 <input id="btnEnter" type="button" onclick="checkLiscense(this)" value="Activate" class="sfBtn restro-btn" />
	</div>
	</div>
	</div>
</div>