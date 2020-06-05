@isTest(SeeAllData=false)
Public class ACN_NavigationChartProviderTest {
    
    Private static User thisUser = [select Id from User where Id = :UserInfo.getUserId()limit 1];
   // public static ACN_NavigationItem__c acnNavItemId = [Select Id from ACN_NavigationItem__c Limit 1] ;
    
   @testSetup static void ACN_MetadataListViewProviderTestDataSetup(){ 
        ACN_CommunityNavigationConfig__c navigationconfig = new ACN_CommunityNavigationConfig__c();
        navigationconfig.ArticleBadgesProvider__c = '';
        navigationconfig.ArticleInfoLineTemplate__c='<span>10/12/2018</span><p>Summary</p>';
        navigationconfig.ArticleLanguageCSV__c='en_US';
        navigationconfig.ArticleRecordsLimit__c=100;
        navigationconfig.ArticleScoringProvider__c='ACN_ArticleScoringProvider';
        navigationconfig.ArticleStatusCSV__c= 'OnLine';
        navigationconfig.ArticleTypesCSV__c='ACN_Collateral,ACN_HowTos';
        navigationconfig.ArticleUrlTemplate__c='/article/qtp';
        navigationconfig.CanViewUnpublishedItems__c=true;
        navigationconfig.CarouselItemsLimit__c= 6;
        navigationconfig.Code__c='ACN01';
        navigationconfig.CSVSeparator__c=',';
        navigationconfig.DefaultItemStyleClassName__c='navigationCard';
        navigationconfig.DefaultListViewName__c='Recent';
        navigationconfig.NavigationItemsLimit__c=100;
        navigationconfig.NavigationProviderServices__c='ACN_CustomObjectListViewProvider,ACN_ScoreCardProvider,ACN_ArticleSnippetProvider,ACN_NavigationTopicProvider,ACN_UserTeamProvider';
        navigationconfig.StaticResourceImagesFolder__c='/resource/ACN_NavigationItems/img/';
        navigationconfig.TopicNameTemplate__c='Patient';
        navigationconfig.NavigationProvider__c='ACN_CustomObjectListViewProvider';
        navigationconfig.IsPageInLightningAtStartup__c = false;
        navigationconfig.ListViewProviderQueryFieldSet__c='ACN_NavigationList';
        Insert navigationconfig ;
        
        ACN_NavigationItem__c acnNavItem = new ACN_NavigationItem__c();
        acnNavItem.Name = 'XYZ';
        //acnNavItem.ParentNavigationItemId__c = acnNavItemId.Id;
        acnNavItem.GroupName__c = 'Administrative';
        acnNavItem.IsActive__c = true;
        acnNavItem.Description__c = 'Test Description';
        acnNavItem.IsDefault__c = False;
        acnNavItem.IsPublished__c = true;
        acnNavItem.Code__c = 'HP-030-020-000-000';
        acnNavItem.Level__c = 2;
        acnNavItem.Order__c = 20;
        acnNavItem.IsIncludedInChildrenList__c = false;
        acnNavItem.IsRecommendation__c = true;
        acnNavItem.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem.NavigationType__c = 'Community';
        acnNavItem.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
         Insert acnNavItem;
        List<ACN_NavigationItem__c> acnNavItems = new List<ACN_NavigationItem__c>();
         ACN_NavigationItem__c acnNavItem1 = new ACN_NavigationItem__c();
        acnNavItem1.Name = 'About test company';
        acnNavItem1.ParentNavigationItemId__c = acnNavItem.Id;
        acnNavItem1.GroupName__c = 'Administrative';
        acnNavItem1.IsActive__c = true;
        acnNavItem1.Description__c = 'Test Description';
        acnNavItem1.IsDefault__c = False;
        acnNavItem1.IsPublished__c = true;
        acnNavItem1.Code__c = 'XYZ-HP-030-010-000-000';
        acnNavItem1.Level__c = 2;
        acnNavItem1.Order__c = 20;
        acnNavItem1.IsIncludedInChildrenList__c = false;
        acnNavItem1.IsRecommendation__c = True;
        acnNavItem1.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem1.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem1.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem1.NavigationType__c = 'Community';
        acnNavItem1.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem1.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
        acnNavItems.add(acnNavItem1);
        ACN_NavigationItem__c acnNavItem2 = new ACN_NavigationItem__c();
        acnNavItem2.Name = 'About test company';
        acnNavItem2.ParentNavigationItemId__c = acnNavItem.Id;
        acnNavItem2.GroupName__c = 'Administrative';
        acnNavItem2.IsActive__c = true;
        acnNavItem2.Description__c = 'Test Description';
        acnNavItem2.IsDefault__c = False;
        acnNavItem2.IsPublished__c = true;
        acnNavItem2.Code__c = 'XYZ-HP-030-000-000-000';
        acnNavItem2.Level__c = 2;
        acnNavItem2.Order__c = 20;
        acnNavItem2.IsIncludedInChildrenList__c = false;
        acnNavItem2.IsRecommendation__c = true;
        acnNavItem2.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem2.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem2.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem2.NavigationType__c = 'Community';
        acnNavItem2.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem2.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
         acnNavItems.add(acnNavItem2);
        
       ACN_NavigationItem__c acnNavItem3 = new ACN_NavigationItem__c();
        acnNavItem3.Name = 'Courses';
        acnNavItem3.ParentNavigationItemId__c = acnNavItem.Id;
        acnNavItem3.GroupName__c = 'Administrative';
        acnNavItem3.IsActive__c = true;
        acnNavItem3.Description__c = 'Test Description';
        acnNavItem3.IsDefault__c = False;
        acnNavItem3.IsPublished__c = true;
        acnNavItem3.Code__c = 'XYZ-HP-030-000-001-000';
        acnNavItem3.Level__c = 2;
        acnNavItem3.Order__c = 20;
        acnNavItem3.IsIncludedInChildrenList__c = false;
        acnNavItem3.IsRecommendation__c = true;
        acnNavItem3.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem3.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem3.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem3.NavigationType__c = 'Community';
        acnNavItem3.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem3.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
         acnNavItems.add(acnNavItem3);
       
       ACN_NavigationItem__c acnNavItem4 = new ACN_NavigationItem__c();
        acnNavItem4.Name = 'Unread Articles';
        acnNavItem4.ParentNavigationItemId__c = acnNavItem.Id;
        acnNavItem4.GroupName__c = 'Administrative';
        acnNavItem4.IsActive__c = true;
        acnNavItem4.Description__c = 'Test Description';
        acnNavItem4.IsDefault__c = False;
        acnNavItem4.IsPublished__c = true;
        acnNavItem4.Code__c = 'XYZ-HP-030-100-001-000';
        acnNavItem4.Level__c = 2;
        acnNavItem4.Order__c = 20;
        acnNavItem4.IsIncludedInChildrenList__c = false;
        acnNavItem4.IsRecommendation__c = true;
        acnNavItem4.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem4.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem4.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem4.NavigationType__c = 'Community';
        acnNavItem4.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem4.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
         acnNavItems.add(acnNavItem4);
        
       ACN_NavigationItem__c acnNavItem5 = new ACN_NavigationItem__c();
        acnNavItem5.Name = 'Pending Tasks';
        acnNavItem5.ParentNavigationItemId__c = acnNavItem.Id;
        acnNavItem5.GroupName__c = 'Administrative';
        acnNavItem5.IsActive__c = true;
        acnNavItem5.Description__c = 'Test Description';
        acnNavItem5.IsDefault__c = False;
        acnNavItem5.IsPublished__c = true;
        acnNavItem5.Code__c = 'XYZ-HP-030-100-002-000';
        acnNavItem5.Level__c = 2;
        acnNavItem5.Order__c = 20;
        acnNavItem5.IsIncludedInChildrenList__c = false;
        acnNavItem5.IsRecommendation__c = true;
        acnNavItem5.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem5.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem5.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem5.NavigationType__c = 'Community';
        acnNavItem5.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem5.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
         acnNavItems.add(acnNavItem5);
       
       ACN_NavigationItem__c acnNavItem6 = new ACN_NavigationItem__c();
        acnNavItem6.Name = 'My Achievements';
        acnNavItem6.ParentNavigationItemId__c = acnNavItem.Id;
        acnNavItem6.GroupName__c = 'Administrative';
        acnNavItem6.IsActive__c = true;
        acnNavItem6.Description__c = 'Test Description';
        acnNavItem6.IsDefault__c = False;
        acnNavItem6.IsPublished__c = true;
        acnNavItem6.Code__c = 'XYZ-HP-030-100-006-000';
        acnNavItem6.Level__c = 2;
        acnNavItem6.Order__c = 20;
        acnNavItem6.IsIncludedInChildrenList__c = false;
        acnNavItem6.IsRecommendation__c = true;
        acnNavItem6.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem6.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem6.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem6.NavigationType__c = 'Community';
        acnNavItem6.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem6.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
         acnNavItems.add(acnNavItem6);
       
       
       ACN_NavigationItem__c acnNavItem7 = new ACN_NavigationItem__c();
        acnNavItem7.Name = 'New Research';
        acnNavItem7.ParentNavigationItemId__c = acnNavItem.Id;
        acnNavItem7.GroupName__c = 'Administrative';
        acnNavItem7.IsActive__c = true;
        acnNavItem7.Description__c = 'Test Description';
        acnNavItem7.IsDefault__c = False;
        acnNavItem7.IsPublished__c = true;
        acnNavItem7.Code__c = 'XYZ-HP-030-100-005-000';
        acnNavItem7.Level__c = 2;
        acnNavItem7.Order__c = 20;
        acnNavItem7.IsIncludedInChildrenList__c = false;
        acnNavItem7.IsRecommendation__c = true;
        acnNavItem7.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem7.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem7.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem7.NavigationType__c = 'Community';
        acnNavItem7.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem7.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
         acnNavItems.add(acnNavItem7);
       
       ACN_NavigationItem__c acnNavItem8 = new ACN_NavigationItem__c();
        acnNavItem8.Name = 'New Tools';
        acnNavItem8.ParentNavigationItemId__c = acnNavItem.Id;
        acnNavItem8.GroupName__c = 'Administrative';
        acnNavItem8.IsActive__c = true;
        acnNavItem8.Description__c = 'Test Description';
        acnNavItem8.IsDefault__c = False;
        acnNavItem8.IsPublished__c = true;
        acnNavItem8.Code__c = 'XYZ-HP-030-100-004-000';
        acnNavItem8.Level__c = 2;
        acnNavItem8.Order__c = 20;
        acnNavItem8.IsIncludedInChildrenList__c = false;
        acnNavItem8.IsRecommendation__c = true;
        acnNavItem8.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem8.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem8.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem8.NavigationType__c = 'Community';
        acnNavItem8.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem8.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
         acnNavItems.add(acnNavItem8);
       
       ACN_NavigationItem__c acnNavItem9 = new ACN_NavigationItem__c();
        acnNavItem9.Name = 'My Cases';
        acnNavItem9.ParentNavigationItemId__c = acnNavItem.Id;
        acnNavItem9.GroupName__c = 'Administrative';
        acnNavItem9.IsActive__c = true;
        acnNavItem9.Description__c = 'Test Description';
        acnNavItem9.IsDefault__c = False;
        acnNavItem9.IsPublished__c = true;
        acnNavItem9.Code__c = 'XYZ-HP-030-100-003-000';
        acnNavItem9.Level__c = 2;
        acnNavItem9.Order__c = 20;
        acnNavItem9.IsIncludedInChildrenList__c = false;
        acnNavItem9.IsRecommendation__c = true;
        acnNavItem9.StyleClassName__c = 'navigationCardIconAndMask';
        acnNavItem9.SmallImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem9.LargeImage__c = '{!$Resource}/ACN_Navigation/icons/training-and-qualifications-magenta-02.png';
        acnNavItem9.NavigationType__c = 'Community';
        acnNavItem9.NavigationTarget__c = 'Training And Qualifications';
        acnNavItem9.NavigationTargetVariables__c = 'topicName:About test company; code:XYZ-HP-030-020-000-000;';
         acnNavItems.add(acnNavItem9);
        Insert acnNavItems;
        
        System.debug('navitems'+acnNavItems);
        
      /*ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
       // ACN_NavigationLibrary.NavigationListItem item = new ACN_NavigationLibrary.NavigationListItem();
        //testNavigationRequest.Level = 2;
      ACN_NavigationChartProvider ancp = new ACN_NavigationChartProvider();
     
      ACN_NavigationLibrary.NavigationListItem item = new ACN_NavigationLibrary.NavigationListItem(); 
         ancp.GetNavigationList(testNavigationRequest); */
        
     }
     
   static testMethod void GetNavigationListTest(){
       List<ACN_NavigationItem__c> acnNavItems1 = [Select Id from ACN_NavigationItem__c];
       System.debug('navitemsinMethod'+acnNavItems1);
      ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
       testNavigationRequest.IncludeRecommendations=true;
       testNavigationRequest.BrowserFormFactor='phone';
       testNavigationRequest.Level = 2;
      ACN_NavigationChartProvider ancp = new ACN_NavigationChartProvider(); 
       Test.startTest();
      //  try{
            //ancp.GoUp(testNavigationRequest);
             ancp.GetNavigationList(testNavigationRequest); 
      //  }
      //  catch(Exception e)
      //  {
            
       // }
        Test.stopTest();
        
    }
    static testMethod void GoNextTest(){
      ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
      ACN_NavigationChartProvider ancp = new ACN_NavigationChartProvider();      
      Test.startTest();
        try{
        ancp.GoNext(testNavigationRequest);
        }
        catch(Exception e){
            
        }
        Test.stopTest();
        
        
    }
    static testMethod void GoUpTest(){
      ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
      ACN_NavigationChartProvider ancp = new ACN_NavigationChartProvider();      
      Test.startTest();
        try{
        ancp.GoUp(testNavigationRequest);
        }
        catch(Exception e){
            
        }
        Test.stopTest();
        
        
    }
    static testMethod void GoPreviousTest(){
      ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
      ACN_NavigationChartProvider ancp = new ACN_NavigationChartProvider();      
      Test.startTest();
        try{
        ancp.GoPrevious(testNavigationRequest);
        }
        catch(Exception e){
            
        }
        Test.stopTest();
        
        
    }
    static testMethod void GoLastTest(){
      ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
      ACN_NavigationChartProvider ancp = new ACN_NavigationChartProvider();  
      Test.startTest();
      try{
      ancp.GoLast(testNavigationRequest);
      }Catch(Exception e){}
      Test.stopTest();
       
    }
     static testMethod void SavePreferenceTest(){
      ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
      ACN_NavigationChartProvider ancp = new ACN_NavigationChartProvider(); 
      Test.startTest();
      try{
      ancp.SavePreference(testNavigationRequest);
         }
         Catch(Exception e){}
         Test.stopTest();
        
    }
     static testMethod void LoadPreferenceTest(){
      ACN_NavigationLibrary.NavigationRequest testNavigationRequest = new ACN_NavigationLibrary.NavigationRequest();
      ACN_NavigationChartProvider ancp = new ACN_NavigationChartProvider(); 
      Test.startTest();
      try{
      ancp.LoadPreference(testNavigationRequest);
       }
       Catch(Exception e){}
      Test.stopTest();   }
}