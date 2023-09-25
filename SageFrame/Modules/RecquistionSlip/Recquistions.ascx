<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Recquistions.ascx.cs" Inherits="Modules_RecquistionSlip_Recquistions" %>
<script type="text/javascript">
    $(document).ready(function () {
        $(this).companyProfEDIT({});
    });
</script>
<div class="RO_wrapper">
      <div class="report-filter">  <span>Search :</span> <input type="text" class="sfInputbox" id="txtSearch" /></div>
<div id="tabs">

    <ul>
        <li><a href="#tabs-1">Requested Recquistions</a></li>
        <li><a href="#tabs-2">InProgress Recquistions</a></li>
        <li><a href="#tabs-3">Completed Recquistions</a></li>
    </ul>
    <div id="tabs-1" style="padding-left:0;padding-right:0;">
        <table id="tblRequested" class="reportsprint">
            <thead>
                <tr>
                    <th>Recq. No.</th>
                    <th>Request From</th>
                    <th>Requested By</th>
                    <th>Requested On</th>
                    <th class="tdcenter">Action</th>
                </tr>
            </thead>
            <tbody id="Requested-list"></tbody>
        </table>
    </div>
    <div id="tabs-2" style="padding-left:0;padding-right:0;">
        <table id="tblInprogress" class="reportsprint">
            <thead>
                <tr>
                    <th>Recq. No.</th>
                    <th>Request From</th>
                    <th>Requested By</th>
                    <th>Requested On</th>
                    <th class="tdcenter">Action</th>
                </tr>
            </thead>
            <tbody id="Inprogress-list"></tbody>
        </table>
    </div>
    <div id="tabs-3" style="padding-left:0;padding-right:0;">
        <table id="tblCompleted" class="reportsprint">
            <thead>
                <tr>
                    <th>Recq. No.</th>
                    <th>Request From</th>
                    <th>Requested By</th>
                    <th>Requested On</th>
                    <th class="tdcenter">Action</th>
                </tr>
            </thead>
            <tbody id="Completed-list"></tbody>
        </table>
    </div>
</div>

<div id="RecquistionDetails" style="display:none;">
<div class="dataTables_wrapper no-footer">
    <table class="sfGridwrapper display tablee-section">
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Quantity</th>
                <th>IssueQnty</th>
                <th>Symbol</th>
            </tr>
        </thead>
        <tbody id="item-list"></tbody>
    </table>
</div>
</div>

<div id="RecquistionIssue" style="display:none;">
<div class="dataTables_wrapper no-footer">
       <table id="Recieved" class="sfGridwrapper display tablee-section" style="display:block;">
   <tr>
                 <td>Recieved By :
               </td>
       <td>
                    <asp:DropDownList ClientIDMode="Static" ID="ddlRecievedBy" name="ddlRecievedBy" CssClass="sfInputbox required" runat="server" Style="width: 150px;"></asp:DropDownList>
                </td>
  
            </tr>
        </table>
    <table id="tblItemsIssue" class="sfGridwrapper display tablee-section">
       
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Quantity</th>
                <th>Issued Quantity</th>
                <th>Symbol</th>
                <th>Remaining Quantity</th>
            </tr>
        </thead>
        <tbody id=""></tbody>
    </table>
    <label class="sfBtn restro-btn" id="btnIssueRecquistion">Issue</label>
</div>
</div>
</div>