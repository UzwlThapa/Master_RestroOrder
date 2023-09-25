using System;
using System.Collections.Generic;

namespace SageFrame.RestroOrder
{

    public class NumberToEnglish
    {
        public static CurrencyClass currency;
        public String changeNumericToWords(double numb)
        {
            String num = numb.ToString();
            return changeToWords(num, false);
        }

        public String changeCurrencyToWords(String numb)
        {
            return NumberConverter.NumberToWords(int.Parse(numb.ToString()));
            //return changeToWords(numb, true);
        }

        public String changeNumericToWords(String numb)
        {
            return changeToWords(numb, false);
        }

        public String changeCurrencyToWords(double numb)
        {
            return NumberConverter.DecimalToWord(Convert.ToDecimal(numb));
            //return changeToWords(numb.ToString(), true);
        }

        private String changeToWords(String numb, bool isCurrency)
        {
            String val = "", wholeNo = numb, points = "", andStr = "", pointStr = "";
            String endStr = (isCurrency) ? ("Only") : ("");
            try
            {
                int decimalPlace = numb.IndexOf(".");
                if (decimalPlace > 0)
                {
                    wholeNo = numb.Substring(0, decimalPlace);
                    points = numb.Substring(decimalPlace + 1);
                    if (Convert.ToInt32(points) > 0)
                    {
                        //RestrOrderController roc = new RestrOrderController();
                        //List<companyInfo> comList = roc.getcompanyInfo();
                        //companyInfo company = comList[0];
                        //CurrencyClass currency = roc.GetCurrencyBYId(company.CurrencyID);
                        andStr = (isCurrency) ? ("Rupees and") : ("point");// just to separate whole numbers from points/Rupees
                        //endStr = (isCurrency) ? ("Rupees " + endStr) : ("");
                        endStr = (isCurrency) ? ("Paisa " + endStr) : ("");
                        //endStr = (isCurrency) ? (currency.SubCurrencyName + endStr) : ("");
                        pointStr = translateRupees(points);
                    }
                }
                val = String.Format("{0} {1}{2} {3}", translateWholeNumber(wholeNo).Trim(), andStr, pointStr, endStr);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return val;
        }
        public void GetCurrency()
        {
            RestrOrderController roc = new RestrOrderController();
            List<companyInfo> comList = roc.getcompanyInfo();
            companyInfo company = comList[0];
            currency = roc.GetCurrencyBYId(company.CurrencyID);
        }

        private String translateWholeNumber(String number)
        {
            string word = "";
            try
            {
                bool beginsZero = false;//tests for 0XX
                bool isDone = false;//test if already translated
                double dblAmt = (Convert.ToDouble(number));
                //if ((dblAmt > 0) && number.StartsWith("0"))

                if (dblAmt > 0)
                {//test for zero or digit zero in a nuemric
                    beginsZero = number.StartsWith("0");
                    int numDigits = number.Length;
                    int pos = 0;//store digit grouping
                    String place = "";//digit grouping name:hundres,thousand,etc...
                    switch (numDigits)
                    {
                        case 1://ones' range
                            word = ones(number);
                            isDone = true;
                            break;
                        case 2://tens' range
                            word = tens(number);
                            isDone = true;
                            break;
                        case 3://hundreds' range
                            if (beginsZero)
                            {
                                pos = (numDigits % 3) + 1;
                                break;
                            }
                            pos = (numDigits % 3) + 1;
                            place = " Hundred ";
                            break;
                        case 4://thousands' range
                        case 5:
                        case 6:
                            pos = (numDigits % 4) + 1;
                            place = " Thousand ";
                            break;
                        case 7://millions' range
                        case 8:
                        case 9:
                            pos = (numDigits % 7) + 1;
                            place = " Million ";
                            break;
                        case 10://Billions's range
                            pos = (numDigits % 10) + 1;
                            place = " Billion ";
                            break;
                        //add extra case options for anything above Billion...
                        default:
                            isDone = true;
                            break;
                    }
                    if (!isDone)
                    {//if transalation is not done, continue...(Recursion comes in now!!)
                        word = translateWholeNumber(number.Substring(0, pos)) + place + translateWholeNumber(number.Substring(pos));
                        //check for trailing zeros
                        if (beginsZero) word = "Rupees and " + word.Trim();
                    }
                    //ignore digit grouping names
                    if (word.Trim().Equals(place.Trim())) word = "";
                }
            }
            catch
            {
                ;
            }
            return word.Trim();
        }

        private String tens(String digit)
        {
            int digt = Convert.ToInt32(digit);
            String name = null;
            switch (digt)
            {
                case 10:
                    name = "Ten";
                    break;
                case 11:
                    name = "Eleven";
                    break;
                case 12:
                    name = "Twelve";
                    break;
                case 13:
                    name = "Thirteen";
                    break;
                case 14:
                    name = "Fourteen";
                    break;
                case 15:
                    name = "Fifteen";
                    break;
                case 16:
                    name = "Sixteen";
                    break;
                case 17:
                    name = "Seventeen";
                    break;
                case 18:
                    name = "Eighteen";
                    break;
                case 19:
                    name = "Nineteen";
                    break;
                case 20:
                    name = "Twenty";
                    break;
                case 30:
                    name = "Thirty";
                    break;
                case 40:
                    name = "Fourty";
                    break;
                case 50:
                    name = "Fifty";
                    break;
                case 60:
                    name = "Sixty";
                    break;
                case 70:
                    name = "Seventy";
                    break;
                case 80:
                    name = "Eighty";
                    break;
                case 90:
                    name = "Ninety";
                    break;
                default:
                    if (digt > 0)
                    {
                        name = tens(digit.Substring(0, 1) + "0") + " " + ones(digit.Substring(1));
                    }
                    break;
            }
            return name;
        }

        private String ones(String digit)
        {
            int digt = Convert.ToInt32(digit);
            String name = "";
            switch (digt)
            {
                case 1:
                    name = "One";
                    break;
                case 2:
                    name = "Two";
                    break;
                case 3:
                    name = "Three";
                    break;
                case 4:
                    name = "Four";
                    break;
                case 5:
                    name = "Five";
                    break;
                case 6:
                    name = "Six";
                    break;
                case 7:
                    name = "Seven";
                    break;
                case 8:
                    name = "Eight";
                    break;
                case 9:
                    name = "Nine";
                    break;
            }
            return name;
        }

        private String translateRupees(String Rupees)
        {
            String cts = "", digit = "", engOne = "";
            for (int i = 0; i < Rupees.Length; i++)
            {
                digit = Rupees[i].ToString();
                if (digit.Equals("0"))
                {
                    engOne = "Zero";
                }
                else
                {
                    engOne = ones(digit);
                }
                // engOne = ones(digit);

                //cts += currency.CurrencyName + " " + engOne;
                cts += " " + engOne;
            }
            return cts;
        }
    }

