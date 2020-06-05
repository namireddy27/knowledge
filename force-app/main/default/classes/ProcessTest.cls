@isTest

public class ProcessTest {
    static testMethod void updateExternalStageTest() {
        Navigation_Items__c parentnNAV = new Navigation_Items__c();
        parentnNAV.Name = 'Internal Parent';
        insert parentnNAV;
        
        Navigation_Items__c parentnNAV1 = new Navigation_Items__c();
        parentnNAV.Name = 'Ext Parent';
        insert parentnNAV1;
            
        Navigation_Items__c externalNav = new Navigation_Items__c();
        externalNav.Name = 'Ext_Navigation_Records__c';
        externalNav.ParentNavigationItemId__c = parentnNAV1.Id;
        insert externalNav;
        
        Navigation_Items__c internalNav = new Navigation_Items__c();
        internalNav.Name = 'Inter_Navigation_Record__c';
        internalNav.Stage_Indentifer__c = 'Internal';
          internalNav.ParentNavigationItemId__c = parentnNAV.Id;
        insert internalNav;
        
        HR_Navigation__c hrnav = new HR_Navigation__c();
        hrnav.Record_Type__c = 'Field MAP';
        hrnav.External_Navigation_Records__c = externalNav.id;
        hrnav.Internal_Navigation_Record__c = internalNav.id;
        hrnav.Application_Hiring_Stage__c = 'Application Received';
        insert hrnav;
        
    	HR_App__C hrapp  = new HR_APp__c();
        Id RecordTypeIdContact = Schema.SObjectType.HR_App__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Hiring_Stage__c = 'Application Received';
        hrapp.RecordTypeId = RecordTypeIdContact;
        insert hrapp;
        
        List<HR_App__C> listHR = new List<HR_App__C> ();
        listHR.add(hrapp);
        
        Process.updateExternalStage(listHR);
        
    }
}