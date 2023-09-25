<%@ Control Language="C#" AutoEventWireup="true" CodeFile="navigationBar.ascx.cs" Inherits="Modules_Admin_Roi_NavigationBar_navigationBar" %>
<div class="menu clearfix">
	<ul>
		<li class="active">
			<a runat="server" href="~/"><img src="Upload/images/home.png" /></a>
			<h6>
				<a runat="server" href="~/">Home</a></h6>
		</li>
		<li>
			<a href="/Kot.aspx"><img src="Upload/images/kitchen-order.png" /> </a>
			<h6>
				<a href="/Kot.aspx">Kitchen Order</a></h6>
		</li>
		<li>
			<a href="/Bar.aspx"><img src="Upload/images/bar-order.png" /> </a>
			<h6>
				<a href="/Bar.aspx">Bar Order</a></h6>
		</li>
		<li>
			<a href="/Bakery-Cafe.aspx"><img src="Upload/images/bakery-cafe-order.png" /> </a>
			<h6>
				<a href="/Bar.aspx">Bakery/Cafe Order</a></h6>
		</li>
		<li>
			<a href="/ORDERED-ITEM.aspx"><img src="Upload/images/ordered-item.png" /> </a>
			<h6>
				<a href="/ORDERED-ITEM.aspx">Ordered Item</a></h6>
		</li>
		<li>
			<a href="/PickOrderView.aspx"><img alt="" src="/Upload/images/pick-order.png" /> </a>
			<h6>
				<a href="/PickOrderView.aspx">Pick Order List</a></h6>
		</li>
		<li>
			<a href="/Order.aspx?ID=0"><img alt="" src="/Upload/images/quick-order.png" /> </a>
			<h6>
				<a href="/Order.aspx?ID=0">Quick Order</a></h6>
		</li>
	</ul>
</div>
<script type="text/javascript">
	$(function(){
		$('.menu a').filter(function(){return this.href==location.href}).parent().addClass('active').siblings().removeClass('active')
		$('.menu a').click(function(){
			$(this).parent().addClass('active').siblings().removeClass('active')	
		})
	})
	</script>