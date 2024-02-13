/***************************************************************
===============================================================
Purpose: Test class for StringUtils
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan       06/06/2023   QFCJ-3902  	  Initial draft
***************************************************************/
@isTest
public class StringUtilsTest {
    private static Map<Integer,String> testData = new Map<Integer,String> {
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
            19 => 'Nineteen',
            20 => 'Twenty',
            21 => 'Twenty-One',
            30 => 'Thirty',
            40 => 'Forty',
            50 => 'Fifty',
            60 => 'Sixty',
            70 => 'Seventy',
            80 => 'Eighty',
            90 => 'Ninety',
            100 => 'One Hundred',
            135 => 'One Hundred Thirty-Five',
            1000 => 'One Thousand',
            42559 => 'Forty-Two Thousand, Five Hundred Fifty-Nine',
            1000000 => 'One Million',
            13765345 => 'Thirteen Million, Seven Hundred Sixty-Five Thousand, Three Hundred Forty-Five',
            1000000000 => 'One Billion',
            1999888000 => 'One Billion, Nine Hundred Ninety-Nine Million, Eight Hundred Eighty-Eight Thousand',
            2147483647 => 'Two Billion, One Hundred Forty-Seven Million, Four Hundred Eighty-Three Thousand, Six Hundred Forty-Seven',
            -2147483647 => 'Negative Two Billion, One Hundred Forty-Seven Million, Four Hundred Eighty-Three Thousand, Six Hundred Forty-Seven'
            };
                
    @IsTest
    static void numberToTextTest(){
        // Arrange
        Map<Integer,String> results = new Map<Integer,String>();
        
        // Act
        Test.startTest();
        for(Integer key : testData.keySet()) {
            String result = StringUtils.convertIntToWords(key);
            results.put(key, result);
        }
        Test.stopTest();
                    
        // Assert
        for(Integer key : testData.keySet()) {
            System.assertEquals(testData.get(key), results.get(key), 'Test data should be equal');
        }
    }
    
    @IsTest
    static void toTitleCase(){
        String testData = 'now is the time for all good men to come to the aid of their country';
        String testResult = 'Now Is The Time For All Good Men To Come To The Aid Of Their Country';
        
        Test.startTest();
        
        String result = StringUtils.toTitleCase(testData);
        System.assertEquals(result, testResult, 'Test data should be equal');
        
        Test.stopTest();
    }
    
    @IsTest
    static void toProperCase(){
        String testData = 'now is the time for all good men to come to the aid of their country';
        String testResult = 'Now Is the Time for All Good Men to Come to the Aid of Their Country';
        
        Test.startTest();
        
        String result = StringUtils.toProperCase(testData);
        System.assertEquals(result, testResult, 'Test data should be equal');
        
        Test.stopTest();
    }
}