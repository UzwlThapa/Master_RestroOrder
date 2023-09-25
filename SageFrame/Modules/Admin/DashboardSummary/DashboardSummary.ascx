<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DashboardSummary.ascx.cs" Inherits="Modules_Admin_DashboardSummary_DashboardSummary" %>
<%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="../src/jquery.jqplot.js"></script>
<script type="text/javascript" src="../src/plugins/jqplot.dateAxisRenderer.js"></script>
<script type="text/javascript" src="../src/plugins/jqplot.logAxisRenderer.js"></script>
<script type="text/javascript" src="../src/plugins/jqplot.canvasTextRenderer.js"></script>
<script type="text/javascript" src="../src/plugins/jqplot.canvasAxisTickRenderer.js"></script>
<script type="text/javascript" src="../src/plugins/jqplot.highlighter.js"></script>
<link rel="stylesheet" type="text/css" href="../src/jquery.jqplot.css" />
<link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.0/themes/smoothness/jquery-ui.css" />--%>
<script>
    $(function () {
        $(this).companyProfEDIT({

        });
    });
</script>
<div class="dbSummary">

    <div class="dbsum-topsection clearfix">
        <div class="sfCol_70">
            <div class="clearfix">
                <div class="sfCol_97 dbsummation-total-sales" id="chart1"></div>
                <div class="sfCol_97 dbsummation-total-sales" id="chart2"></div>
            </div>
        </div>


        <div class="sfCol_30 popular-stats">
          
        </div>
    </div>
    </div>

