public class GraphController {
    @AuraEnabled
    public static HR_App__c AppQuery(String appId){
        return [select id, Percentage_Complete__c,Candidate_Portal_Hiring_Stage__c 
                from HR_App__c where id =:appId limit 1];
    }
    @AuraEnabled
    public static decimal GetPercentage(string appId) 
    {
        HR_App__c currentApp = [SELECT Id, Hiring_Stage__c, Percentage_Complete__c,Candidate_Portal_Hiring_Stage__c, RecordType.Name FROM HR_App__c WHERE Id = :appId LIMIT 1];
        Navigation_Items__c navItem = [select id,Weight_of_Component__c from Navigation_Items__c where Name =: currentApp.Candidate_Portal_Hiring_Stage__c and GroupName__c =: currentApp.RecordType.Name limit 1 ];
        return navItem.Weight_of_Component__c;
    }
}