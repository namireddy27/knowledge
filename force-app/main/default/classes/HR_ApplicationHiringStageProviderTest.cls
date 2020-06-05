@isTest
public class HR_ApplicationHiringStageProviderTest {
 static testMethod void classTest() {
     HR_App__C hrapp  = new HR_App__c();
        Id RecordTypeIdContact = Schema.SObjectType.HR_App__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
        hrapp.RecordTypeId = RecordTypeIdContact;
        insert hrapp;
     

 }
}