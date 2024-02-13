/***************************************************************
===============================================================
Purpose: StringUtils class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan       06/06/2023   QFCJ-3902  	  Initial draft
***************************************************************/
global with sharing class StringUtils {
    // https://www.sfdc-code.com/converting-numbers-to-text/
    // max value 2,147,483,647
    // Todd Boyd
        static final Integer DIGITS_PER_SET = 3;
        static final String ZERO = 'Zero';
        private static Map<Integer,String> tens = new Map<Integer,String> {
            20 => 'Twenty',
            30 => 'Thirty',
            40 => 'Forty',
            50 => 'Fifty',
            60 => 'Sixty',
            70 => 'Seventy',
            80 => 'Eighty',
            90 => 'Ninety'
        };
        private static Map<Integer,String> smallNumbers = new Map<Integer,String> {
            0 => 'Zero',
            1 => 'One',
            2 => 'Two',
            3 => 'Three',
            4 => 'Four',
            5 => 'Five',
            6 => 'Six',
            7 => 'Seven',
            8 => 'Eight',
            9 => 'Nine',
            10 => 'Ten',
            11 => 'Eleven',
            12 => 'Twelve',
            13 => 'Thirteen',
            14 => 'Fourteen',
            15 => 'Fifteen',
            16 => 'Sixteen',
            17 => 'Seventeen',
            18 => 'Eighteen',
            19 => 'Nineteen'
        };
        private static Map<Integer,String> modifiers = new Map<Integer,String> {
            1 => 'Thousand, ',
            2 => 'Million, ',
            3 => 'Billion, '
        };    
        
        public static String convertIntToWords(Integer value) {
            // zero is a special case
            if (value == 0) {
                return ZERO;
            }
    
            // text representation of the number to convert. e.g. 'one hundred'
            String numberText = '';
    
            // If value is negative prepend the text with 'negative'
            // and then process as a positive value
            if (value < 0) {
                numberText = 'Negative ';
                value *= -1;
            }
    
            // string representation of the number to convert. e.g. '100'
            String numberString = String.valueOf(value);
    
            // split the number into sets (hundreds, thousands, millions, billions)
            // and convert each as a three digit number.
            while(numberString.length() > 0){
                // Figure out how many digits are in this set
                Integer digits = Math.mod(numberString.length(), DIGITS_PER_SET) == 0 ?
                                 DIGITS_PER_SET :
                                 Math.mod(numberString.length(), DIGITS_PER_SET);
    
                // Create a string to represent this set.
                String thisSet = numberString.substring(0, digits);
    
                // Convert the set into an integer and generate the text for this set.
                Integer valueToConvert = Integer.valueOf(thisSet);
    
                // Remove the first set from numberString now that it has been converted.
                numberString = numberString.substring(digits, numberString.length());
    
                if (valueToConvert > 0) {                
                    String setText = generateText(valueToConvert);
    
                    // Calculate the modifierIndex to determine what set this is
                    // e.g. thousands, millions, billions.
                    Integer modifierKey = numberString.length() / DIGITS_PER_SET;
    
                    // Create the modifier string
                    String modifier = modifierKey > 0 ? ' ' + modifiers.get(modifierKey) : '  ';
    
                    // Build the text
                    numberText += setText + modifier;
                }
            }
            return numberText.substring(0, (numberText.length() - 2)).trim();
        }
    
        private static String generateText(Integer value) {
            if (value < 100) {
                return generateTextForTwoDigits(value);
            }
    
            String numberText = '';
    
            // Calculate the number of hundreds
            Integer hundreds = value / 100;
            if (hundreds > 0) {
                numberText = generateTextForTwoDigits(hundreds) + ' Hundred';
            }
    
            // Calculate the leftover value
            Integer leftOver = Math.mod(value, 100);
            if (leftOver > 0) {
                numberText += ' ' + generateTextForTwoDigits(leftOver);
            }
            return numberText;
        }
    
        private static String generateTextForTwoDigits(Integer value) {
            if (value < 20) {
                return smallNumbers.get(value);
            }
    
            // Round the value down to the nearest 10 and get the text representation
            Integer tensKey = (value/10) * 10;
            String numberText = tens.get(tensKey);
    
            // Calculate the leftover value
            Integer leftOver = value - tensKey;
    
            if (leftOver > 0) {
                // Add a hypen for values between 21 - 99.
                // https://www.grammarly.com/blog/hyphen-in-compound-numbers/
                if (tensKey >= 20 && tensKey <= 90 && leftOver > 0) {
                    numberText += '-';
                }
                numberText += generateTextForTwoDigits(leftOver);
            }
            return numberText;
        }
        
    //converts a given string to Title Case where the
    //first letter of every word is capitalized and the rest are small
    //with the exception of a few key words, those are made lowercase
        public static String toProperCase(String value){
            value = value.toLowerCase();
            
            List<String> pieces = new List<String>();
            
            //a set of words that should always (or at least, almost always) be in lower case when in Proper Case
            //eg: The Day of the Jackal.  First and last word of a phrase should always be Capped though.
            Set<String> forceLower = new Set<String>{'of', 'the', 'for', 'and', 'a', 'to', 'at' ,'an', 'but', 'if', 'or', 'nor'};
            
            if(value != null && value.length() > 0) {
                String[] splitPhrase = value.trim().split(' ');
                
                for(integer i = 0; i < splitPhrase.size(); i++){
                    if(!forceLower.contains(splitPhrase[i]) || i == 0 || i == (splitPhrase.size() - 1) ){
                        pieces.add(splitPhrase[i].capitalize());
                    }else{
                        pieces.add(splitPhrase[i]);
                    }
                }
            }
            return String.join(pieces, ' ');
        }
    
    //converts a given string to Title Case where the
    //first letter of every word is capitalized and the rest are small
        public static String toTitleCase(String value) {
            // Normalize - Convert to lowercase
            value = value.toLowerCase();
    
            // Hold each word
            List<String> pieces = new List<String>();
    
            // Split
            for(String s : value.split(' ')) {
                // Capitalize each piece
                s = s.capitalize();
    
                // Add to pieces
                pieces.add(s);
            }
    
            // Join
            return String.join(pieces, ' ');
        }
    }