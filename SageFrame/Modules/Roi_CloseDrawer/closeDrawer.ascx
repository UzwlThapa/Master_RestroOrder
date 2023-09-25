<%@ Control Language="C#" AutoEventWireup="true" CodeFile="closeDrawer.ascx.cs" Inherits="Modules_Roi_CloseDrawer_closeDrawer" %>
<div style="font-family: Arial">
    <h2>Close Drawer: Cash Drawer</h2>
    <hr />
    <h3>Enter the current drawer count (you'll record your deposit after this step)</h3>
    <div style="border: 1px;">
        <table>
            <thead>
                <tr>
                    <th>Bills:</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>$100</td>
                    <td>$50</td>
                    <td>$20</td>
                    <td>$10</td>
                    <td>$5</td>
                    <td>$2</td>
                    <td>$1</td>
                </tr>
                <tr>
                    <td>
                        <input type="text" id="b100" /></td>
                    <td>
                        <input type="text" id="b50" /></td>
                    <td>
                        <input type="text" id="b20" /></td>
                    <td>
                        <input type="text" id="b10" /></td>
                    <td>
                        <input type="text" id="b5" /></td>
                    <td>
                        <input type="text" id="b2" /></td>
                    <td>
                        <input type="text" id="b1" /></td>
                </tr>
                <tbody>
                </tbody>
        </table>
        <table>
            <thead>
                <tr>
                    <th>Coins:</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>50 cents</td>
                    <td>25 cents</td>
                    <td>10 cents</td>
                    <td>5 cents</td>
                    <td>1 cents</td>
                </tr>
                <tr>
                    <td>
                        <input type="text" id="c50" /></td>
                    <td>
                        <input type="text" id="c25" /></td>
                    <td>
                        <input type="text" id="c10" /></td>
                    <td>
                        <input type="text" id="c5" /></td>
                    <td>
                        <input type="text" id="c1" /></td>
                </tr>
            </tbody>
        </table>
        <table>
            <thead>
                <tr>
                    <th>Cheque:</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>In $:
                        <input type="text" id="txtCheque" placeholder="Add Check"/></td>
                </tr>
                <tbody>
                </tbody>
        </table>
        <h4>TOTAL COUNT: 
            <input type="text" id="txtTotalCount" style="border: 0;" />
        </h4>
        <br />
        <input type="button" id="AddOpenDrawer" value="OPEN DRAWER" />
        Approved By:
         <input type="text" id="txtApprovedBy" />
    </div>
</div>
