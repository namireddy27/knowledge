trigger hrapplicationTrigger on HR_Application__c (before insert, before update) {
    
   if((trigger.isInsert  || trigger.isUpdate) && trigger.isBefore) {
      List<HR_Application__c> lsthrApp = trigger.new;
       Map<Id, HR_Application__c> oldMap = (Map<Id,HR_Application__c>)Trigger.OldMap;
         Id recordTypeId1 = Schema.SObjectType.HR_Application__c.getRecordTypeInfosByDeveloperName().get('Field_MAP_TSI').getRecordTypeId(); 
         Id recordTypeId2 = Schema.SObjectType.HR_Application__c.getRecordTypeInfosByDeveloperName().get('Field_MAP_TSS_EDCH').getRecordTypeId(); 
         Id recordTypeId3 = Schema.SObjectType.HR_Application__c.getRecordTypeInfosByDeveloperName().get('Field_MAP_TSS_E').getRecordTypeId(); 
         Id recordTypeId4 = Schema.SObjectType.HR_Application__c.getRecordTypeInfosByDeveloperName().get('Field_MAP_STI').getRecordTypeId(); 
         Id recordTypeId5 = Schema.SObjectType.HR_Application__c.getRecordTypeInfosByDeveloperName().get('FAMS_G').getRecordTypeId();
         Id recordTypeId6 = Schema.SObjectType.HR_Application__c.getRecordTypeInfosByDeveloperName().get('FAMS_J').getRecordTypeId();   
       for(HR_Application__c hrapp:lsthrApp) {
            if(hrapp.Monster_Status__c =='AP' && oldMap !=null && oldMap.get(hrapp.id).Monster_Status__c !='AP' 
               && hrapp.Hiring_Stage__c=='Qualification Review') {
                if(hrapp.recordTypeId== recordTypeId1) {
                    hrapp.Hiring_Stage__c ='CBT';
                }
                if(hrapp.recordTypeId==recordTypeId2) {
                    hrapp.Hiring_Stage__c ='CBT';
                }
                if(hrapp.recordTypeId==recordTypeId3) {
                    hrapp.Hiring_Stage__c ='Structured Interview';
                }
                if(hrapp.recordTypeId==recordTypeId4) {
                    hrapp.Hiring_Stage__c ='Structured Interview/Training Demo';
                }
                if(hrapp.recordTypeId==recordTypeId5) {
                    hrapp.Hiring_Stage__c ='CBT';
                }
                if(hrapp.recordTypeId==recordTypeId6) {
                    hrapp.Hiring_Stage__c ='CBT';
                }
            }
        }
      
   }

}

/*
When Candidate Monster Staus ='AP'
Appl Rec Type:
1.TSI & TSS-EDCH   -> Hiring Stage -> CBT
2. TSS-E -> Structured Interview
3. STI -> Structured Interview/Training Demo
4. FAMS G & FAMS J1 -> Qualification review to Next Stage
*/