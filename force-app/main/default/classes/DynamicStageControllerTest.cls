@isTest

public class DynamicStageControllerTest {
 static testMethod void classTest() {
      

    	HR_App__C hrapp  = new HR_App__c();
        Id RecordTypeIdContact = Schema.SObjectType.HR_App__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
        hrapp.RecordTypeId = RecordTypeIdContact;
        insert hrapp;
   
     
     
  //  List<HR_Application_Hiring_Stage__mdt> abc = DynamicStageController.getcustomMetadata(); 
 
     test.startTest(); 
      DynamicStageController.AppQuery(hrapp.id);
           DynamicStageController.getStatusValues(hrapp.id);
     test.stopTest();
   
     
 }
}