    public static class NumberConverter
    {
        public static string DecimalToWord(decimal number)
        {
            string result = NumberConverter.NumberToWords(decimal.ToInt32(number));
            result += " Rupees";
            int value = decimal.ToInt32(number * 100) % 100;
            if (value > 0)
            {
                result += " " + NumberConverter.NumberToWords(value) + " Paisa Only";
            }
            return result;
        }

        public static string NumberToWords(int number)
        {
            if (number == 0)
                return "zero";
            if (number < 0)
                return "minus " + NumberToWords(Math.Abs(number));
            string words = "";
            if ((number / 1000000) > 0)
            {
                words += NumberToWords(number / 1000000) + " Million ";
                number %= 1000000;
            }

            if ((number / 1000) > 0)
            {
                words += NumberToWords(number / 1000) + " Thousand ";
                number %= 1000;
            }

            if ((number / 100) > 0)
            {
                words += NumberToWords(number / 100) + " Hundred ";
                number %= 100;
            }

            if (number > 0)
            {
                if (words != "")
                    words += "and ";
                var unitsMap = new[]
                {
            "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"
            }

                ;
                var tensMap = new[]
                {
            "Zero", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"
            }

                ;
                if (number < 20)
                    words += unitsMap[number];
                else
                {
                    words += tensMap[number / 10];
                    if ((number % 10) > 0)
                        words += "-" + unitsMap[number % 10];
                }
            }

            return words;
        }
    }

}