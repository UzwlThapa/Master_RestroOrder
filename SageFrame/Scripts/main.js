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

function formatMoney(x) {
    if (x != null) {
        return x.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    } else {
        return x;
    }
}