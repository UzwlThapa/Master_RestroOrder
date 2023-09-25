
var currentZoom = 1;
$('.ROBlocks a').click(function() {
    currentZoom += 0.1;
    $('body').css({
        zoom: currentZoom,
        '-moz-transform': 'scale(' + currentZoom + ')'
    });
});


function resizeIframe() {
    var contheight = $('.RO_wrapper').height() + 40;
    parent.$.colorbox.resize({
        height: contheight
    });


    $('.RO_wrapper .sfBtn , .RO_wrapper .icon-edit').on('click', function () {
        resizeIframe();
    });
}


function refreshIframe() {
 location.reload(true);
}


    (function($){
        $(window).on("load",function(){
            $("#sfLandingpage , .ROblockpart ul").mCustomScrollbar();
        });
    })(jQuery);

    function closeIframe(){
        parent.jQuery.colorbox.close();
    }

  

    $(window).bind("load", function() {
   $(".ROblockpart > li ul li").delay(2000).fadeIn(500).css('display','inline-block');
});

      $(window).bind("load", function() {
   $(".layoutall").delay(500).fadeIn(500).css('display','block');
});

    //   $(window).scroll(function () {
    //     if ( $(window).width() > 768 && $(this).scrollTop() > 100 ) {

    //         $('.Report_header').addClass('header-fixed fadeInDown animated');
    //     } 
       
    // else {
    //         $('.Report_header').removeClass('header-fixed fadeInDown animated');
    //     }
    // });



