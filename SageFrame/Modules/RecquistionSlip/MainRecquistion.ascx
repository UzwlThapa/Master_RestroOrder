<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MainRecquistion.ascx.cs" Inherits="Modules_RecquistionSlip_MainRecquistion" %>
<script type="text/javascript">
    $(document).ready(function () {
        $(this).companyProfEDIT({});
         // resizeIframe();
    });
</script>
<div class="RO_wrapper">
<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Requested Requisition</a></li>
        <li><a href="#tabs-2">InProgress Requisition</a></li>
        <li><a href="#tabs-3">Completed Requisition</a></li>
    </ul>
    <div id="tabs-1" class="thbg" style="padding-left:0;padding-right:0;">
        <table id="tblRequested">
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
    <div id="tabs-2" class="thbg" style="padding-left:0;padding-right:0;">
        <table id="tblInprogress">
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
    <div id="tabs-3" class="thbg" style="padding-left:0;padding-right:0;">
        <table id="tblCompleted">
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
                <th>Vendor</th>
            </tr>
        </thead>
        <tbody id="item-list"></tbody>
    </table>
<input type="button" class="sfBtn restro-btn icon-save" id="btnSaveRecquistion" value="Save">
</div>
</div>
</div>
