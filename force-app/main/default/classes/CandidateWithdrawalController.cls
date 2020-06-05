public class CandidateWithdrawalController {
    
    @AuraEnabled
    public static void withdraw(String applicationId){
//        System.debug('applicationId '+applicationId);
//        applicationId = applicationId == null ? 'a0G6g000000NUprEAG': applicationId;
        LIST<HR_App__c> selectedApp = [SELECT ID, Hiring_Stage__c FROM HR_App__c WHERE Id=:applicationId];
        selectedApp[0].Hiring_Stage__c = 'Withdrawn';
        Update selectedApp;
    }
    
    @AuraEnabled
    public static void initFlow(String AppId){
        id conid = [select id, contactid from User where id =: UserInfo.getUserId()].contactid;
        Map<String, Object> params = new Map<String, Object>();
        params.put('AppId', AppId);
        Flow.Interview.AppFlowCheck calcFlow = new Flow.Interview.AppFlowCheck(params);
        calcFlow.start();
    }
    
}