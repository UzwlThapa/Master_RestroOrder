<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Roi_Item.ascx.cs" Inherits="Modules_ROI_Item_Roi_Item" %>

<style type="text/css">
    div#gvDatas_wrapper .dataTables_length {
        float: left;
    }

    div#gvDatas_wrapper .dataTables_filter {
        float: right;
    }
</style>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
        });
        //$("#extraitems").hide();
        $("#gvDatas").dataTable({
            "jQueryUI": false,
            "searching": true,
            "ordering": true,
            "lengthChange": true,
        });
        $("#btnCanecle").on('click', function () {
            $("#roiitemtable").hide();
            //location.reload();
        })

        $(".ajax-file-upload").show('setDate', new Date());
        if ($(".Vitemrate").val() == "")
            $(".Vitemrate").datepicker({ dateFormat: 'yy/mm/dd' }).datepicker("setDate", "0");
        else
            $(".Vitemrate").datepicker({ dateFormat: 'yy/mm/dd' });


        $("#fileuploaderMain").on('click', function () {

            $("#fileuploaderMain").uploadFile({
                url: SageFrameHostURL + "/Modules/ROI_Item/ImageUpload.ashx",
                dragDrop: false,
                fileName: "myfile",
                showDelete: true,
                showDownload: true,
                statusBarWidth: 600,
                maxFileCount: 1,
                maxFileSize: 512000,

                onSuccess: function (files, data, xhr) {
                    $(".ajax-file-upload").hide();
                    $(".less").hide();
                    var filename = (data);
                    $("#txtCompanyLogo").val(filename);
                    $("#ImgPrvs").attr("src", "/Modules/ROI_Item/ImageItem/" + filename);
                    //console.log(filename);
                },
                deleteCallback: function (data, pd) {
                    $(".ajax-file-upload").show();
                    $(".ajax-file-upload-statusbar").hide();
                    $("#txtCompanyLogo").val("");
                    $("#ImgPrvs").attr("src", "");
                }
            });
        });
        var pareintid = $("#ddlParentITem").val();
        if (pareintid == "") {
            pareintid = 0;
        }
        $("#HiddenParentItem").val(pareintid);

        var MunitID = $("#DropDownList1").val();
        $("#MunitHideen").val(MunitID);

        var dsUnit = $("#DropDownList2").val();
        $("#hiddenDSUnit").val(dsUnit);


        var dpunit = $("#DropDownList3").val();
        $("#HiddenDPUnit").val(dpunit);


        $("#ddlParentITem").on('change', function () {
            var pareintid = $("#ddlParentITem").val();
            $("#HiddenParentItem").val(pareintid);

        })


        $("#DropDownList1").on('change', function () {
            var MunitID = $("#DropDownList1").val();
            $("#MunitHideen").val(MunitID);

        })

        $("#DropDownList2").on('change', function () {
            var dsUnit = $("#DropDownList2").val();
            $("#hiddenDSUnit").val(dsUnit);

        })
        $("#DropDownList3").on('change', function () {
            var dpunit = $("#DropDownList3").val();
            $("#HiddenDPUnit").val(dpunit);

        })

        $("#ddCostCentre").on('change', function () {
            var CostCentreID = $("#ddCostCentre").val();
            $("#HiddenFieldCostCentre").val(CostCentreID);

        })
        $("#ckboxExtraItem").change(function () {
            if ($(this).prop('checked') == true) {
                $("#extraitems").show();
            }
            else {
                $("#extraitems").hide();
            }
        });

        var category = 0;
        $("#IsProdMaterial").click(function () {
            if (category == 0) {
                category = 1;
            }
            else {
                category = 0;
            }
            if (category == 1) {
                $(".cato").hide();
            } else {
                $(".cato").show();
            }

        });

        $("#btnForNewRow").click(function () {
            $("#tableForSubtable").each(function () {
                var tds = '<tr>';
                jQuery.each($('tr:last td', this), function () {
                    tds += '<td>' + $(this).html() + '</td>';
                });
                tds += '</tr>';
                if ($('tbody', this).length > 0) {
                    $('tbody', this).append(tds);
                } else {
                    $(this).append(tds);
                }
            });
        });
    });


