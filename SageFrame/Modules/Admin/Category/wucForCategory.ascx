<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucForCategory.ascx.cs" Inherits="Modules_Admin_Category_wucForCategory" %>
<style type="text/css">
    .dataTables_wrapper .dataTables_length, .dataTables_info {
        float: left;
    }

    .dataTables_filter, .dataTables_paginate {
        float: right;
    }
</style>
<script type="text/javascript">
    //$(document).ready(function () { 
    $(function () {
        $(this).companyProfEDIT({
        });
        //$("#extraitems").hide();
        $("#gvDatas").dataTable({
            "jQueryUI": true,
            "searching": true,
            "ordering": true,
            "lengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
            "pageLength": 20,
            columnDefs: [{ orderable: false, targets: [0, 4, 5] }],

        });
        $("#btnCanecle").on('click', function () {
            $("#roiitemtable").hide();
            //location.reload();
        })

        $("#chkbxIsCake").change(function () {
            if (this.checked) {
                $('#ChkbxIsWholeSale').prop('disabled', true);
                $('#ChckbxIsRetail').prop('disabled', true);
            } else {
                $('#ChkbxIsWholeSale').prop('disabled', false);
                $('#ChckbxIsRetail').prop('disabled', false);
            }
        })


        $("#ChckbxIsRetail").change(function () {
            if (this.checked) {
                $('#ChkbxIsWholeSale').prop('disabled', true);
                $('#chkbxIsCake').prop('disabled', true);
            } else {
                $('#ChkbxIsWholeSale').prop('disabled', false);
                $('#chkbxIsCake').prop('disabled', false);
            }
        })

        $("#ChkbxIsWholeSale").change(function () {
            if (this.checked) {
                $('#ChckbxIsRetail').prop('disabled', true);
                $('#chkbxIsCake').prop('disabled', true);
            } else {
                $('#ChckbxIsRetail').prop('disabled', false);
                $('#chkbxIsCake').prop('disabled', false);
            }
        })

        $(".ajax-file-upload").show('setDate', new Date());
        if ($("#Vitemrate").val() == "")
            $("#Vitemrate").datepicker({ dateFormat: 'yy/mm/dd' }).datepicker("setDate", "0");
        else
            $("#Vitemrate").datepicker({ dateFormat: 'yy/mm/dd' });


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

        //var MunitID = $("#DropDownList1").val();
        //$("#MunitHideen").val(MunitID);

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
        //$("#HiddenFieldCostCentre").val($("#ddCostCentre").val());
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

        //$("#btnAdd").click(function () {
        //    //$("#loyaltycheckbox").show();
        //    $("#btnAdd").hide();
        //    $("#divForMember").show();
        //    //$("#tabss").hide();
        //});

        //$("input[type=radio][name=Customer]").change(function () {
        //    $(".main").show();
        //    if (this.value == '0') {
        //        //$(".custo").show();
        //        $(".item").hide();
        //    } else {
        //        $(".item").show();
        //       // $(".vend").show();
        //    }
        //});
    });
    //});
</script>

