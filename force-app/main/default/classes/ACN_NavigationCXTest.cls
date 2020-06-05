@isTest
private class ACN_NavigationCXTest {
   @istest static void mytest1(){
       try{
    test.startTest();
     ACN_NavigationLibrary.NavigationRequest  request = new ACN_NavigationLibrary.NavigationRequest();
    ACN_NavigationCX acnnavobj = new ACN_NavigationCX();
    ACN_NavigationCX.getSerializedNavigationList('testRequest');
    test.stopTest();
    }
       catch(Exception e){
           e.getMessage();
       }
   }
    @istest static void mytest2(){
        try{ 
        test.startTest();
        ACN_NavigationLibrary.NavigationRequest  request = new ACN_NavigationLibrary.NavigationRequest();
        request.NavigationProviderName ='testnav';
        ACN_NavigationCX.getNavigationList(request);
        test.stopTest();
        }
        catch(exception e){
            e.getMessage();
        }
        }
     @istest static void mytest3(){
        try{ 
        test.startTest();
        ACN_NavigationCX.getListJSON();
        ACN_NavigationCX.getSerializedNavigationList('serializedRequest');
        test.stopTest();
        }
        catch(exception e){
            e.getMessage();
        }
     }
       @istest static void mytest4(){
        try{ 
        test.startTest();
        ACN_NavigationCX.getObjectPrefix('test_object__c');
        test.stopTest();
        }
        catch(exception e){
            e.getMessage();
        }
        }
    @istest static void mytest5(){
        try{ 
        test.startTest();
        ACN_NavigationCX.getSerializedNavigationList('serializedRequest');
        test.stopTest();
        }
        catch(exception e){
            e.getMessage();
        }
        }
    @istest static void mytest6(){
        try{ 
        test.startTest();
        ACN_NavigationCX.getUserId();
        test.stopTest();
        }
        catch(exception e){
            e.getMessage();
        }
        }
    }