</script>

<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Restro Item</a></li>

    </ul>
    <div id="tabs-1">
        <asp:Button ID="btnAdd" ClientIDMode="Static" Text="Add" class="icon-addnew sfBtn" runat="server" />
        <div id="roiitemtable">
            <table runat="server" style="display: block; margin-bottom: 0; border: 1;">
                <tr>
                    <td>Category Name:
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ClientIDMode="Static" ID="ddlParentITem" CssClass="sfInputbox" Style="width: 200px;"></asp:DropDownList>
                        <asp:HiddenField ID="HiddenParentItem" runat="server" ClientIDMode="Static" />

                    </td>
                </tr>
                <tr>
                    <td>Item Name :
            
                    </td>
                    <td>
                        <asp:TextBox ID="itemName" ClientIDMode="Static" runat="server" CssClass="sfInputbox"></asp:TextBox>
                       <%-- <asp:RequiredFieldValidator runat="server" ID="reqName" ControlToValidate="itemName" ErrorMessage="Please enter Item Name!" Display="dynamic" />--%>

                    </td>
                </tr>
                <tr>
                    <td>Item Code :
                    </td>
                    <td>
                        <asp:TextBox ClientIDMode="Static" ID="itemCode" CssClass="sfInputbox" runat="server"></asp:TextBox>
                       <%-- <asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator1" ControlToValidate="itemCode" ErrorMessage="Please enter Item Code!" Display="dynamic" />--%>
                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtTableName" runat="server" ErrorMessage="Table name is required" Display="dynamic"></asp:RequiredFieldValidator>--%>
                    </td>
                </tr>
                <tr>
                    <td>Image :
                    </td>
                    <td style="background: #FFFFFF;">
                        <%--<input type="text" id="txtCompanyLogo"  class="sfInputbox1 required" />--%>
                        <asp:Image ID="ImgPrvs" ClientIDMode="Static" Height="150px" Width="225px" runat="server" />
                        <asp:TextBox ID="txtCompanyLogo" ClientIDMode="Static" CssClass="sfInputbox" runat="server"></asp:TextBox>
                        <%-- <asp:RequiredFieldValidator runat="server" id="RequiredFieldValidator2" controltovalidate="txtCompanyLogo" errormessage="Please Upload Item Image!" Display="dynamic" />--%>
                        <%--<asp:PlaceHolder ID=""></asp:PlaceHolder>--%>
                    </td>
                    <td>
                        <div id="fileuploaderMain" class="sfBtn">Upload</div>
                        <%--<input type="text" id="div_files" />--%>
                        <label class="less">(*Image Size must be less then 0.5 MB )</label>
                    </td>
                </tr>
                <tr class="item">
                    <td>Is Menu?
                    </td>
                    <td>
                        <asp:CheckBox ClientIDMode="Static" ID="isMenu" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>Expirable
                    </td>
                    <td>
                        <asp:CheckBox ClientIDMode="Static" ID="isExpirable" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td>ProdMaterial
                    </td>
                    <td>
                        <asp:CheckBox ClientIDMode="Static" ID="IsProdMaterial" runat="server" />

                    </td>
                </tr>
                <tr>
                    <td>UnitWiseRate
                    </td>
                    <td>
                        <asp:CheckBox ClientIDMode="Static" ID="IsUnitWiseRate" runat="server" />
                    </td>

                </tr>
                <tr>
                    <td>Cost Center :
                    </td>
                    <td>

                        <asp:DropDownList ClientIDMode="Static" CssClass="DropdownCostCentre sfInputbox" runat="server" ID="ddCostCentre" Style="width: 200px;"></asp:DropDownList>
                        <%--<asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator3" ControlToValidate="ddCostCentre" ErrorMessage="Please enter Cost Center!" Display="dynamic" />--%>
                        <asp:HiddenField ID="HiddenFieldCostCentre" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td>Details :
                    </td>
                    <td colspan="2">
                        <asp:TextBox ID="txtDetails" TextMode="MultiLine" Rows="5" runat="server" Style="width: 100%;"></asp:TextBox>
                    </td>
                </tr>

                <hr />
                <tr>
                    <td>Small Unit :
                    </td>
                    <td>
                        <asp:DropDownList CssClass="sfInputbox required" ClientIDMode="Static" runat="server" Style="width: 200px;" ID="dditemrate2"></asp:DropDownList>
                        <%--<asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator4" ControlToValidate="dditemrate2" ErrorMessage="Please enter Item Unit!" Display="dynamic" />--%>
                        <asp:HiddenField ID="HiddenField1" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table id="tableForSubtable">
                            <thead>
                                <tr>
                                    <th>Large Unit</th>
                                    <th>Conversion</th>
                                    <th>Is Default Purchase Unit</th>
                                    <th>Is Default Sales Unit</th>
                                    <th>Sales Rate</th>
                                    <th>Valid From</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <%--<asp:DropDownList CssClass="sfInputbox required" ClientIDMode="Static" runat="server" Style="width: 100px;" ID="DropDownList1"></asp:DropDownList>--%>
                                        <select class="selLargeUnit" Style="width: 100px;">
                                        </select>
                                    </td>
                                    <td>
                                        <%--<asp:TextBox ID="txtConversion" Style="width: 100px;" runat="server"></asp:TextBox>--%>
                                        <input type="text" class="txtConversion" Style="width: 100px;"/>
                                    </td>
                                    <td>
                                        <%--<asp:CheckBox ClientIDMode="Static" ID="CheckBox1" runat="server" />--%>
                                        <input type="checkbox" class="CbxDefaultPurchaseUnit" />
                                    </td>
                                    <td>
                                        <%--<asp:CheckBox ClientIDMode="Static" ID="CheckBox2" runat="server" />--%>
                                        <input type="checkbox" class="CbxDefaultSaleUnit" />
                                    </td>
                                    <td>
                                        <%--<asp:TextBox ID="sritemrate" TextMode="Number" CssClass="sfInputbox required" ClientIDMode="Static" Style="width: 100px;" runat="server"></asp:TextBox>--%>
                                        <input type="text" class="sritemrate" Style="width: 100px;"/>
                                    </td>
                                    <td>
                                        <%--<asp:TextBox ID="Vitemrate" CssClass="sfInputbox" Style="width: 100px;" ClientIDMode="Static" runat="server"></asp:TextBox>--%>
                                        <input type="text" class="Vitemrate" Style="width: 100px;"/>
                                    </td>
                                    <td>
                                        <%--<asp:Button ID="btnForNewRow" ClientIDMode="Static" Text="ADD" runat="server" class="sfLocale icon-addnew sfBtn" />--%> 
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <input type="button" id="btnForNewRow" value="Add" />
                    </td>
                </tr>
            </table>
        </div>

        <table>
            <tr>
                <td>Extra Item
                </td>
                <td>
                    <asp:CheckBox ClientIDMode="Static" ID="ckboxExtraItem" runat="server" />
                </td>

            </tr>
        </table>
        <table id="extraitems"  runat="server" clientidmode="static">
            <tr>
                <td style="width: 83px">Extra Item :
                </td>
                <td>
                    <asp:TextBox ID="extraItem" ClientIDMode="Static" CssClass="sfInputbox" runat="server"></asp:TextBox>

                    <%-- <asp:TextBox ID="extraitem" runat="server" ></asp:TextBox>--%>
                </td>
                <td>Price :
                </td>

                <td>
                    <asp:TextBox ID="txtPrice" TextMode="Number" ClientIDMode="Static" CssClass="sfInputbox" Style="width: 200px;" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Button ID="btnAddTemp" ClientIDMode="Static" Text="ADD" runat="server" class="sfLocale icon-addnew sfBtn"  />
                </td>
            </tr>
        </table>
        <div id="displayTempTable">
            <asp:GridView ID="gv_TempTable" runat="server" AutoGenerateColumns="false" CssClass="inventory-table dataTable no-footer">

                <Columns>
                    <asp:TemplateField HeaderText="S.N.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Extra Item">
                        <ItemTemplate><%#Eval("ExtraItem") %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Extra Price">
                        <ItemTemplate><%#Eval("ExtraPrice") %></ItemTemplate>
                    </asp:TemplateField>
                    <%-- <asp:TemplateField meta:resourcekey="TemplateFieldResource8">
                               <ItemTemplate>
                            <asp:LinkButton ID="imgDelete" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="DeleteUser" CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />

                     </ItemTemplate>
                 <HeaderStyle CssClass="sfEdit" />
                               </asp:TemplateField>--%>
                </Columns>
            </asp:GridView>

        </div>
        <table id="roiitemtable1">

            <tr>
                <td style="width: 83px"></td>
                <td>
                   <%-- <asp:Button ID="saveItems" ClientIDMode="Static" Text="Save" runat="server" OnClick="saveItem_Click" class="icon-save sfBtn" />--%>
                    <input type="button" id="saveItems" value="Save" />
                    <asp:Button ID="btnCanecle" Text="Cancel" CausesValidation="false" runat="server" class="icon-close sfBtn"/>
                </td>
            </tr>
        </table>
    </div>


    <asp:GridView ID="gvDatas" AutoGenerateColumns="False" runat="server" CellPadding="2" ForeColor="Black"  DataKeyNames="ITId" GridLines="None" BorderWidth="0px" ClientIDMode="Static"  CssClass="inventory-table">
        <AlternatingRowStyle BackColor="white" />
        <Columns>
            <asp:TemplateField HeaderText="SN" Visible="true">
                <ItemTemplate>
                    <%# Container.DataItemIndex + 1 %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Id" Visible="false">
                <ItemTemplate>
                    <%# Eval("ITId") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="ItemRateID" Visible="false">
                <ItemTemplate>
                    <%# Eval("ItemRateID") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Item Name">
                <ItemTemplate>
                    <%# Eval("ITName") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Item Code">
                <ItemTemplate>
                    <%# Eval("ITcode") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Parent Item">
                <ItemTemplate>
                    <%# Eval("ParentItem") %>
                </ItemTemplate>
            </asp:TemplateField>


            <%--   <asp:TemplateField HeaderText="DSUnit">
                    <ItemTemplate>
                        <%# Eval("dsunitparticular") %>
                    </ItemTemplate>
                </asp:TemplateField>
         <asp:TemplateField HeaderText="DPUnit ">
                    <ItemTemplate>
                        <%# Eval("dpunitparticular") %>
                    </ItemTemplate>
                </asp:TemplateField>--%>
            <asp:TemplateField HeaderText="CostCentre">
                <ItemTemplate>
                    <%# Eval("CostCenterName") %>
                </ItemTemplate>
            </asp:TemplateField>


            <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Edit">
                <ItemTemplate>
                    <asp:LinkButton ID="imgEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="EditUser" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" autoPostback="true" />
                </ItemTemplate>
                <HeaderStyle CssClass="sfEdit" />
            </asp:TemplateField>

            <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Delete">
                <ItemTemplate>
                    <asp:LinkButton ID="imgDelete" OnClientClick="return confirm('Are you sure you want to delete this project?'); " runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="DeleteUser" CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />
                </ItemTemplate>
                <HeaderStyle CssClass="sfDelete" />
            </asp:TemplateField>


        </Columns>

        <FooterStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
        <%--<PagerSettings Mode="NumericFirstLast"  PageButtonCount="4"  FirstPageText="First" LastPageText="Last" />--%>
        <PagerStyle CssClass="gridview-pagination" HorizontalAlign="Center" />
        <RowStyle BackColor="#f5f5f5" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
        <SortedAscendingCellStyle BackColor="#FDF5AC" />
        <SortedAscendingHeaderStyle BackColor="#4D0000" />
        <SortedDescendingCellStyle BackColor="#FCF6C0" />
        <SortedDescendingHeaderStyle BackColor="#820000" />



    </asp:GridView>

</div>



