public class HR_CandidateSSOLinkController {
//no need to disable the link after update?
    @AuraEnabled
    public static void updateTogetSSOLink(String applicationId){
        LIST<HR_Application__c> selectedApp = [SELECT ID, SSO_Link_Request_Indicator__c FROM HR_Application__c WHERE Id=:applicationId];
        selectedApp[0].SSO_Link_Request_Indicator__c = true;
        selectedApp[0].External_System_Response__c = 'Null';
        Update selectedApp;
    }
    
    @AuraEnabled
    public static void  updateExtSystemStatus(String applicationId){
        LIST<HR_Application__c> selectedApp = [SELECT ID, External_System_Response__c FROM HR_Application__c WHERE Id=:applicationId];
        selectedApp[0].External_System_Response__c = 'Null';
        Update selectedApp;
    }

    @AuraEnabled
    public  static string getnewSSOLink(String applicationId){
       HR_Application__c newSSOlink = [SELECT SSO_Link__c FROM HR_Application__c WHERE Id=:applicationId];
        string urllink = (string)newSSOlink.get('SSO_Link__c') ; 
        return urllink;        
    }
    
    @AuraEnabled
    public  static string getExternalSystemStatus(String applicationId){
       HR_Application__c extSystemStatus = [SELECT External_System_Response__c FROM HR_Application__c WHERE Id=:applicationId];
        string externalSystemStatus = (string)extSystemStatus.get('External_System_Response__c') ; 
        return externalSystemStatus;        
    } 
    
     @AuraEnabled
     public static boolean getButtonDetails(String applicationId){
         HR_Application__c selectedApp = [SELECT ID, RecordType.Name, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c , Application_Status__c ,SSO_Link_Request_Indicator__c
                                          FROM HR_Application__c 
                                          WHERE Id=:applicationId];
       List<HR_Application_Hiring_Stage__mdt> HiringStageOrder = [SELECT Id, Schedule__c, Internal_Stages__c, External_Stages__c, Order__c 
                                                                  FROM HR_Application_Hiring_Stage__mdt 
                                                                  WHERE Workstream__c = :selectedApp.RecordType.Name 
                                                                  and Hiring_Stages__c =: selectedApp.Hiring_Stage__c
                                                                  and External_Stages__c =: selectedApp.Candidate_Portal_Hiring_Stage__c
                                                                  ORDER BY Order__c ASC];
           if(selectedApp.Application_Status__c == 'Accepted' || selectedApp.Application_Status__c == 'Declined' ||selectedApp.Application_Status__c == 'Withdrawn')
        {
            return false;
        }
        return HiringStageOrder[0].Schedule__c;
        
    }
   
}