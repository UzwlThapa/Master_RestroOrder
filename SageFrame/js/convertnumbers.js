
        function convertNumberToWords(inputval) {

            var number = $.trim(inputval);

            if (number < 0) {
                console.log("Number Must be greater than zero = " + number);
                return "";
            }

            if (number > 100000000000000000000) {
                console.log("Number is out of range = " + number);
                return "";
            }

            if (!((typeof number === 'number' || typeof number === 'string') && number !== '' && !isNaN(number))) {
                console.log("Not a number = " + number);
                return "";
            }

            var quintillion = Math.floor(number / 1000000000000000000); /* quintillion */
            number -= quintillion * 1000000000000000000;
            var quar = Math.floor(number / 1000000000000000); /* quadrillion */
            number -= quar * 1000000000000000;
            var trin = Math.floor(number / 1000000000000); /* trillion */
            number -= trin * 1000000000000;
            var Gn = Math.floor(number / 1000000000); /* billion */
            number -= Gn * 1000000000;
            var million = Math.floor(number / 1000000); /* million */
            number -= million * 1000000;
            var Hn = Math.floor(number / 1000); /* thousand */
            number -= Hn * 1000;
            var Dn = Math.floor(number / 100); /* tens (deca) */
            number = number % 100; /* ones */
            var tn = Math.floor(number / 10);
            var one = Math.floor(number % 10);
            var res = "";

            if (quintillion > 0) {
                res += (((res == "") ? "" : " ") + convertNumberToWords(quintillion) + " quintillion");
            }
            if (quar > 0) {
                res += (((res == "") ? "" : " ") + convertNumberToWords(quar) + " quadrillion");
            }
            if (trin > 0) {
                res += (((res == "") ? "" : " ") + convertNumberToWords(trin) + " trillion");
            }
            if (Gn > 0) {
                res += (((res == "") ? "" : " ") + convertNumberToWords(Gn) + " billion");
            }
            if (million > 0) {
                res += (((res == "") ? "" : " ") + convertNumberToWords(million) + " million");
            }
            if (Hn > 0) {
                res += (((res == "") ? "" : " ") + convertNumberToWords(Hn) + " thousand");
            }
            if (Dn) {
                res += (((res == "") ? "" : " ") + convertNumberToWords(Dn) + " hundred");
            }

            var ones = Array("", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen");
            var tens = Array("", "", "twenty", "thirty", "fourty", "fifty", "sixty", "seventy", "eighty", "ninety");
            if (tn > 0 || one > 0) {
                if (!(res == "")) {
                    res += " and ";
                }
                if (tn < 2) {
                    res += ones[tn * 10 + one];
                } else {
                    res += tens[tn];
                    if (one > 0) {
                        res += ("-" + ones[one]);
                    }
                }
            }
            return res.charAt(0).toUpperCase() + res.slice(1).toLowerCase();
        }

        // Iterate all elements the selector applies to
        $(this).each(function () {
            var $input = $(this);
            //bind if it is a textbox
            if ($input.is("input[type='text']")) {
                // Now bind to the keyup event of this individual input (keyup instead of keydown so we know which key was pressed!)
                $input.on("keyup", function () {
                    $input.nextAll('div.numwordholder').remove();
                    var convertedWords = convertNumberToWords($input.val())

                    if (convertedWords != null && convertedWords != "") {
                        $input.after('<div class="numwordholder"><span class="numword">' + convertedWords + '</span></div>');
                    }
                });
            }
        });
