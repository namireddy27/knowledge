public class HR_CandidateAppWithdrawnController {

    @AuraEnabled
    public static void withdrawn(String applicationId){
        LIST<HR_Application__c> selectedApp = [SELECT ID, Application_Status__c FROM HR_Application__c WHERE Id=:applicationId];
        selectedApp[0].Application_Status__c = 'Withdrawn';
//        selectedApp[0].Eligibility__c = False;
        Update selectedApp;
    }

 //automation start       
    @AuraEnabled
    public static boolean getButtonDetails(String applicationId){
         HR_Application__c selectedApp = [SELECT ID, RecordType.Name, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c , Application_Status__c ,SSO_Link_Request_Indicator__c
                                          FROM HR_Application__c 
                                          WHERE Id=:applicationId];
       List<HR_Application_Hiring_Stage__mdt> HiringStageOrder = [SELECT Id, Withdraw__c, Internal_Stages__c, External_Stages__c, Order__c 
                                                                  FROM HR_Application_Hiring_Stage__mdt 
                                                                  WHERE Workstream__c = :selectedApp.RecordType.Name 
                                                                  and Hiring_Stages__c =: selectedApp.Hiring_Stage__c
                                                                  and External_Stages__c =: selectedApp.Candidate_Portal_Hiring_Stage__c
                                                                  ORDER BY Order__c ASC];
        
         if(selectedApp.Application_Status__c == 'Accepted' || selectedApp.Application_Status__c == 'Declined' ||selectedApp.Application_Status__c == 'Withdrawn' )
        {
            return false;
        }
        return HiringStageOrder[0].Withdraw__c;
        

    }

}