<%@ Control Language="C#" AutoEventWireup="true" CodeFile="L_LaundryMasterView.ascx.cs" Inherits="Modules_L_LaundryMaster_L_LaundryMasterView" %>

<style>
    .gdv th {
        text-align: left;
    }

    div#filterbox {
    position: absolute;
    left: 200px;
    top: 110px;
    z-index: 999;
}

table#tblForTempLaundry th{
background: #ff9933;
    color: white;
    border: none;
    border-right: 1px solid #FFFFFF;
    padding: 8px;
    text-align: center;
}

table#tblForTotal tbody {
    float: right;
}
</style>
<script type="text/javascript">

    function AddData() {
        if ($("#ddlCloth").val() == 0) {
            alert("Please Select The Cloth")
        } else if ($("#ddlMaterial").val() == 0) {
            alert("Please Select Material ")
        //} else if ($("#txtColor").val() == "") {
        //    alert("Please Fill The Color ")
        }
        else if ($("#txtDescription").val() == "") {
            alert("Please Fill The Description ")
        } else if ($("#ddlLaundryType").val() == 0) {
            alert("Please Select Laundry Type ")
        } else if ($("#txtQuantity").val() == "") {
            alert("Please Fill The Quantity ")
        } else if (!$("#txtQuantity").val().match(/^\d+$/)) {
            alert("Quantity must be number ")
        } else if ($("#txtRate").val() == "") {
            alert("Please Fill The Rate ")
        } else if (isNumeric($("#txtRate").val()) == false) {
            alert("Rate must be number ")
        }
        else {
            $("#tblForTotal").show();
            $("#tblForTempLaundry").show();

            var rows = "";
            var clothId = document.getElementById("ddlCloth").value;
            var material = document.getElementById("ddlMaterial").value;
            //var color = document.getElementById("txtColor").value;
            var desc = document.getElementById("txtDescription").value;
            var ltype = document.getElementById("ddlLaundryType").value;
            var qnty = document.getElementById("txtQuantity").value;
            var rate = document.getElementById("txtRate").value;
            var total = document.getElementById("txtRate").value * qnty;
            var deli = ($("#chkLDDelivered").is(':checked'));

            rows += "<tr><td id='" + clothId + "'>" + $(".clothlist :selected").text() + "</td><td id='"+material+"'>" + $(".materiallist :selected").text()
                //+ "</td><td>" + color +
                + "</td><td>" + desc + "</td><td id='" + ltype + "'>" + $(".laundrytypelist :selected").text() + "</td><td>"
                + qnty + "</td><td>" + rate + "</td><td>" + total
                + "</td><td>" + deli
            + "</td><td>" + '<label value="Delete" class="delete icon-delete"></label>' + "</td></tr>";
            $(rows).appendTo("#tblForTempLaundry tbody");

            $("#chkDelivered").prop('checked', false);
            document.getElementById("ddlCloth").value = "";
            document.getElementById("ddlMaterial").value = "";
            //document.getElementById("txtColor").value = "";
            document.getElementById("txtDescription").value = "";
            document.getElementById("ddlLaundryType").value = "";
            document.getElementById("txtQuantity").value = "";
            document.getElementById("txtRate").value = "";

            var amount = 0;
            var table = document.getElementById("tblForTempLaundry");
            for (var i = 0, row; row = table.rows[i]; i++) {
                //iterate through rows
                //rows would be accessed using the "row" variable assigned in the for loop
                amount += $('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(4)').text() * $('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(5)').text();

            }
            $("#txtAmount").val(amount);
            var value = $("#discType").val();
            var disc = $("#txtDiscount").val();
            if (value == 'flat') {
                $("#txtGrandTotal").val(parseFloat($("#txtAmount").val()) - disc);
            }
            else if (value == 'percent') {
                var per = (disc / 100) * parseFloat($("#txtAmount").val());
                $("#txtGrandTotal").val(parseFloat($("#txtAmount").val()) - per);
            }
            else {
                $("#txtGrandTotal").val(parseFloat($("#txtAmount").val()));
            }

        }

    }
    function isNumeric(n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    }

    function RemoveData(btn) {
        var row = btn.parentNode.parentNode;
        row.parentNode.removeChild(row);
    }

    function Validate() {
        if (Page_ClientValidate()) {
            return false;
        }
        return false;
    }

    $(function () {
        $(this).companyProfEDIT({});
        $("#btnAddLaundry").click(function () {
            $(".addForm").show();
            $("#divLaundryList").hide();
            $("#btnAddLaundry").hide();
            $("#filterbox").hide();
        });
    });
    $(function () {
        $('#discType').change(function () {
            var value = $("#discType").val();
            var disc = $("#txtDiscount").val();
            if (value == 'flat') {
                $("#txtGrandTotal").val(parseFloat($("#txtAmount").val()) - disc);
            }
            else if (value == 'percent') {
                var per = (disc/100) * parseFloat($("#txtAmount").val());
                $("#txtGrandTotal").val(parseFloat($("#txtAmount").val()) - per);
            }
            else {
                $("#txtGrandTotal").val(parseFloat($("#txtAmount").val()));
            }
        });

        $("#txtDiscount").keyup(function () {
            var value = $("#discType").val();
            var disc = $("#txtDiscount").val();
            if (value == 'flat') {
                $("#txtGrandTotal").val(parseFloat($("#txtAmount").val()) - disc);
            }
            else if (value == 'percent') {
                var per = (disc / 100) * parseFloat($("#txtAmount").val());
                $("#txtGrandTotal").val(parseFloat($("#txtAmount").val()) - per);
            }
            else {
                $("#txtGrandTotal").val(parseFloat($("#txtAmount").val()));
            }
        });
    });
