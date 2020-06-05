public class HR_Schedule_CBT1_Controller {
    
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
        List<HR_Application_Hiring_Stage__mdt> HiringStageOrder = [SELECT Id, Schedule__c,Schedule_Medical__c, Internal_Stages__c, External_Stages__c, Order__c 
                                                                   FROM HR_Application_Hiring_Stage__mdt 
                                                                   WHERE Workstream__c = :selectedApp.RecordType.Name 
                                                                   and Hiring_Stages__c =: selectedApp.Hiring_Stage__c
                                                                   and External_Stages__c =: selectedApp.Candidate_Portal_Hiring_Stage__c
                                                                   ORDER BY Order__c ASC];
        List<ApplicationAssessmentType__mdt> lstApp =[SELECT id,Assessment_Type__c from ApplicationAssessmentType__mdt 
                                                      WHERE Application_Type__c = :selectedApp.RecordType.Name];
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
        //  Id recordTypeId = Schema.SObjectType.HR_Assessment__c.getRecordTypeInfosByDeveloperName().get('Airport_Assessment').getRecordTypeId();
        List<HR_Assessment__c> lstHRAssement = new List<HR_Assessment__c>();
        if(!setCandidateId.isEmpty() ) {
            lstHRAssement  =  [Select id,Assessment_Status__c,Assessment_Name__c from HR_Assessment__c where Candidate__c =:setCandidateId
                               order by createdDate desc limit 1];
        }
        
        if(!lstHRAssement.isEmpty()  && !lstApp.isEmpty()){
            for(ApplicationAssessmentType__mdt asMs :lstApp) {
                if(asMs.Assessment_Type__c ==lstHRAssement[0].Assessment_Name__c && lstHRAssement[0].Assessment_Status__c=='Invited' && asMs.Application_Record_Type__c == selectedApp.RecordType.Name)
                {
                    appDe.scheduleCBT = HiringStageOrder[0].Schedule__c;
                    appDe.scheduleMedical = HiringStageOrder[0].Schedule_Medical__c; 
                    break;
                }
                else if(asMs.Assessment_Type__c ==lstHRAssement[0].Assessment_Name__c && lstHRAssement[0].Assessment_Status__c=='Scheduled' && asMs.Application_Record_Type__c == selectedApp.RecordType.Name) 
                {
                    
                    appDe.cancelSchedule = true;
                    break;
                }
            }
            
            
        }
        
        return appDe;
        
    }
    
    public class ApplicationDetails {
        @AuraEnabled
        public  boolean scheduleCBT;
        @AuraEnabled
        public  boolean scheduleMedical;
        @AuraEnabled
        public  boolean cancelSchedule;
        
    }
}