public class HR_DynamicStageSetPathController {
    
    @AuraEnabled
    public static HR_Application__c AppQuery(String appId){
        HR_Application__c app= [select id, Candidate_Portal_Hiring_Stage__c, Hiring_Stage__c,RecordType.Name 
                from HR_Application__c where id =:appId limit 1];
      HR_Application_Hiring_Stage__mdt mtd =  [SELECT Id, Internal_Stages__c, External_Stages__c, Workstream__c, Order__c,Hiring_Stages__c 
                                                                  FROM HR_Application_Hiring_Stage__mdt 
                                                                  WHERE Workstream__c = :app.RecordType.Name and
                                               						Hiring_Stages__c =: app.Hiring_Stage__c and 
                                               						External_Stages__c =: app.Candidate_Portal_Hiring_Stage__c
                                                                  ORDER BY Order__c ASC];
        
        app.Hiring_Stage__c = mtd.Internal_Stages__c;
        return app;
    }
/*    
    @AuraEnabled
    public static decimal GetPercentage(string appId)
    {
        HR_Application__c currentApp = [SELECT Id, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c, RecordType.Name FROM HR_Application__c WHERE Id = :appId LIMIT 1];
        ACN_NavigationItem__c navItem = [select id,Weight_of_Component__c from ACN_NavigationItem__c where Name =: currentApp.Candidate_Portal_Hiring_Stage__c and GroupName__c =: currentApp.RecordType.Name limit 1 ];
        
        return navItem.Weight_of_Component__c;
        
    }   
    */
    @AuraEnabled
    public static List<String> getStatusValues(String appId, String environmentType)
    {
        HR_Application__c currentApp = [SELECT Id, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c, RecordType.Name, Eligible__c FROM HR_Application__c WHERE Id = :appId LIMIT 1];
        List<HR_Application_Hiring_Stage__mdt> AppHiringStages = [SELECT Id, Internal_Stages__c, External_Stages__c, Workstream__c, Order__c, Hiring_Stages__c 
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
            fieldResult = HR_Application__c.Candidate_Portal_Hiring_Stage__c.getDescribe();
            pList = fieldResult.getPicklistValues();
            for (Integer i = 0; i < AppHiringStages.size(); i++) {
                for(Integer j = 0; j < pList.size(); j++){
                    if(pList[j].getValue() == AppHiringStages[i].External_Stages__c){
                        options.add(pList[j].getLabel());
                    }
                }
            }
        }
        else if(environmentType == 'Lightning'){
             Schema.DescribeFieldResult fieldResult_Internal;
            fieldResult_Internal = HR_Application_Hiring_Stage__mdt.Internal_Stages__c.getDescribe();
            fieldResult = HR_Application__c.Hiring_Stage__c.getDescribe();
            pList = fieldResult.getPicklistValues();
            List<Schema.PicklistEntry> pList1 = fieldResult_Internal.getPicklistValues();
            for (Integer i = 0; i < AppHiringStages.size(); i++) {
                for(Integer j = 0; j < pList.size(); j++){
                    if(pList[j].getValue() == AppHiringStages[i].Hiring_Stages__c) {
                    	for(Integer k = 0; k < pList1.size(); k++){
                    		if (pList1[k].getValue() == AppHiringStages[i].Internal_Stages__c) {
                         		options.add(pList1[k].getLabel());
                  			}
                      //  options.add(AppHiringStages[i].Internal_Stages__c);
//                        options.add(pList[j].getLabel());
                  		}
               		}
            	}
         	}	
      	}    
        for(String s : options){
            System.debug('Option: ' + s);
        }
        return new List<String>(options);
    }
    
    @AuraEnabled
    public static boolean shouldHiringStageBeRed(String appId){
        HR_Application__c app = [SELECT Id, Application_Status__c, Eligible__c FROM HR_Application__c WHERE Id = :appId LIMIT 1];
        if(app.Eligible__c == false){
            return true;
        }
        return false;        
    }
    
    public class PickListValue {
        @AuraEnabled Public string value;
        @AuraEnabled Public string label;
    }
}