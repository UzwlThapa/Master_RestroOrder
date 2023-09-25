<%@ Control Language="C#" ClassName="LandingPage" %>
<div id='sfOuterWrapper' class="sfCurve" runat="server">
    <div id='sfHeaders' class='sfOuterwrapper clearfix'>
        <div class='sfMoreblocks clearfix'>
            <div class='sfCol_100'>
                <div class='sfWrapper'>
                    <asp:PlaceHolder ID='pch_topbar' runat='server'></asp:PlaceHolder>
                </div>
            </div>
        </div>
    </div>
    <div id='sfLandingpage' class='mcustomscrollbar sfOuterwrapper clearfix'>
        <div class='sfInnerwrapper clearfix'>
            <div class='sfMoreblocks clearfix'>
                <div id="sfLandingpagea" class='sfCol_75'>
                    <div class='sfWrapper'>
                        <asp:PlaceHolder ID='pch_landingpagea' runat='server'></asp:PlaceHolder>
                    </div>
                </div>
                <div id="sfLandingpageb" class='sfCol_25'>
                    <div class='sfWrapper'>
                        <asp:PlaceHolder ID='pch_landingpageb' runat='server'></asp:PlaceHolder>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
