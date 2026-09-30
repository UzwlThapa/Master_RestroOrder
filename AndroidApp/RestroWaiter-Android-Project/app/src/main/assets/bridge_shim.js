/**
 * RestroWaiter Native Bridge Shim
 * Injected automatically on page load inside WebView.
 */
(function() {
  console.log("[RestroWaiter] Initializing native JavaScript bridge hooks...");

  // 1. Override DashboardFunction.print
  if (typeof window.DashboardFunction !== 'undefined') {
    window.DashboardFunction.print = function(htmlSlip) {
      if (window.WaiterApp && window.WaiterApp.print) {
        console.log("[RestroWaiter] Intercepted web print, routing to native ESC/POS thermal...");
        window.WaiterApp.print(htmlSlip || document.getElementById('divPrintArea')?.innerHTML || '', 'bill');
      } else {
        window.print();
      }
    };
  }

  // 2. Intercept jQuery AJAX for SaveSalesBill
  if (typeof window.jQuery !== 'undefined') {
    var originalAjax = window.jQuery.ajax;
    window.jQuery.ajax = function(options) {
      if (options && options.url && options.url.indexOf('SaveSalesBill') !== -1) {
        console.log("[RestroWaiter] Intercepted SaveSalesBill payload:", options.data);
        if (window.WaiterApp && window.WaiterApp.captureOrder) {
          window.WaiterApp.captureOrder(typeof options.data === 'string' ? options.data : JSON.stringify(options.data));
        }
      }
      return originalAjax.apply(this, arguments);
    };
  }

  // 3. Inject Mobile Responsive Ergonomics
  var style = document.createElement('style');
  style.innerHTML = `
    /* Enforce touch targets >= 48px */
    .button, button, input[type="button"], .tableBtn {
      min-height: 48px !important;
      min-width: 48px !important;
      font-size: 15px !important;
      touch-action: manipulation;
    }
    /* Hide desktop admin sidebar headers on tablets */
    #divAdminHeader, .sfAdminbar, #sfFooter {
      display: none !important;
    }
    /* Sticky footer with active table total */
    body {
      padding-bottom: 56px !important;
    }
  `;
  document.head.appendChild(style);
})();
