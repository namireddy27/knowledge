@isTest
public class ACN_CustomObjectListViewProvider2Test {
    @isTest(SeeAllData=true) static void testGetNavigationList() {
        
        List<Topic> tl = [SELECT Name FROM Topic WHERE NetworkId != ''];
        System.debug('Topic query returned ' + tl.size() + ' topics. toString: ' + tl);
        
        Map<String, String> testUserDataMap = ACN_NavigationTestData.fillUserDataMap1();
        Id testUserProfileId = ACN_NavigationTestData.getProfileId('System Administrator');
        User testUser = ACN_NavigationTestData.createUser(testUserDataMap, testUserProfileId, null);
        insert testUser;
        
        ACN_CommunityNavigationConfig__c testCustomSetting = new ACN_CommunityNavigationConfig__c();
        testCustomSetting.SetupOwnerId = testUser.Id;
        testCustomSetting.ListViewProviderQueryFieldSet__c = 'ListViewProviderQueryFields';
        testCustomSetting.NavigationItemsLimit__c = 20;
        testCustomSetting.NavigationProviderServices__c = 'ACN_CustomObjectListViewProvider';
        insert testCustomSetting;
        
        List<Schema.FieldSetMember> fieldList = 
            SObjectType.ACN_NavigationItem__c.FieldSets.getMap().get(
                testCustomSetting.ListViewProviderQueryFieldSet__c).getFields();
        System.runAs(testUser) {
            
            ACN_CommunityNavigationConfig__c navSettings = ACN_CommunityNavigationConfig__c.getInstance();
            System.debug('Test>>> navSettings: ' + navSettings);
            //  ACN_CustomObjectListViewProvider provider = new ACN_CustomObjectListViewProvider();
            ACN_NavigationProvider provider = new ACN_NavigationProvider('ACN_NavigationProvider');
            ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
            request.Id = '';
            request.BrowserFormFactor= 'phone';
            
            
            
            
            provider.GetNavigationList(request);
            request.id = 'rated';
            
            provider.GetNavigationList(request); 
            request.id = 'userpreferences';
            provider.GetNavigationList(request); 
            request.id = 'Random String Test';
            provider.GetNavigationList(request); 
            
        }
    }
    
    @isTest static void testNonImplementedMethods() {
        Map<String, String> testUserDataMap = ACN_NavigationTestData.fillUserDataMap1();
        Id testUserProfileId = ACN_NavigationTestData.getProfileId('System Administrator');
        System.debug('Profile Id: ' + testUserProfileId);
        User testUser = ACN_NavigationTestData.createUser(testUserDataMap, testUserProfileId, null);
        
        insert testUser;
        
        ACN_CommunityNavigationConfig__c testCustomSetting = new ACN_CommunityNavigationConfig__c();
        testCustomSetting.SetupOwnerId = testUser.Id;
        testCustomSetting.ListViewProviderQueryFieldSet__c = 'ListViewProviderQueryFields';
        testCustomSetting.NavigationItemsLimit__c = 20;
        testCustomSetting.NavigationProviderServices__c = 'ACN_CustomObjectListViewProvider';
        testCustomSetting.NavigationProvider__c = 'ACN_CustomObjectListViewProvider';
        insert testCustomSetting;
        
        System.runAs(testUser) {
            ACN_NavigationProvider provider = new ACN_NavigationProvider(testCustomSetting.NavigationProvider__c);
            ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
            
            
            
            
            
            try {
                provider.GoUp(request);
                System.assert(false, 'Should not be able to reach this assertion, an Exception is expected.');
            }
            catch(Exception e)
            {
                System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException', e.getTypeName(), 'Exception type should be MethodNotImplementedException');
            }
            
            try {
                provider.GoPrevious(request);
                System.assert(false, 'Should not be able to reach this assertion, an Exception is expected.');
            }
            catch(Exception e)
            {
                System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException', e.getTypeName(), 'Exception type should be MethodNotImplementedException');
            }
            
            try {
                provider.GoNext(request);
                System.assert(false, 'Should not be able to reach this assertion, an Exception is expected.');
            }
            catch(Exception e)
            {
                System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException', e.getTypeName(), 'Exception type should be MethodNotImplementedException');
            }
            
            try {
                provider.GoLast(request);
                System.assert(false, 'Should not be able to reach this assertion, an Exception is expected.');
            }
            catch(Exception e)
            {
                System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException', e.getTypeName(), 'Exception type should be MethodNotImplementedException');
            }
            
            try {
                provider.SavePreference(request);
                System.assert(false, 'Should not be able to reach this assertion, an Exception is expected.');
            }
            catch(Exception e)
            {
                System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException', e.getTypeName(), 'Exception type should be MethodNotImplementedException');
            }
            
            try {
                provider.LoadPreference(request);
                System.assert(false, 'Should not be able to reach this assertion, an Exception is expected.');
            }
            catch(Exception e)
            {
                System.assertEquals('ACN_NavigationLibrary.MethodNotImplementedException', e.getTypeName(), 'Exception type should be MethodNotImplementedException');
            }
        }
        
    }
    
}