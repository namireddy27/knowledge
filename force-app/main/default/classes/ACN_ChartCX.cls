global with sharing class ACN_ChartCX {
    @AuraEnabled
    global static string getChartData(string dataProviderName){
        iChartjsDataProvider dp;
        dp = (iChartjsDataProvider)type.forName(dataProviderName).newInstance();
        return dp.getChartjsData();
    }
    
    public Boolean IsLightningEnabled {get; set;}
    public ACN_ChartConfiguration__c ChartProviderSettings {get; set;}
    private ACN_ChartDataProvider chartDataProvider {get; set;}
    public ACN_ChartLibrary.ChartResponse chartResponse {get; set;}
    public String chartResponseJSON {get; set;}

    public ACN_ChartCX() {
        this.IsLightningEnabled = false;
        this.ChartProviderSettings = ACN_ChartConfiguration__c.getInstance();
        if (this.ChartProviderSettings.IsPageInLightningAtStartup__c) {
            this.IsLightningEnabled = true;
        }
        if (ApexPages.CurrentPage().getParameters() != null && ApexPages.CurrentPage().getParameters().size() > 0 && ApexPages.CurrentPage().getParameters().containsKey('lightningon') ) {
            this.IsLightningEnabled = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('lightningon'));
        }
        
        ACN_ChartLibrary.ChartRequest request = new ACN_ChartLibrary.ChartRequest();
        
        if(!String.isEmpty(request.ChartDataProviderName)) {
            this.chartDataProvider = new ACN_ChartDataProvider(request.ChartDataProviderName);
        }
        else {
            this.chartDataProvider = new ACN_ChartDataProvider(this.ChartProviderSettings.ChartDataProvider__c);
        }
              
        this.chartResponse = this.chartDataProvider.GetChartResponse(request);
        
        chartResponseJSON = getResponseJSON();
    }
    
    @AuraEnabled
    public static ACN_ChartLibrary.ChartResponse getChartResponse (ACN_ChartLibrary.ChartRequest request) {
        ACN_ChartConfiguration__c chartProviderSettings = ACN_ChartConfiguration__c.getInstance();  

        ACN_ChartDataProvider chartDataProvider;
        if(!String.isEmpty(request.ChartDataProviderName)) {
            chartDataProvider = new ACN_ChartDataProvider(request.ChartDataProviderName);
        }
        else {
            chartDataProvider = new ACN_ChartDataProvider(chartProviderSettings.ChartDataProvider__c);
        }

        return chartDataProvider.GetChartResponse(request);
    }
    
    @AuraEnabled
    public static String getSerializedChartResponse(String serializedRequest) {
        ACN_ChartLibrary.ChartRequest request = (ACN_ChartLibrary.ChartRequest)JSON.deserialize(serializedRequest, ACN_ChartLibrary.ChartRequest.Class);
        return JSON.serialize(getChartResponse(request));
    }
    
    @AuraEnabled
    public static String getObjectPrefix(String objectApiName) {
        Map<String, Schema.SObjectType> objectTypeMap = Schema.getGlobalDescribe();

        return objectTypeMap.get(objectApiName).getDescribe().getKeyPrefix();
    }

    @AuraEnabled
    public static String getUserId() {
        return UserInfo.getUSerId();
    }

    public static String getResponseJSON() {
        ACN_ChartLibrary.ChartRequest request = new ACN_ChartLibrary.ChartRequest();

        ACN_ChartLibrary.ChartResponse response = getChartResponse(request);

        return JSON.serialize(response);
    }    
}