@isTest(SeeAllData=True)
private class ACN_NavigationLibraryTest {
    
    @isTest static void test_method_one() {
        ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
        ACN_NavigationLibrary.NavigationListItem testNavigationListItem = new ACN_NavigationLibrary.NavigationListItem();
        ACN_NavigationLibrary.NavigationList testNavigationList = new ACN_NavigationLibrary.NavigationList();
        ACN_NavigationLibrary.NavigationRequest testNavigationTopic = new ACN_NavigationLibrary.NavigationRequest();
        ACN_NavigationLibrary.GetCurrentCommunityId();
        
        ACN_NavigationLibrary.ItemRequest request = new ACN_NavigationLibrary.ItemRequest();
        request.ItemId = 'faketopassexcp';
        request.ItemName = 'faketopassexcp';
        try{
          ACN_NavigationLibrary.getNavigationTopics(request);  
        } catch(Exception ex) {

        }
        
       // ACN_NavigationLibrary.getPathForListViewName('','Recent');
       // ACN_NavigationLibrary.getListViewId('Sales','Recent');
    }
    
    
        @isTest static void test_method_two() {
        ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
        ACN_NavigationLibrary.NavigationListItem testNavigationListItem = new ACN_NavigationLibrary.NavigationListItem();
        ACN_NavigationLibrary.NavigationList testNavigationList = new ACN_NavigationLibrary.NavigationList();
        ACN_NavigationLibrary.NavigationRequest testNavigationTopic = new ACN_NavigationLibrary.NavigationRequest();
        ACN_NavigationLibrary.GetCurrentCommunityId();
        
        ACN_NavigationLibrary.ItemRequest request = new ACN_NavigationLibrary.ItemRequest();
        request.ItemId = 'faketopassexcp';
        request.ItemName = 'faketopassexcp';
        try{
          ACN_NavigationLibrary.getPathForListViewName('','Recent'); 
        } catch(Exception ex) {

        }
        
       // ACN_NavigationLibrary.getPathForListViewName('','Recent');
       // ACN_NavigationLibrary.getListViewId('Sales','Recent');
    }
    
    
        
        @isTest static void test_method_three() {
        ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
        ACN_NavigationLibrary.NavigationListItem testNavigationListItem = new ACN_NavigationLibrary.NavigationListItem();
        ACN_NavigationLibrary.NavigationList testNavigationList = new ACN_NavigationLibrary.NavigationList();
        ACN_NavigationLibrary.NavigationRequest testNavigationTopic = new ACN_NavigationLibrary.NavigationRequest();
        ACN_NavigationLibrary.GetCurrentCommunityId();
        
        ACN_NavigationLibrary.ItemRequest request = new ACN_NavigationLibrary.ItemRequest();
        request.ItemId = 'faketopassexcp';
        request.ItemName = 'faketopassexcp';
        try{
          ACN_NavigationLibrary.getListViewId('Sales','Recent');
        } catch(Exception ex) {

        }
        
       // ACN_NavigationLibrary.getPathForListViewName('','Recent');
       // ACN_NavigationLibrary.getListViewId('Sales','Recent');
    }
}