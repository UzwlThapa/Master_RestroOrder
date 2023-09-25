  <%@ Control Language="C#" AutoEventWireup="true" CodeFile="RODashBoard.ascx.cs" Inherits="Modules_RODashBoard_RODashBoard" %>
<script type="text/javascript">
    //<![CDATA[
    $(function () {
        $(this).companyDashboardEDIT({
         
        });

    });
    //]]>

</script>

<div>
    <br />

    <asp:Literal id="ltrRoomType" runat="server" />
    <%--  <asp:Panel ID="pnlGallery" runat="server">

        </asp:Panel>--%>
    <div>
         <asp:Label ID="txtSearch" runat="server"></asp:Label>
        <%--<asp:Button ID="btnSearch" runat="server" Text="Search Item" OnClick="btnSearch_Click" />--%>
    </div>
    <asp:Literal ID="ltrGallery" runat="server"></asp:Literal>

    <%--<asp:Panel ID="pnlGallery1" runat="server" Width="50%" BorderStyle="Dotted" BorderColor="Green">
             <asp:Literal ID="ltrGallery" runat="server"></asp:Literal>
        </asp:Panel>--%>
    <br />
</div>
<hr />
<hr />
  <asp:Literal runat="server" ID="Literal1"></asp:Literal>
<div style="color: #808080;">
    <asp:Panel ID="pnlGallery" runat="server">
        <asp:Literal runat="server" ID="litRoom"></asp:Literal>
    </asp:Panel>
</div>






<%--



<section class="homepage" id="vision-mission">
	<div class="sfCol_100 vision-bg">
		<div class="vision-mission-part">
			<h3>
				Vision</h3>
			<div class="vision-border">
				&nbsp;</div>
			<br />
			<div class="sfCol_50 vision-mission-description">
				<div class="col1">
					<div class="bg">
						<a class="box overlay1" href="#"><span class="image-caption">Vision</span> <span class="desc1 overlay-desc">Our vision is to create and develop products and grow in a constant &amp; stable manner in the IT business by providing web development solutions starting from local to the global marketplace.</span></a></div>
				</div>
				<div class="col2">
					<div class="bg1">
						<a class="box overlay2" href="#"><span class="image-caption">Mission</span> <span class="desc2 overlay-desc">Our mission is to deliver high-quality optimal solutions and achieve complete customer satisfaction working in an ethical environment.</span></a></div>
				</div>
			</div>
			
			
		</div>
	</div>
</section>
<script type="text/javascript">

    $(".overlay1").hover(
        function () {
            $("span.desc1.overlay-desc").toggleClass("on");
        });</script>

<script type="text/javascript">
    $(".overlay2").hover(
   function () {
       $("span.desc2.overlay-desc").toggleClass("on");
   });--%>


