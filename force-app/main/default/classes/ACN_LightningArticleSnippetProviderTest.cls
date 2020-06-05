@istest(SeeAllData=false)
public class ACN_LightningArticleSnippetProviderTest {
   @isTest static void testGetNavigationList() {
        
       
       List<Topic> tl = [SELECT Name FROM Topic WHERE NetworkId != ''];
       System.debug('Topic query returned ' + tl.size() + ' topics. toString: ' + tl);

       Map<String, String> testUserDataMap = ACN_NavigationTestData.fillUserDataMap1();
       Id testUserProfileId = ACN_NavigationTestData.getProfileId('System Administrator');//('OneUSDA System Admin');//('SFR System Administrator');
       User testUser = ACN_NavigationTestData.createUser(testUserDataMap, testUserProfileId, null);
       insert testUser;

       ACN_CommunityNavigationConfig__c testCustomSetting = new ACN_CommunityNavigationConfig__c();
       testCustomSetting.SetupOwnerId = testUser.Id;
       testCustomSetting.ListViewProviderQueryFieldSet__c = 'ListViewProviderQueryFields';
       testCustomSetting.NavigationItemsLimit__c = 20;
       testCustomSetting.NavigationProviderServices__c = 'ACN_LightningArticleSnippetProvider';
       testCustomSetting.DefaultListViewName__c = 'Recent';
       testCustomSetting.ArticleInfoLineTemplate__c =   '<span>{!publishdate} in {!articletype}</span><p>{!summary}</p>';
       testCustomSetting.ArticleTypesCSV__c  = 'Knowledge';
       insert testCustomSetting;
       Id kaRecId = [Select id from Knowledge__ka LIMIT 1].id;
       Vote newVote = new Vote();
       newVote.parentId = kaRecId;
       newVote.type = 'Up';
       insert newVote;
        List<Schema.FieldSetMember> fieldList = 
            SObjectType.ACN_NavigationItem__c.FieldSets.getMap().get(
                testCustomSetting.ListViewProviderQueryFieldSet__c).getFields();
    System.runAs(testUser) {
        List<KnowledgeArticleVersion> testlist = [SELECT Id, Title FROM KnowledgeArticleVersion where publishstatus = 'online'and language = 'en_US' LIMIT 10];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = testlist[0].id;
        Test.setFixedSearchResults(fixedSearchResults);    
        Id kaRecId2 = [Select id from Knowledge__ka LIMIT 1].id;
        Vote newVote2 = new Vote();
        newVote2.parentId = kaRecId2;
        newVote2.type = 'Down';
        insert newVote2;
            ACN_CommunityNavigationConfig__c navSettings = ACN_CommunityNavigationConfig__c.getInstance();
            System.debug('Test>>> navSettings: ' + navSettings);
        //  ACN_CustomObjectListViewProvider provider = new ACN_CustomObjectListViewProvider();
            ACN_NavigationProvider provider = new ACN_NavigationProvider('ACN_LightningArticleSnippetProvider');
            ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
            //request.id = testlist[0].id;
            request.id = 'userpreferences';
            request.level = 10;
            request.BrowserFormFactor = 'other data';
            provider.GetNavigationList(request);
            request.BrowserFormFactor = 'phone';
            
            provider.GetNavigationList(request); 
             request.id = 'userpreferences';
            provider.GetNavigationList(request); 
        request.id = 'Random String Test';
            provider.GetNavigationList(request); 
           ACN_NavigationLibrary.NavigationListItem item = new ACN_NavigationLibrary.NavigationListItem();
       // item.Description = 'test the merging; fields';
        
        }

    }


    @isTest static void testNonImplementedMethods() {
        Map<String, String> testUserDataMap = ACN_NavigationTestData.fillUserDataMap1();
        Id testUserProfileId = ACN_NavigationTestData.getProfileId('System Administrator');//('SFR System Administrator');
        User testUser = ACN_NavigationTestData.createUser(testUserDataMap, testUserProfileId, null);

        insert testUser;

        ACN_CommunityNavigationConfig__c testCustomSetting = new ACN_CommunityNavigationConfig__c();
        testCustomSetting.SetupOwnerId = testUser.Id;
        testCustomSetting.ListViewProviderQueryFieldSet__c = 'ListViewProviderQueryFields';
        testCustomSetting.NavigationItemsLimit__c = 20;
        testCustomSetting.NavigationProviderServices__c = 'ACN_LightningArticleSnippetProvider';
        testCustomSetting.NavigationProvider__c = 'ACN_LightningArticleSnippetProvider';
        testCustomSetting.ArticleInfoLineTemplate__c =   '<span>{!publishdate} in {!articletype}</span><p>{!summary}</p>';
        testCustomSetting.ArticleTypesCSV__c  = 'Knowledge';
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