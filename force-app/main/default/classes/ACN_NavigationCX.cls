global with sharing class ACN_NavigationCX {
/*    public Boolean IsLightningEnabled {get; set;}
    public ACN_CommunityNavigationConfig__c NavigationSettings {get; set;}
    private ACN_NavigationProvider navigationProvider {get; set;}
    public ACN_NavigationLibrary.NavigationList NavigationList {get; set;}
    public String navigationListJSON {get; set;}

    public ACN_NavigationCX() {
        this.IsLightningEnabled = false;
        this.NavigationSettings = ACN_CommunityNavigationConfig__c.getInstance();
        if (this.NavigationSettings.IsPageInLightningAtStartup__c) {
            this.IsLightningEnabled = true;
        }
        if (ApexPages.CurrentPage().getParameters() != null && ApexPages.CurrentPage().getParameters().size() > 0 && ApexPages.CurrentPage().getParameters().containsKey('lightningon') ) {
            this.IsLightningEnabled = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('lightningon'));
        }
        
        ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        request.Level = 1;
        
        if(!String.isEmpty(request.NavigationProviderName)) {
            this.navigationProvider = new ACN_NavigationProvider(request.NavigationProviderName);
        }
        else {
            this.navigationProvider = new ACN_NavigationProvider(this.NavigationSettings.NavigationProvider__c);
        }
              
        NavigationList = this.navigationProvider.GetNavigationList(request);
        
        navigationListJSON = getListJSON();
    }
    
    @AuraEnabled(cacheable=false)
    public static ACN_NavigationLibrary.NavigationList getNavigationList(ACN_NavigationLibrary.NavigationRequest request) {
        ACN_CommunityNavigationConfig__c NavigationSettings = ACN_CommunityNavigationConfig__c.getInstance();  

        ACN_NavigationProvider navigationProvider;
        if(!String.isEmpty(request.NavigationProviderName)) {
            navigationProvider = new ACN_NavigationProvider(request.NavigationProviderName);
        }
        else {
            navigationProvider = new ACN_NavigationProvider(NavigationSettings.NavigationProvider__c);
        }

        return navigationProvider.GetNavigationList(request);
    }
    
    @AuraEnabled(cacheable=false)
    public static String getSerializedNavigationList(String serializedRequest) {
        ACN_NavigationLibrary.NavigationRequest request = (ACN_NavigationLibrary.NavigationRequest)JSON.deserialize(serializedRequest,ACN_NavigationLibrary.NavigationRequest.Class);
        return JSON.serialize(getNavigationList(request));
    }
    
    @AuraEnabled(cacheable=true)
    public static String getSerializedNavigationListCached(String serializedRequest) {
        return getSerializedNavigationList(serializedRequest);
    }

    @AuraEnabled(cacheable=false)
    public static String getObjectPrefix(String objectApiName) {
        Map<String, Schema.SObjectType> objectTypeMap = Schema.getGlobalDescribe();

        return objectTypeMap.get(objectApiName).getDescribe().getKeyPrefix();
    }

    @AuraEnabled(cacheable=false)
    public static String getUserId() {
        return UserInfo.getUSerId();
    }

    public static String getListJSON() {
        ACN_NavigationLibrary.NavigationRequest request = new ACN_NavigationLibrary.NavigationRequest();
        request.Level = 1;

        ACN_NavigationLibrary.NavigationList navigationList = getNavigationList(request);

        return JSON.serialize(navigationList);
    }
*/
}