public with sharing class HR_CandidateAppSchedulerController {
    
    @AuraEnabled
    public static boolean getButtonDetails(String applicationId){
        HR_Application__c selectedApp = [SELECT ID, RecordType.Name, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c , Application_Status__c, SSO_Link_Request_Indicator__c 
                                         FROM HR_Application__c 
                                         WHERE Id=:applicationId];
        List<HR_Application_Hiring_Stage__mdt> HiringStageOrder = [SELECT Id, App_Scheduler__c, Internal_Stages__c, External_Stages__c, Order__c 
                                                                   FROM HR_Application_Hiring_Stage__mdt 
                                                                   WHERE Workstream__c = :selectedApp.RecordType.Name 
                                                                   and Hiring_Stages__c =: selectedApp.Hiring_Stage__c
                                                                   and External_Stages__c =: selectedApp.Candidate_Portal_Hiring_Stage__c
                                                                   ORDER BY Order__c ASC];
        if(selectedApp.Application_Status__c == 'Accepted' || selectedApp.Application_Status__c == 'Declined' ||selectedApp.Application_Status__c == 'Withdrawn') 
            //            || selectedApp.SSO_Link_Request_Indicator__c )
        {
            return false;
        }
        return HiringStageOrder[0].App_Scheduler__c;
    }

    @AuraEnabled
    public static AppWrapper getApplicationDetails(String applicationId) {
        List<HR_Application__c> lstHrApp = [SELECT ID,Location__c,Airport_Code__c,Candidate__c,
                                            Record_Type_Name__c,Hiring_Stage__c
                                            FROM HR_Application__c where id =:applicationId Limit 1];
        
        System.debug('gg'+lstHrApp);
        Set<Id> locationId = new Set<Id>();
        Set<Id> setCandidateId = new Set<Id>();
        if(!lstHrApp.isEmpty()){
           /* if(lstHrApp[0].JOA_Location_Position__c !=null){
               locationId.add(lstHrApp[0].JOA_Location_Position__r.Location__c) ; 	
            }*/
            if(lstHrApp[0].Candidate__c !=null && lstHrApp[0].Hiring_Stage__c !=NULL && getButtonDetails(applicationId)){
                setCandidateId.add(lstHrApp[0].Candidate__c);
            }
        }
        Id recordTypeId = Schema.SObjectType.HR_Assessment__c.getRecordTypeInfosByDeveloperName().get('Airport_Assessment').getRecordTypeId();
       List<HR_Assessment__c> lstHRAssement = new List<HR_Assessment__c>();
        if(!setCandidateId.isEmpty() && recordTypeId !=null) {
          lstHRAssement  =  [Select id,Assessment_Status__c from HR_Assessment__c where Candidate__c =:setCandidateId  and recordTypeId =:recordTypeId
                             order by createdDate desc limit 1];
        }
        AppWrapper app = new AppWrapper();
        if(!lstHrApp.isEmpty()) {
            
            app.location =lstHrApp[0].Location__c==null?'':lstHrApp[0].Location__c;
            app.airportCode =lstHrApp[0].Airport_Code__c==null?'':lstHrApp[0].Airport_Code__c;
            app.applicationId =applicationId;
        }
        if(!lstHRAssement.isEmpty()){
            if(lstHRAssement[0].Assessment_Status__c=='Invited') {
                app.assessmentId = lstHRAssement[0].Id;  
            }
            if(lstHRAssement[0].Assessment_Status__c=='Scheduled') {
              app.cancelAssessmentId = lstHRAssement[0].Id;    
            }
          
        }
        return app;
        
    }
    
    public class AppWrapper {
        @AuraEnabled
        public  string location ='';
        @AuraEnabled
        public  string airportCode ='';
        @AuraEnabled
        public  string applicationId ='';
        @AuraEnabled
        public  string assessmentId ='';
           @AuraEnabled
        public  string cancelAssessmentId ='';
    }
    
}

/*
I’ve done some more thinking about the solution to CANCEL a Service Appointment. Since we need to get the Service Appointment ID, 
I want to share two solutions and see what you think works best. I know we chatted about this on a call today but I wanted to get it in
words to see what works and if I need to reach out to Karen.  

1)	Can you use the HR Assessment ID as a look-up to the Service Appointment object? The Service Appointment 
would have a Status of Scheduled and the HR_Assessment__c field would = the ID of the HR Assessment you’ve already got a solution for. 
Invited


Scheduled



2)	Should I reach out to Karen to see if Team 3 is open to adding the Service Appointment ID to the HR Assessment and then 
when scheduling I take care of adding it to the HR Assessment automatically? 
*/

/*
    @AuraEnabled
    public static AppWrapper getApplicationDetails(String applicationId) {
        List<HR_Application__c> lstHrApp = [SELECT ID,Location__c,Airport_Code__c,
                                            Record_Type_Name__c,Hiring_Stage__c
                                            FROM HR_Application__c where id =:applicationId Limit 1];
        
        System.debug('gg'+lstHrApp);
        Set<Id> licationId = new Set<Id>();
        Set<Id> setCandidateId = new Set<Id>();
        AppWrapper app = new AppWrapper();
        if(!lstHrApp.isEmpty()) {
            
            app.location =lstHrApp[0].Location__c==null?'':lstHrApp[0].Location__c;
            app.airportCode =lstHrApp[0].Airport_Code__c==null?'':lstHrApp[0].Airport_Code__c;
            app.applicationId =applicationId;
        }
        return app;
        
    }
    
    public class AppWrapper {
        @AuraEnabled
        public  string location;
        @AuraEnabled
        public  string airportCode;
        @AuraEnabled
        public  string applicationId;
    }
    
}

------------------
         if(!lstHRAssement.isEmpty() && lstHRAssement[0].Assessment_Status__c=='Invited'){
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
            else if(selectedApp.RecordType.Name =='TSO' && lstHRAssement[0].Assessment_Name__c=='TSA001' ) {
//                If (&& lstHRAssement[0].Assessment_Name__c=='TSA001' && lstHRAssement[0].Assessment_Status__c=='Scheduled'){
                       			appDe.scheduleCBT = HiringStageOrder[0].Schedule_CBT__c;
      							appDe.scheduleMedical = HiringStageOrder[0].Schedule_Medical__c;  
             } 

--------------------------

*/