<div class="RO_wrapper">
    <div class="restro-title clearfix">
        <asp:Button ID="btnAdd" ClientIDMode="Static" Text="Add" class="icon-addnew sfBtn" runat="server" OnClick="btnAdd_Click" />

    </div>
    <table runat="server" id="roiitemtable">
        <tr>
            <td>Parent Categories :
            </td>
            <td>
                <asp:DropDownList runat="server" ClientIDMode="Static" ID="ddlParentITem" CssClass="sfInputbox" Style="width: 150px;"></asp:DropDownList>
                <asp:HiddenField ID="HiddenParentItem" runat="server" ClientIDMode="Static" />

            </td>

            <td>Category Name<span style="color: red;">*</span> :
            
            </td>
            <td>
                <asp:TextBox ID="itemName" ClientIDMode="Static" runat="server" CssClass="sfInputbox"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ID="reqName" ControlToValidate="itemName" ErrorMessage="Please enter Item Name!" Display="dynamic" />

            </td>
        </tr>
        <tr>
            <td>Category Code :
            </td>
            <td>
                <asp:TextBox ClientIDMode="Static" ID="itemCode" CssClass="sfInputbox" runat="server"></asp:TextBox>
                <%-- <asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator1" ControlToValidate="itemCode" ErrorMessage="Please enter Item Code!" Display="dynamic" />--%>
                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtTableName" runat="server" ErrorMessage="Table name is required" Display="dynamic"></asp:RequiredFieldValidator>--%>
            </td>

            <td>Image :
            </td>
            <td rowspan="4">
                <%-- <img id="ImgPrvs"  height="150px" width="225px" runat="server" ClientIDMode="Static" />--%>
                <img id="ImgPrvs" style="height: 150px; width: 225px;" runat="server" clientidmode="Static" />
                <br />
                <input type="file" id="fileImage" />
                <%-- <input type="hidden" id="txtImage" />--%>
                <asp:HiddenField ID="txtImage" ClientIDMode="Static" runat="server"></asp:HiddenField>
                <%--<asp:HiddenField ID="txtCompanyLogo" ClientIDMode="Static" runat="server"></asp:HiddenField>--%>
            </td>
            <%--<td>
                    <div id="fileuploaderMain" class="sfBtn">Upload</div>
                    <label class="less">(*Image Size must be less then 0.5 MB )</label>
                </td>--%>
        </tr>
        <tr class="item">
            <td>Is Menu?
            </td>
            <td>
                <asp:CheckBox ClientIDMode="Static" ID="isMenu" runat="server" Checked="true" />
            </td>
        </tr>
        <%--<tr class="item">
                <td>Is Category?
                </td>
                <td>
                    <asp:CheckBox ClientIDMode="Static" ID="IsCategory" runat="server" />
                </td>
            </tr>--%>
        <%--<tr>
                        <td>Image :
                    </td>
                        <td>--%>
        <%--<img id="ImgPrvs" height="150px" width="225px" />
                            <br />
                            <input type="file" id="txtImage" />--%>
        <%--<asp:Image ID="ImgPrvs" ClientIDMode="Static" Height="150px" Width="225px" runat="server" />
                            <asp:TextBox ID="txtCompanyLogo" ClientIDMode="Static" CssClass="sfInputbox" runat="server"></asp:TextBox>
                        </td>
                </tr>--%>

        <%--<tr class="item" style="display:none;">--%>
        <tr>
            <td>Cost Center<span style="color: red;">*</span> :
            </td>
            <td>

                <asp:DropDownList ClientIDMode="Static" CssClass="DropdownCostCentre sfInputbox" runat="server" ID="ddCostCentre" Style="width: 150px;"></asp:DropDownList>
                <asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator3" ControlToValidate="ddCostCentre" ErrorMessage="Please enter Cost Center!" Display="dynamic" />
                <asp:HiddenField ID="HiddenFieldCostCentre" runat="server" ClientIDMode="Static" />
            </td>
        </tr>
        <tr>
            <td>IsActive :
            </td>
            <td>
                <%--<input id="chkbxIsActive" type="checkbox">--%>
                <asp:CheckBox ClientIDMode="Static" ID="chkbxIsActive" runat="server" Checked="true" />
            </td>
        </tr>
        <tr>
            <td>IsCake :
            </td>
            <td>
                <%--<input id="chkbxIsActive" type="checkbox">--%>
                <asp:CheckBox ClientIDMode="Static" ID="chkbxIsCake" runat="server" Checked="false" />
            </td>
        </tr>
        <tr>
            <td>Is Wholesale :
            </td>
            <td>
                <asp:CheckBox ClientIDMode="Static" ID="ChkbxIsWholeSale" runat="server" Checked="false" />
            </td>
        </tr>
        <tr>
            <td>Is Retail :
            </td>
            <td>
                <asp:CheckBox ClientIDMode="Static" ID="ChckbxIsRetail" runat="server" Checked="false" />
            </td>
        </tr>
        <tr class="item">
            <td>Is Inventory Item:
            </td>
            <td>
                <asp:CheckBox ClientIDMode="Static" ID="IsProdMaterial" runat="server" />

            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <table runat="server" id="roiitemtable1">

                    <tr>
                        <td>
                            <asp:Button ID="saveItems" ClientIDMode="Static" Text="Save" runat="server" OnClick="saveItem_Click" class="icon-save sfBtn" />

                            <asp:Button ID="btnCanecle" Text="Cancel" CausesValidation="false" runat="server" class="icon-close sfBtn" OnClick="btnCanecle_Click" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <%-- <div id="displayTempTable">
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
                               </asp:TemplateField>
            </Columns>
        </asp:GridView>

    </div>--%>

    <%-- </div>--%>

    <div class="thbg" style="margin-top: -1px;">
        <asp:GridView ID="gvDatas" AutoGenerateColumns="False" runat="server" CellPadding="2" ForeColor="Black" OnRowCommand="gvDatas_RowCommand" DataKeyNames="ITId" GridLines="None" BorderWidth="0px" ClientIDMode="Static" OnRowCreated="gvDatas_RowCreated" RowStyle-CssClass="ROGrid">
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
                <asp:TemplateField HeaderText="Category Name">
                    <ItemTemplate>
                        <%# Eval("ITName") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Category Code">
                    <ItemTemplate>
                        <%# Eval("ITcode") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Parent Category" Visible="false">
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
                            CommandName="EditUser" CssClass="icon-edit tdcenter" ToolTip="Edit Category" meta:resourcekey="imgEditResource1" autoPostback="true" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfEdit tdcenter" />
                </asp:TemplateField>

                <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Delete">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgDelete" OnClientClick="return confirm('Are you sure you want to delete this Category? The menu items of this category will also be deleted?'); " runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="DeleteUser" CssClass="icon-delete tdcenter" ToolTip="Delete Category" meta:resourcekey="imgEditResource1" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfDelete tdcenter" />
                </asp:TemplateField>


            </Columns>

            <FooterStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
            <%--<PagerSettings Mode="NumericFirstLast"  PageButtonCount="4"  FirstPageText="First" LastPageText="Last" />--%>
            <RowStyle BackColor="#f5f5f5" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
            <SortedAscendingCellStyle BackColor="#FDF5AC" />
            <SortedAscendingHeaderStyle BackColor="#4D0000" />
            <SortedDescendingCellStyle BackColor="#FCF6C0" />
            <SortedDescendingHeaderStyle BackColor="#820000" />



        </asp:GridView>
    </div>
</div>

