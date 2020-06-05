public class HR_CandidateSSLLink {
/*
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
    public static ApplicationDetails getButtonDetails(String applicationId){
         HR_Application__c selectedApp = [SELECT ID,Candidate__c,RecordType.Name, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c , Application_Status__c ,SSO_Link_Request_Indicator__c
                                          FROM HR_Application__c 
                                          WHERE Id=:applicationId];
        ApplicationDetails appDe= new ApplicationDetails();
       	List<HR_Application_Hiring_Stage__mdt> HiringStageOrder = [SELECT Id, Schedule_CBT__c, Schedule_Medical__c, Internal_Stages__c, External_Stages__c, Order__c 
                                                                  FROM HR_Application_Hiring_Stage__mdt 
                                                                  WHERE Workstream__c = :selectedApp.RecordType.Name 
                                                                  and Hiring_Stages__c =: selectedApp.Hiring_Stage__c
                                                                  and External_Stages__c =: selectedApp.Candidate_Portal_Hiring_Stage__c
                                                                  ORDER BY Order__c ASC];
           if(selectedApp.Application_Status__c == 'Accepted' || selectedApp.Application_Status__c == 'Declined' ||selectedApp.Application_Status__c == 'Withdrawn')
        {
            return null;
        }
         
        Set<Id> setCandidateId = new Set<Id>();
         if(selectedApp !=null){
             if(selectedApp.Candidate__c !=null && selectedApp.Hiring_Stage__c !=NULL){
                 setCandidateId.add(selectedApp.Candidate__c);
             }
         }
         List<HR_Assessment__c> lstHRAssement = new List<HR_Assessment__c>();
         if(!setCandidateId.isEmpty() ) {
             lstHRAssement  =  [Select id,Assessment_Status__c, Assessment_Name__c from HR_Assessment__c where Candidate__c =:setCandidateId
                                order by createdDate desc limit 1];
         }
        
         if(!lstHRAssement.isEmpty() && (lstHRAssement[0].Assessment_Status__c=='Invited' || lstHRAssement[0].Assessment_Status__c=='Scheduled')){
             //if(selectedApp.RecordType.Name =='FAMS G' && lstHRAssement[0].Assessment_Name__c=='FAB' && lstHRAssement[0].Assessment_Status__c=='Invited') {
             if(selectedApp.RecordType.Name =='FAMS G'  && lstHRAssement[0].Assessment_Name__c=='FAB') {
                                appDe.scheduleCBT = HiringStageOrder[0].Schedule_CBT__c;
      							appDe.scheduleMedical = HiringStageOrder[0].Schedule_Medical__c;  
             }
            else if(selectedApp.RecordType.Name =='FAMS J'&& lstHRAssement[0].Assessment_Name__c=='LBR/WSA CBT') {
                       			appDe.scheduleCBT = HiringStageOrder[0].Schedule_CBT__c;
      							appDe.scheduleMedical = HiringStageOrder[0].Schedule_Medical__c;  
             }
            else if(selectedApp.RecordType.Name =='Field MAP(TSI)' && lstHRAssement[0].Assessment_Name__c=='Field MAP WSA') {
                       			appDe.scheduleCBT = HiringStageOrder[0].Schedule_CBT__c;
      							appDe.scheduleMedical = HiringStageOrder[0].Schedule_Medical__c;  
             }
            else if(selectedApp.RecordType.Name =='Field MAP(TSS-EDCH)' && lstHRAssement[0].Assessment_Name__c=='CHAB') {
                       			appDe.scheduleCBT = HiringStageOrder[0].Schedule_CBT__c;
      							appDe.scheduleMedical = HiringStageOrder[0].Schedule_Medical__c;  
             }
             else if(selectedApp.RecordType.Name =='TSO'){ // && (lstHRAssement[0].Assessment_Name__c=='TSA001' ||lstHRAssement[0].Assessment_Name__c=='TSA002' )) {
//                If (&& lstHRAssement[0].Assessment_Name__c=='TSA001' && lstHRAssement[0].Assessment_Status__c=='Scheduled'){
                       			appDe.scheduleCBT = HiringStageOrder[0].Schedule_CBT__c;
      							appDe.scheduleMedical = HiringStageOrder[0].Schedule_Medical__c;  
             } 
             }
         return appDe;
    }
    public class ApplicationDetails {
        @AuraEnabled
        public  boolean scheduleCBT;
        @AuraEnabled
        public  boolean scheduleMedical;
    }
*/
}