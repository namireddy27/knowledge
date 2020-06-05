public class HR_Candidate_SSO_Link_Request_Controller {

    @AuraEnabled
    public static void updateTogetSSOLink(String applicationId){
        LIST<HR_App__c> selectedApp = [SELECT ID, SSO_Link_Request_Indicator__c FROM HR_App__c WHERE Id=:applicationId];
        selectedApp[0].SSO_Link_Request_Indicator__c = true;
        Update selectedApp;
    }






//
//



    @AuraEnabled
    public  static string getnewSSOLink(String applicationId){
       HR_App__c newSSOlink = [SELECT SSO_Link__c FROM HR_App__c WHERE Id=:applicationId];
        string urllink = (string)newSSOlink.get('SSO_Link__c') ; 
        return urllink;        
    }
   
}