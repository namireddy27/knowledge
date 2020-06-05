@isTest
public class ACN_PublicCustObjListViewProviderTest {
    @isTest
    public static void GetNavigationListTestMethod(){
        List<Topic> tl = [SELECT Name FROM Topic WHERE NetworkId != ''];
        System.debug('Topic query returned ' + tl.size() + ' topics. toString: ' + tl);

        Map<String, String> testUserDataMap = ACN_NavigationTestData.fillUserDataMap1();
        Id testUserProfileId = ACN_NavigationTestData.getProfileId('SFR System Administrator');
        User testUser = ACN_NavigationTestData.createUser(testUserDataMap, testUserProfileId, null);
        //insert testUser;

        ACN_CommunityNavigationConfig__c testCustomSetting = new ACN_CommunityNavigationConfig__c();
        testCustomSetting.SetupOwnerId = testUser.Id;
        testCustomSetting.ListViewProviderQueryFieldSet__c = 'ListViewProviderQueryFields';
        testCustomSetting.NavigationItemsLimit__c = 20;
        testCustomSetting.NavigationProviderServices__c = 'ACN_ScoreCardProvider';
        insert testCustomSetting;
        
        List<Schema.FieldSetMember> fieldList = 
         SObjectType.ACN_NavigationItem__c.FieldSets.getMap().get(
         testCustomSetting.ListViewProviderQueryFieldSet__c).getFields();
        ACN_NavigationProviderService navProviderService = new ACN_PublicCustomObjectListViewProvider();
        ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        request.Id = 'Static, ID';
        request.IncludeRecommendations = true;
        request.UseContextForCarousel = false;
        request.IsMenuItem = false;    
        User usr = [select id,Name,IsActive from User where IsPortalEnabled = true AND IsActive = true limit 1 ];
        
        Network community = [SELECT id, Name,OptionsReputationEnabled FROM Network where name =: 'your portal here'];
        system.debug('+++++'+Network.getNetworkId());
        //usr.NetworkId = community.id;
        Test.StartTest();
        //System.runAs(usr) {
        
        try{
            ACN_NavigationLibrary.NavigationList navList = navProviderService.GetNavigationList(request);
            request.Id = '';
            request.id = 'rated';
            request.BrowserFormFactor= 'phone';
            navProviderService.GetNavigationList(request);
            request.id = 'rated';
            
            navProviderService.GetNavigationList(request); 
             request.id = 'userpreferences';
            navProviderService.GetNavigationList(request); 
            request.id = 'Random String Test';
            Test.startTest();
            navProviderService.GetNavigationList(request); 
        }catch(Exception E){}
        //}
        Test.stopTest();
    }
}