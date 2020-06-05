public class DynamicStageController {
    @AuraEnabled
    public static HR_App__c AppQuery(String appId){
        return [select id, Candidate_Portal_Hiring_Stage__c 
                from HR_App__c where id =:appId limit 1];
    }
    @AuraEnabled
    public static decimal GetPercentage(string appId)
    {
        HR_App__c currentApp = [SELECT Id, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c, RecordType.Name FROM HR_App__c WHERE Id = :appId LIMIT 1];
        Navigation_Items__c navItem = [select id,Weight_of_Component__c from Navigation_Items__c where Name =: currentApp.Candidate_Portal_Hiring_Stage__c and GroupName__c =: currentApp.RecordType.Name limit 1 ];
        return navItem.Weight_of_Component__c;
    }
    
    @AuraEnabled @testVisible
    public static List<String> getStatusValues(string appId)
    {
        
        HR_App__c currentApp = [SELECT Id, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c, RecordType.Name FROM HR_App__c WHERE Id = :appId LIMIT 1];
        List<HR_Application_Hiring_Stage__mdt> AppHiringStages = [SELECT Id, Internal_Stages__c, External_Stages__c, Workstream__c, Order__c 
                                                                  FROM HR_Application_Hiring_Stage__mdt 
                                                                  WHERE Workstream__c = :currentApp.RecordType.Name
                                                                  ORDER BY Order__c ASC];
        
        for(HR_Application_Hiring_Stage__mdt ap : AppHiringStages){
            System.debug('Metadata: ' + ap.External_Stages__c);
        }
        
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = HR_App__c.Candidate_Portal_Hiring_Stage__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Integer i = 0; i < AppHiringStages.size(); i++) {
            for(Integer j = 0; j < pList.size(); j++){
                if(pList[j].getLabel() == AppHiringStages[i].External_Stages__c){
                    options.add(pList[j].getLabel());
                }
            }
            
        }
        for(String s : options){
            System.debug('Option: ' + s);
        }
        return options;
    }
    
    @AuraEnabled
    public static boolean shouldHiringStageBeRed(String appId){
        return ![select id, Eligible__c 
                from HR_App__c where id =:appId limit 1].Eligible__c;
    }
    
    public class PickListValue {
        @AuraEnabled Public string value;
        @AuraEnabled Public string label;
    }
    
}