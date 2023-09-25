<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CallWaiter.ascx.cs" Inherits="Modules_CallWaiter_CallWaiter" %>

<script type="text/javascript">

    $(function () {
        $(this).callWaiterEDIT({
            HostUrl: "<%= HostUrl %>",
            TypeId: "<%=TypeId%>"
        });
         resizeIframe();
    });

</script>

<div class="RO_wrapper">
<div id="callwaiterDiv" style="text-align:center;">
    <ul>
        <li id="callwaiter" style="display:none;">
            <%--<img src="images/waiter-call.png">--%>
            <h2>Call Waiter</h2>
        </li>
    </ul>
</div>
</div>


