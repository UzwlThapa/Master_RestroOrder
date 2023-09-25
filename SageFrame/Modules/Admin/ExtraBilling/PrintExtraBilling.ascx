<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PrintExtraBilling.ascx.cs" Inherits="Modules_ExtraBilling_PrintExtraBilling" %>

<script type="text/javascript">
    $(document).ready(function () {
        //for printing
        //function print(){
        //    contents = ('<html><head><title></title>');
        //    contents += ('</head><style>div.actualpage {height: 100mm;width: 80mm;} div.page {} @media screen { div.page { margin: 0mm 0mm 0mm 0mm;} } @media print { div.page {margin: 0mm;}}</style><body>');
        //    var contents = document.getElementById("dvHtml").innerHTML;
        //    contents += ('</body></html>');



        //}

        function double() {
            var contents = document.getElementById("PrintDetails").innerHTML;
            var frame1 = document.createElement('iframe');
            frame1.name = "frame1";
            //frame1.style.position = "absolute";
            //frame1.css({ "position": "absolute", "top": "-1000000px" });
            //$("body").append(frame1);
            //frame1.style.top = "-1000000px";
            document.body.appendChild(frame1);
            var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
            frameDoc.document.open();
            //var asdf = '<html><head><title></title>' + '</head><body>' + contents + '</body>';
            frameDoc.document.write('<html><head><title></title>');
            frameDoc.document.write('</head><body>');
            //frameDoc.document.write('<link href="../../Core/Template/css/custom.css" rel="stylesheet" type="text/css" />');
            //frameDoc.document.write($.trim(asdf));
            frameDoc.document.write(contents);
            frameDoc.document.write('</body>');
            frameDoc.document.close();
            setTimeout(function () {
                window.frames["frame1"].focus();
                window.frames["frame1"].print();
                document.body.removeChild(frame1);
            }, 500);

        }

        $("#btnPrints").on("click", function (event) {


            double();
        });


        //function PrintDiv() {
        //    alert("Check");

        //    double();



        //};
    });

</script>

<h1>Billing</h1>


<div id="PrintDetails">
    <asp:Literal ID="PrintHtml" runat="server"> </asp:Literal>
    
</div>


<input type="button" id="btnPrints" onclick="PrintDiv();" value="Print"  class="sfBtn restro-btn" />