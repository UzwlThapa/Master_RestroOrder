<%@ Control Language="C#" ClassName="ShortcutLanding" %>
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
                <div id="sfLandingpagea" class='sfCol_100'>
                    <div class='sfWrapper2'  style="height: 80vh;padding: 10px 200px;">
                        <%--<div class='sfWrapper2'  style="display: flex;height: 80vh;padding: 10px 200px;justify-content: center;align-items: center;">--%>
                        <asp:PlaceHolder ID='pch_landingpagea' runat='server'></asp:PlaceHolder>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
