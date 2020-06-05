public class HR_ApplicationNavigationFieldUpdate {
/*
    @InvocableMethod
    public static void updateExternalStage(List<HR_Application__C> ids) {
         List<HR_Application__C> apps = [
            SELECT Id,  Hiring_Stage__c, External_Navigation_Record__c, Internal_Navigation_Record__c,RecordType.Name
            FROM HR_Application__C
            WHERE Id IN:new Map<Id, HR_Application__C>(ids).keySet()
        ];
        system.debug('apps ###' + apps[0].RecordType.Name);
         List<HR_Navigation__c> lstHrNav = [select Application_Record_Type__c,Application_Hiring_Stage__c,External_Navigation_Record__c,Internal_Navigation_Record__c from HR_Navigation__c];
        Map<string, string> listMappings = new Map<string, string>();
           for(HR_Application__C item : apps)
            {
              for(HR_Navigation__c mdt: lstHrNav )
              {
                  if(item .Hiring_Stage__c == mdt.Application_Hiring_Stage__c && item.RecordType.Name == mdt.Application_Record_Type__c )
                  {
                      item.External_Navigation_Record__c = mdt.External_Navigation_Record__c;
                      item.Internal_Navigation_Record__c = mdt.Internal_Navigation_Record__c;
                  }
 
              }
            
            }
          
        
        update apps;
    } */
}