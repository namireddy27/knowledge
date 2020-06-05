Public class actionItems{
}

/*
global with sharing class ACN_CustomObjectListViewProvider2 implements ACN_NavigationProviderService {
    final String DEFAULT_GROUP_KEY = 'defaultGroup';
    
    global ACN_CommunityNavigationConfig__c settings {get; set;}
    
    global ACN_CustomObjectListViewProvider2() {
        settings = ACN_CommunityNavigationConfig__c.getInstance(); 
    }
    
    global ACN_NavigationLibrary.NavigationList GetNavigationList (ACN_NavigationLibrary.NavigationRequest request) {
    //
    String composedRequestId = request.Id;
        String code = composedRequestId.split(':')[0];
        String recordId = composedRequestId.split(':')[1];
         HR_App__c  hrapp = [select id,ExternalHiringStage__c,External_Navigation_Record__r.Name,External_Navigation_Record__c 
                    from HR_App__c where id =:recordId limit 1];
                     String myrecordType= [select id,ParentNavigationItemId__r.Code__c 
                                  from Navigation_Items__c 
                                  where Id =:hrapp.External_Navigation_Record__c limit 1].ParentNavigationItemId__r.Code__c;
                                  
                                   List<Navigation_Items__c> lstName =[select id,name from Navigation_Items__c 
                                                where ParentNavigationItemId__c != null 
                                                and ParentNavigationItemId__r.Code__c  =:myrecordType
                                                order by Order__c ];
                
        ACN_NavigationProviderService originalProvider = new ACN_CustomObjectListViewProvider();
        ACN_NavigationLibrary.NavigationList navList = originalProvider.GetNavigationList(request);
        Integer elementIndex = 0;
        List<ACN_NavigationLibrary.NavigationListItem> filteredItems = new List<ACN_NavigationLibrary.NavigationListItem>();
        for (Navigation_items__c item: lstName) {
        
        
        for (ACN_NavigationLibrary.NavigationListItem navItem : navList.Items) {
            if(navItem.Id == Item.Id) {
                filteredItems.add(navItem);
            }
            elementIndex++;
        }
        }
        
        //filter items returned by the std provider
        navList.Items.clear();
        navList.Items.addAll(filteredItems);
        
        return navList;
    }

*/