public   class HR_CandidateOfferAcceptedController {
    
    @AuraEnabled
    public static string accepted(String applicationId){
        String message ='';
        LIST<HR_Offer__c> selectedOff = [SELECT ID, Status__c FROM HR_Offer__c WHERE Application__c=:applicationId];
        if(selectedOff[0].Status__c !=null) {
            if(selectedOff[0].Status__c == 'TJO Extended')
            {
                selectedOff[0].Status__c = 'Pending Assessments';
                selectedOff[0].Date_TJO_Accepted__c = Date.today();
            }
            Else if (selectedOff[0].Status__c == 'FJO Extended')
            {
                selectedOff[0].Status__c = 'FJO Accepted';
                selectedOff[0].Date_FJO_Accepted__c = Date.today();
            } Else
            {
                selectedOff[0].Status__c = 'Accepted';
            }
            //            selectedOff[0].Date_TJO_Accepted__c = Date.today();
            Update selectedOff;
            message= 'Success';
        } else {
            message ='Offer record not updated because of original status mismatch';
        }
        return message;
        
    }
    
    @AuraEnabled
    public static boolean getButtonDetails(String applicationId){
        HR_Application__c selectedApp = [SELECT ID, RecordType.Name, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c , Application_Status__c, SSO_Link_Request_Indicator__c 
                                         FROM HR_Application__c 
                                         WHERE Id=:applicationId];
        List<HR_Application_Hiring_Stage__mdt> HiringStageOrder = [SELECT Id, Accept__c, Internal_Stages__c, External_Stages__c, Order__c 
                                                                   FROM HR_Application_Hiring_Stage__mdt 
                                                                   WHERE Workstream__c = :selectedApp.RecordType.Name 
                                                                   and Hiring_Stages__c =: selectedApp.Hiring_Stage__c
                                                                   and External_Stages__c =: selectedApp.Candidate_Portal_Hiring_Stage__c
                                                                   ORDER BY Order__c ASC];
        LIST<HR_Offer__c> selectedOff = [SELECT ID, Status__c FROM HR_Offer__c WHERE Application__c=:applicationId and (Status__c!='Declined' or Status__c!='Accepted')];
        if(selectedApp.Application_Status__c == 'Accepted' || selectedApp.Application_Status__c == 'Declined' ||selectedApp.Application_Status__c == 'Withdrawn') 
            //            || selectedApp.SSO_Link_Request_Indicator__c )
        {
            return false;
        }
        if(!selectedOff.isempty()) {
            return HiringStageOrder[0].Accept__c;
        } else {
            return false;
        }
        
    }
    
}