function ajaxCall(config, responseData) {
    $.ajax({
        type: config.type,
        contentType: config.contentType,
        async: config.async,
        cache: config.cache,
        url: config.url,
        data: config.data,
        dataType: config.dataType,
        success: function (response) {
            if (response != null && response['d'] != null) {
                responseData(response['d']);
            } else {
                responseData(response);
            }
        },
        error: function (error) {
            console.log('error :', config.url, ' => ', error)
            throw error;
        }
    });
}

function formatNumber(x, showDecimal = true) {
    var money = "";
    var regex = /\B(?=(\d{3})+(?!\d))/g;
    if (![null, undefined, ''].includes(x)) {
        var properValue = parseInt(x * 100) / 100;
        if (showDecimal) {
            money = properValue.toString().replace(regex, ",");
        } else {
            var withoutDecimal = properValue.toString().toString().split('.')[0];
            money = withoutDecimal.replace(regex, ",");
        }
        return money;
    } else {
        return x;
    }
}