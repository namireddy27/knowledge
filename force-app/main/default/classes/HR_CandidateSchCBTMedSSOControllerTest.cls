@IsTest
public class HR_CandidateSchCBTMedSSOControllerTest {
    
    static testMethod void classTest() {
       
        Id RecordTypeIdContact1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('TSA Person').getRecordTypeId(); 
        Account acc = new Account();
        acc.Name ='Venu Reddy';
//        acc.LastName ='Reddy';
//        acc.Email_Address__c ='v@googlereddy.com';
        acc.RecordTypeId = RecordTypeIdContact1;
        insert acc;
        
        HR_Application__C hrapp = new HR_Application__C(); 
        
        Id RecordTypeIdContact2 = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Hiring_Stage__c = 'Qualification Review';
        hrapp.Application_Status__c ='Accepted';
        hrapp.RecordTypeId = RecordTypeIdContact2;
        hrapp.Candidate__c =acc.Id;
        insert hrapp;
        
        Id RecordTypeIdContact3 = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        HR_Application__C hrapp2 = new HR_Application__C();    
        hrapp2.Hiring_Stage__c = 'Qualification Review';
        hrapp2.RecordTypeId = RecordTypeIdContact3;
        hrapp2.Candidate__c =acc.Id;
        insert hrapp2;
        
         Id RecordTypeIdContact4 = Schema.SObjectType.HR_Assessment__c.getRecordTypeInfosByName().get('Airport Assessment').getRecordTypeId();

        HR_Assessment__c assesment  = new HR_Assessment__c();
        assesment.Assessment_Status__c ='Invited';
        assesment.Assessment_Name__c ='FAB';
        assesment.Candidate__c = acc.Id;
        assesment.RecordTypeId=RecordTypeIdContact4;
        insert assesment;
        
     /*   HR_CandidateSchCBTMedSSOController.updateTogetSSOLink(String.valueOf(hrapp.id));
        HR_CandidateSchCBTMedSSOController.updateExtSystemStatus(String.valueOf(hrapp.id));
        HR_CandidateSchCBTMedSSOController.getnewSSOLink(String.valueOf(hrapp.id));
        HR_CandidateSchCBTMedSSOController.getExternalSystemStatus(String.valueOf(hrapp.id));
        HR_CandidateSchCBTMedSSOController.getButtonDetails(String.valueOf(hrapp.id));
        HR_CandidateSchCBTMedSSOController.getButtonDetails(String.valueOf(hrapp.id));*/
    }
    
    
    static testmethod void testcase2() {
                Id RecordTypeIdContact1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('TSA Person').getRecordTypeId(); 
        Account acc = new Account();
        acc.Name ='Venu Reddy';
//        acc.LastName ='Reddy';
//        acc.Email_Address__c ='v@googlereddy.com';
        acc.RecordTypeId = RecordTypeIdContact1;
        insert acc;
        
    }
}