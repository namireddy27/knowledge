public class HR_DynamicStageSetPathController {
    @AuraEnabled
    public static HR_App__c AppQuery(String appId){
        return [select id, Candidate_Portal_Hiring_Stage__c, Hiring_Stage__c 
                from HR_App__c where id =:appId limit 1];
    }

    @AuraEnabled
    public static List<String> getStatusValues(String appId, String environmentType)
    {
        HR_App__c currentApp = [SELECT Id, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c, RecordType.Name FROM HR_App__c WHERE Id = :appId LIMIT 1];
        List<HR_Application_Hiring_Stage__mdt> AppHiringStages = [SELECT Id, Internal_Stages__c, External_Stages__c, Workstream__c, Order__c 
                                                                  FROM HR_Application_Hiring_Stage__mdt 
                                                                  WHERE Workstream__c = :currentApp.RecordType.Name
                                                                  ORDER BY Order__c ASC];
        
        for(HR_Application_Hiring_Stage__mdt ap : AppHiringStages){
            System.debug('Metadata: ' + ap.External_Stages__c);
        }
        
        Set<String> options = new Set<String>();
        Schema.DescribeFieldResult fieldResult;
        List<Schema.PicklistEntry> pList = new List<Schema.PicklistEntry>();
        
        
        if(environmentType == 'Community'){
            fieldResult = HR_App__c.Candidate_Portal_Hiring_Stage__c.getDescribe();
            pList = fieldResult.getPicklistValues();
            for (Integer i = 0; i < AppHiringStages.size(); i++) {
                for(Integer j = 0; j < pList.size(); j++){
                    if(pList[j].getLabel() == AppHiringStages[i].External_Stages__c){
                        options.add(pList[j].getLabel());
                    }
                }
            }
        }
        else if(environmentType == 'Lightning'){
            fieldResult = HR_App__c.Hiring_Stage__c.getDescribe();
            pList = fieldResult.getPicklistValues();
            for (Integer i = 0; i < AppHiringStages.size(); i++) {
                for(Integer j = 0; j < pList.size(); j++){
                    if(pList[j].getLabel() == AppHiringStages[i].Internal_Stages__c){
                        options.add(pList[j].getLabel());
                    }
                }
            }
        }
        
        for(String s : options){
            
        }
        return new List<String>(options);
    }
    
    @AuraEnabled
    public static boolean shouldHiringStageBeRed(String appId){
        HR_App__c app = [SELECT Id, Application_Status__c FROM HR_App__c WHERE Id = :appId LIMIT 1];
        if(app.Application_Status__c == 'Declined' || app.Application_Status__c == 'Withdrawn'){
            return true;
        }
        return false;        
    }
    
    public class PickListValue {
        @AuraEnabled Public string value;
        @AuraEnabled Public string label;
    }
}