public class SetPathControllerOldandNew {

    /* New latest
     * 
     * public class HR_DynamicStageSetPathController {
    @AuraEnabled
    public static HR_Application__c AppQuery(String appId){
        return [select id, Candidate_Portal_Hiring_Stage__c 
                from HR_Application__c where id =:appId limit 1];
    }
    @AuraEnabled
    public static List<String> getStatusValues(string appId)
    {

        HR_Application__c currentApp = [SELECT Id, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c, RecordType.Name FROM HR_Application__c WHERE Id = :appId LIMIT 1];
        List<HR_Application_Hiring_Stage__mdt> AppHiringStages = [SELECT Id, Internal_Stages__c, External_Stages__c, Workstream__c, Order__c 
                                                                  FROM HR_Application_Hiring_Stage__mdt 
                                                                  WHERE Workstream__c = :currentApp.RecordType.Name
                                                                  ORDER BY Order__c ASC];
        
        for(HR_Application_Hiring_Stage__mdt ap : AppHiringStages){
            System.debug('Metadata: ' + ap.External_Stages__c);
        }
        
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = HR_Application__c.Candidate_Portal_Hiring_Stage__c.getDescribe();
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
    
    public class PickListValue {
        @AuraEnabled Public string value;
        @AuraEnabled Public string label;
    }
}
    
     * */

/* old---
  public class HR_DynamicStageSetPathController {
	@AuraEnabled
    public static HR_Application__c AppQuery(String appId){
        return [select id, External_Navigation_Record__r.Name,External_Navigation_Record__c 
                from HR_Application__c where id =:appId limit 1];
    }
    @AuraEnabled
    public static List<PickListValue> getStatusValues(string recordTypeType)
    {  
        String myrecordType= [select id,ParentNavigationItemId__r.Code__c 
                              from ACN_NavigationItem__c 
                              where Id =:recordTypeType limit 1].ParentNavigationItemId__r.Code__c;
       List<PickListValue> options = new List<PickListValue>();
       List<ACN_NavigationItem__c> lstName =[select id,name from ACN_NavigationItem__c 
                                           where ParentNavigationItemId__c != null 
                                           and ParentNavigationItemId__r.Code__c  =:myrecordType
                                           order by Order__c ];
        for( ACN_NavigationItem__c f : lstName)
        {   PickListValue abc = new PickListValue();
            abc.value =f.name; 
            abc.label = f.name;
            options.add(abc);
        } 
        system.debug('options '+options);
        return options;
    }
    
    public class PickListValue {
        @AuraEnabled Public string value;
        @AuraEnabled Public string label;
    }
}
  
 
 */
    
}