</script>

<div id="tabs">
    <ul>
        <li><a href="#tab1">Laundry Master</a>

        </li>
    </ul>
    <div id="tab1">

        <div id="dvAddBtn">
            <input type="button" id="btnAddLaundry" class="sfLocale icon-addnew sfBtn" value="Add Laundry" />
        </div>
        <div id="filterbox" runat="server" ClientIDMode="Static" >
            <label>Search by Room : </label>
            <select runat="server" id="ddlroomtypelist" clientidmode="Static"></select>
        </div>
        

        <div class="addForm restrowrapper" id="addForm" style="display: none;">
            <table>
                <tr>
                    <td>
                        
                        <asp:Label runat="server" ID="lblRoomType" ClientIDMode="Static">Room Type : </asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="ddlRoomType" ClientIDMode="Static" Cssclass="sfInputbox" style="width:120px;"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="Dynamic" runat="server" ErrorMessage="Room Type is required !!"
                                            ControlToValidate="ddlRoomType" ValidationGroup="btnSave"></asp:RequiredFieldValidator>
                    </td>
                    <td class="room" style="display:none;">
                        <asp:Label runat="server" ID="lblRoomID" ClientIDMode="Static">Room NO. : </asp:Label>
                    </td>
                    <td class="room" style="display:none;">
                        <asp:DropDownList runat="server" ID="ddlRoom" ClientIDMode="Static" Cssclass="sfInputbox" style="width:120px;"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" Display="Dynamic" runat="server" ErrorMessage="Room is required !!"
                                            ControlToValidate="ddlRoom" ValidationGroup="btnSave"></asp:RequiredFieldValidator>
                        <%--<asp:TextBox runat="server" ID="txtRoomID"></asp:TextBox>--%>
                    </td>
                    <td>
                        <asp:Label runat="server" ID="lblCustomerID" ClientIDMode="Static">Customer : </asp:Label>
                   
                        <%--<asp:TextBox runat="server" ID="txtCustomerID" ClientIDMode="Static" CssClass="sfInputbox"></asp:TextBox>--%>
                        <input type="checkbox" id="txtYes2" /></td>
                        <%--<asp:DropDownList runat="server" ID="ddlCustomerID" ClientIDMode="Static"></asp:DropDownList>--%>
                       <td> <input type="text" runat="server" id="txtCustomerName" class="sfInputbox txtCustomer" style="display:none;" readonly="readonly"/>
                        <asp:HiddenField runat="server" ID="ddlCustomerID" ClientIDMode="Static"></asp:HiddenField>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" Display="Dynamic" runat="server" ErrorMessage="Customer is required !!"
                                            ControlToValidate="txtCustomerName" ValidationGroup="btnSave"></asp:RequiredFieldValidator>
                        
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label runat="server" ID="lblDate" ClientIDMode="Static">Date : </asp:Label>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtDate" ClientIDMode="Static" Cssclass="sfInputbox" style="width:120px;" ReadOnly="true"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Label runat="server" ID="lblDeliveryDate" ClientIDMode="Static">Delivery Date : </asp:Label>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtDeliveryDate" ClientIDMode="Static" Cssclass="sfInputbox" style="width:120px;" ReadOnly="true"></asp:TextBox>
                    </td>

                    <td>
                        <asp:Label runat="server" ID="lblHouseKeeperID" ClientIDMode="Static">HouseKeeper : </asp:Label>

                    </td>
                    <td colspan="2">
                     
                        <asp:DropDownList ClientIDMode="Static" runat="server" ID="ddlHouseKeeperID" Cssclass="sfInputbox" style="width:200px;"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" Display="Dynamic" runat="server" ErrorMessage="HouseKeeper is required !!"
                                            ControlToValidate="ddlHouseKeeperID" ValidationGroup="btnSave"></asp:RequiredFieldValidator>
                    </td>
                    <td>
                        <label id="lblDelivered" style="display:none;">IsDelivered : </label>
                    </td>
                    <td>
                        <input type="checkbox" id="chkDelivered" style="display:none;" />
                    </td>
                </tr>
            </table>
            <h3>Laundry Details</h3>
            <table id="laundrydetails" class="tbllaundryDetails sfGridwrapper">
                <thead>
                    <tr>
                        <th>Cloth</th>
                        <th>Material</th>

                        <th>Description</th>
                        <th>Laundry Type</th>
                        <th>Quantity</th>
                        <th>Rate</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <asp:DropDownList ClientIDMode="Static" runat="server" ID="ddlCloth" CssClass="clothlist"></asp:DropDownList>
                         
                        </td>
                        <td>
                            <asp:DropDownList ClientIDMode="Static" runat="server" ID="ddlMaterial" CssClass="materiallist"></asp:DropDownList>
                          
                        </td>
               
                        <td>
                         
                            <textarea class="txtDescription" id="txtDescription" name="Description" cols="26" rows="2"></textarea>
                        </td>
                        <td>
                            <asp:DropDownList ClientIDMode="Static" runat="server" ID="ddlLaundryType" CssClass="getRate laundrytypelist"></asp:DropDownList>
                          
                        </td>
                        <td>
                            <input type="text" class="txtQuantity" id="txtQuantity" name="Quantity" style="width: 100px;" />
                        </td>
                        <td>
                            <input type="text" id="txtRate" name="Rate" style="width: 100px;" />
                        </td>
                        <td>
                            <input type="checkbox" id="chkLDDelivered" style="display:none;" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <table>
                <tr>
                    <td>
                     
                        <input type="button" id="addRow" class="sfBtn icon-addnew" value="Add a Line" onclick="AddData()" />
                    </td>
                </tr>
            </table>
                        <table runat="server" clientidmode="Static" id="tblForTempLaundry" class="tblForTempLaundry sfGridwrapper" style="display:none;">
                        <thead>
                                <tr>
                                    <th>Cloth</th>
                                    <th>Material</th>
                                
                                    <th>Description</th>
                                    <th>Laundry Type</th>
                                    <th>Quantity</th>
                                    <th>Rate</th>
                                    <th>Total</th>
                                    <th>IsDelivered</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                            
                        </table>
                        <table runat="server" clientidmode="Static" id="tblForTotal" class="tblForTotal" style="display:none;">
                            <tr>
                                <td>Amount : </td>
                                <td></td>
                                <td><input type="text" id="txtAmount" class="sfInputbox" style="width:60px;text-align:right;" readonly /></td>
                            </tr>
                            <tr>
                                <td>Discount : </td>
                                <td><select id="discType" class="sfInputbox" style="width:90px;">
                                    <option value="" selected>-Select-</option>
                                    <option value="flat">Flat</option>
                                    <option value="percent">Percent(%)</option>
                                    </select></td>
                                <td><input type="text" id="txtDiscount" value="0" class="sfInputbox" style="width:60px;text-align:right;"/></td>
                            </tr>
                            <tr>
                                <td>Grand Total : </td>
                                <td></td>
                                <td><input type="text" id="txtGrandTotal" class="sfInputbox" style="width:60px;text-align:right;" readonly /></td>
                            </tr>
                        </table>
                    </td>

                </tr>
            </table>

<div style="margin-left:15px;margin-bottom:15px;">
        
            <asp:Button ID="btnSave" runat="server" ValidationGroup="btnSave" Text="Save" OnClientClick="return Validate();" ClientIDMode="Static" CssClass="sfLocale icon-save sfBtn" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CssClass="sfLocale icon-close sfBtn" />
            </div>

        </div>
        </div>

        <div id="divLaundryList" runat="server" ClientIDMode="Static" class="restrowrapper"></div>
    </div>
    <div id="divLaundryView" class="popup-tbl" style="display:none;">
    </div>
</div>
<div id="CashPaid" class="popup-tbl">
</div>
