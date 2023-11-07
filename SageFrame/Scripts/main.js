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
        if (typeof x == 'number') {
            if (showDecimal) {
                money = x.toFixed(2).replace(regex, ",");
            } else {
                money = x.toString().replace(regex, ",");
            }

        } else {
            if (showDecimal) {
                money = parseFloat(x).toFixed(2).replace(regex, ",");
            } else {
                money = x.replace(regex, ",");
            }
        }
        return money;
    } else {
        return x;
    }
}