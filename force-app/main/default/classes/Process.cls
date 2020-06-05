public class Process{


/*

    @InvocableMethod
    public static void updateExternalStage(List<HR_App__C> ids) {
         List<HR_App__C> apps = [
            SELECT Id,  Hiring_Stage__c, ExternalHiringStage__c,External_Navigation_Record__c, Internal_Navigation_Record__c,RecordType.Name
            FROM HR_App__C
            WHERE Id IN:new Map<Id, HR_App__C>(ids).keySet()
        ];
        system.debug('apps ###' + apps[0].RecordType.Name);
      //  List<Stage_Mapping_Setting__mdt> listStageMappings = [select id,Internal_Navigation_Record__c,External_Status__c,Internal_Status__c,Workstream__c from Stage_Mapping_Setting__mdt];
         List<HR_Navigation__c> lstHrNav = [select Record_Type__c,Application_Hiring_Stage__c,External_Navigation_Records__c,Internal_Navigation_Record__c from HR_Navigation__c];
        Map<string, string> listMappings = new Map<string, string>();
           for(HR_App__C item : apps)
            {
              for(HR_Navigation__c mdt: lstHrNav )
              {
                  if(item .Hiring_Stage__c == mdt.Application_Hiring_Stage__c && item.RecordType.Name == mdt.Record_Type__c )
                  {
                      item.External_Navigation_Record__c = mdt.External_Navigation_Records__c;
                      item.Internal_Navigation_Record__c = mdt.Internal_Navigation_Record__c;
                  }
 
              }
            
            }
          
          
       
        
        update apps;
    }
*/
}