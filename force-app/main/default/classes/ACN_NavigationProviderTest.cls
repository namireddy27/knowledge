@isTest(SeeAllData = true)
private class ACN_NavigationProviderTest {
    
    @isTest static void testNavigationProviderNameException() {
        ACN_NavigationProvider nav = new ACN_NavigationProvider('ACN_CustomObjectListViewProvider');
         ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        try{
           nav.GoUp(request); 
        } catch(Exception ex){
            System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException',ex.getTypeName() );
        }
    }
       @isTest static void testNavigationProviderNameException1() {
        ACN_NavigationProvider nav = new ACN_NavigationProvider('ACN_CustomObjectListViewProvider');
         ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        try{
           nav.GoPrevious(request); 
        } catch(Exception ex){
            System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException',ex.getTypeName() );
        }
    }
        @isTest static void testNavigationProviderNameException2() {
        ACN_NavigationProvider nav = new ACN_NavigationProvider('ACN_CustomObjectListViewProvider');
         ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        try{
           nav.GoNext(request); 
        } catch(Exception ex){
            System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException',ex.getTypeName() );
        }
    }
        @isTest static void testNavigationProviderNameException3() {
        ACN_NavigationProvider nav = new ACN_NavigationProvider('ACN_CustomObjectListViewProvider');
         ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        try{
           nav.GoLast(request); 
        } catch(Exception ex){
            System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException',ex.getTypeName() );
        }
    }
        @isTest static void testNavigationProviderNameException4() {
        ACN_NavigationProvider nav = new ACN_NavigationProvider('ACN_CustomObjectListViewProvider');
         ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        try{
           nav.SavePreference(request); 
        } catch(Exception ex){
            System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException',ex.getTypeName() );
        }
    }    @isTest static void testNavigationProviderNameException5() {
        ACN_NavigationProvider nav = new ACN_NavigationProvider('ACN_CustomObjectListViewProvider');
         ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        try{
           nav.LoadPreference(request); 
        } catch(Exception ex){
            System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException',ex.getTypeName() );
        }
    }
        @isTest static void testNavigationProviderNameException6() {
        ACN_NavigationProvider nav = new ACN_NavigationProvider('ACN_CustomObjectListViewProvider');
         ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        try{
           nav.GetNavigationList(request); 
        } catch(Exception ex){
            System.assertEquals('System.NullPointerException',ex.getTypeName() );
        }
    } 
    
}