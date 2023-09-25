<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROIUnitDefine.ascx.cs" Inherits="Modules_ROIUnitDefine_ROIUnitDefine" %>

<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            Username: '<%=Username%>'

        });
    });


</script>

<div id="tabs">
    <ul>
        <li><a href="#tab">Unit Define</a></li>
    </ul>
    <div id="tab">
<table style="display:block">
    <tr>
        <td>
            Item :
        </td>
        <td>
            <select id="ddlitem" class="sfInputbox" style="width:200px;">
                
            </select>
        </td>
        </tr>
    <tr>
        <td>
        Quantity :
        </td>
        <td>
            <input type="text" id="txtQuentity" class="required" />
        </td>
        </tr>
    <tr>
        <td>
            Unit : 
        </td>
        <td>
            <select id="ddlunits" class="required sfInputbox" style="width:200px;"></select>

        </td>
    </tr>
</table>
</div>