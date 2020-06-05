global with sharing class ACN_ScoringCX {
    public Boolean IsLightningEnabled {get; set;}
    public ACN_CommunityNavigationConfig__c NavigationSettings {get; set;}
    private ACN_ScoringProvider scoringProvider {get; set;}
    public ACN_ScoringLibrary.ScoringResponse ScoringResponse {get; set;}
    public String scoringResponseJSON {get; set;}

    public ACN_ScoringCX() {
        this.IsLightningEnabled = false;
        this.NavigationSettings = ACN_CommunityNavigationConfig__c.getInstance();
        if (this.NavigationSettings.IsPageInLightningAtStartup__c) {
            this.IsLightningEnabled = true;
        }
        if (ApexPages.CurrentPage().getParameters() != null && ApexPages.CurrentPage().getParameters().size() > 0 && ApexPages.CurrentPage().getParameters().containsKey('lightningon') ) {
            this.IsLightningEnabled = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('lightningon'));
        }
        
        ACN_ScoringLibrary.ScoringRequest request = new ACN_ScoringLibrary.ScoringRequest();
        
        if(!String.isEmpty(request.ScoringProviderName)) {
            this.scoringProvider = new ACN_ScoringProvider(request.ScoringProviderName);
        }
        else {
            this.scoringProvider = new ACN_ScoringProvider(this.NavigationSettings.NavigationProvider__c);
        }
              
        ScoringResponse = this.scoringProvider.GetScoringResponse(request);
        
        scoringResponseJSON = scoringResponseJSON();
    }
    
    @AuraEnabled
    public static ACN_ScoringLibrary.ScoringResponse getScoringResponse(ACN_ScoringLibrary.ScoringRequest request) {
        ACN_CommunityNavigationConfig__c NavigationSettings = ACN_CommunityNavigationConfig__c.getInstance();  

        ACN_ScoringProvider scoringProvider;
        if(!String.isEmpty(request.ScoringProviderName)) {
            scoringProvider = new ACN_ScoringProvider(request.ScoringProviderName);
        }
        else {
            //scoringProvider = new ACN_ScoringProvider(this.ScoringSettings.NavigationProvider__c);
        }
        //system.debug('@####### request: ' + request);
        return scoringProvider.GetScoringResponse(request);
    }
    
    @AuraEnabled
    public static String getSerializedscoringResponse(String serializedRequest) {
        ACN_ScoringLibrary.ScoringRequest request = (ACN_ScoringLibrary.ScoringRequest)JSON.deserialize(serializedRequest,ACN_ScoringLibrary.ScoringRequest.Class);

        return JSON.serialize(getScoringResponse(request));
    }
    
    @AuraEnabled
    public static String getObjectPrefix(String objectApiName) {
        Map<String, Schema.SObjectType> objectTypeMap = Schema.getGlobalDescribe();

        return objectTypeMap.get(objectApiName).getDescribe().getKeyPrefix();
    }

    public static String scoringResponseJSON() {
        ACN_ScoringLibrary.ScoringRequest request = new ACN_ScoringLibrary.ScoringRequest();

        ACN_ScoringLibrary.ScoringResponse scoringResponse = getScoringResponse(request);

        return JSON.serialize(scoringResponse);
    }
}