@IsTest
public class HR_CandidateAppSchedularControllerTest {
 static testMethod void classTest() {
     
     Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('TSO_Field_Offcie').getRecordTypeId();
     Account acc = new Account();
     acc.Name ='Venu Reddy';
     acc.RecordTypeId =RecordTypeIdAccount;
     insert acc;

     HR_Application__C hrapp = new HR_Application__C();

     Id RecordTypeIdContact = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('TSO').getRecordTypeId();
     hrapp.Candidate_Portal_Hiring_Stage__c = 'Airport Assessment';
     hrapp.Hiring_Stage__c = 'Airport Assessment';
//     hrapp.Candidate_Portal_Hiring_Stage__c =  'Airport Assessment';
     // hrapp.Accept__c = true;
     hrapp.RecordTypeId = RecordTypeIdContact;
     hrapp.Candidate__c =acc.Id;
     insert hrapp;

     Id recordTypeId = Schema.SObjectType.HR_Assessment__c.getRecordTypeInfosByDeveloperName().get('Airport_Assessment').getRecordTypeId();
     HR_Assessment__c hroff = new HR_Assessment__c();
     hroff.RecordTypeId =recordTypeId;
     hroff.Candidate__c =acc.Id;
     hroff.Assessment_Status__c ='Invited';
     hroff.Assessment_Name__c ='Airport Assessment';
     insert hroff;
     
     HR_CandidateAppSchedulerController.getApplicationDetails(hrapp.id);

     HR_Application__C hrapp2 = new HR_Application__C();

    //Id RecordTypeIdContac2t = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
     hrapp.Hiring_Stage__c = 'Qualification Review';
     hrapp2.Application_Status__c = 'Accepted';
    // hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
     // hrapp.Accept__c = true;
     hrapp2.RecordTypeId = RecordTypeIdContact;
     hrapp2.Candidate__c =acc.Id;
     insert hrapp2;
     HR_CandidateAppSchedulerController.getButtonDetails(hrapp2.Id);
     
 }

}