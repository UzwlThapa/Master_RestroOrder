function moneyPlaceholder(x) {
	if(x != null){ 
		x = parseFloat(x).toFixed(2);
		return x.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	} else {
		return 0;
	}
}