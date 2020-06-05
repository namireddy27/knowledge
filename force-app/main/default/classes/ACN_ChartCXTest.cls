@isTest
private class ACN_ChartCXTest {
    @isTest static void test1(){
        try{
        test.startTest();
        ACN_ChartConfiguration__c ChartProviderSettings1 = new ACN_ChartConfiguration__c();
        ACN_ChartDataProvider chartDataProvider1;
        ACN_ChartLibrary.ChartRequest requestobj = new ACN_ChartLibrary.ChartRequest();
        requestobj.ChartDataProviderName='test data';
        ACN_ChartCX testchart = new ACN_ChartCX();
        ACN_ChartCX.getChartResponse(requestobj);
        test.stopTest();
        }
        catch(Exception e){
      e.getMessage();
}
    }
     @isTest static void test2(){
        try{
           ACN_ChartLibrary.ChartRequest requestobj = new ACN_ChartLibrary.ChartRequest();
           ACN_ChartCX.getChartResponse(requestobj);  
        }
         catch(exception e){
             e.getMessage();
         }
}
    @isTest static void test3(){
        try{
           ACN_ChartCX.getResponseJSON();  
        }
         catch(exception e){
             e.getMessage();
         }
}
      @istest static void mytest4(){
        try{ 
        test.startTest();
        ACN_ChartCX.getUserId();
        test.stopTest();
        }
        catch(exception e){
            e.getMessage();
        }
        }
    @istest static void mytest5(){
        try{ 
        test.startTest();
        ACN_ChartCX.getSerializedChartResponse('testresponse');
        test.stopTest();
        }
        catch(exception e){
            e.getMessage();
        }
        }
    @istest static void mytest6(){
        try{ 
        test.startTest();
        ACN_ChartCX.getObjectPrefix('test_object__c');
        test.stopTest();
        }
        catch(exception e){
            e.getMessage();
        }
        }
     @istest static void mytest7(){
        try{ 
        test.startTest();
        ACN_ChartCX.getChartData('test provider');
        test.stopTest();
        }
        catch(exception e){
            e.getMessage();
        }
        }
}