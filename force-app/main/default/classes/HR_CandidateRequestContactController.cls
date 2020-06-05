public class HR_CandidateRequestContactController {
    
    @AuraEnabled
    public static void requested(String applicationId,string comments){
        LIST<HR_Offer__c> selectedOff = [SELECT ID, Request_Contact__c FROM HR_Offer__c WHERE Application__c=:applicationId];
        selectedOff[0].Request_Contact__c = True;
        selectedOff[0].Contact_Reason__c =comments;
        Update selectedOff;
    }
  
    
    @AuraEnabled
    public static boolean getButtonDetails(String applicationId){
        HR_Application__c selectedApp = [SELECT ID, RecordType.Name, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c , Application_Status__c, SSO_Link_Request_Indicator__c 
                                         FROM HR_Application__c 
                                         WHERE Id=:applicationId];
        List<HR_Application_Hiring_Stage__mdt> HiringStageOrder = [SELECT Id, Request_Contact__c, Internal_Stages__c, External_Stages__c, Order__c 
                                                                   FROM HR_Application_Hiring_Stage__mdt 
                                                                   WHERE Workstream__c = :selectedApp.RecordType.Name 
                                                                   and Hiring_Stages__c =: selectedApp.Hiring_Stage__c
                                                                   and External_Stages__c =: selectedApp.Candidate_Portal_Hiring_Stage__c
                                                                   ORDER BY Order__c ASC];
        if(selectedApp.Application_Status__c == 'Accepted' || selectedApp.Application_Status__c == 'Declined' ||selectedApp.Application_Status__c == 'Withdrawn') 
        {
            return false;
        }
        return HiringStageOrder[0].Request_Contact__c;
    }
    
}
    /*
    @AuraEnabled
    public static void requestandEmail(String applicationId)
    {
        HR_Application__c selectedApp = [SELECT ID, RecordType.DeveloperName FROM HR_Application__c WHERE Id=:applicationId];
        Group grp = [select Id, Email from Group where Type = 'Queue' and DeveloperName =: (selectedApp.RecordType.DeveloperName + '_Queue' )];
 Messaging.SingleEmailMessage mail = 
      new Messaging.SingleEmailMessage();
    
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      sendTo.add(grp.Email);
        system.debug('Email###' + grp.Email);
      mail.setToAddresses(sendTo);
    
   List<Messaging.SingleEmailMessage> mails = 
  new List<Messaging.SingleEmailMessage>();

      // Step 4. Set email contents - you can use variables!
      mail.setSubject('URGENT BUSINESS PROPOSAL');
      String body = 'Please contact HR';
      mail.setHtmlBody(body);
    
      // Step 5. Add your email to the master list
      mails.add(mail);
        Messaging.sendEmail(mails);
  
    }

}
*/