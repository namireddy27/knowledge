global without sharing class HR_ApplicationHiringStageProvider implements ACN_NavigationProviderService{
    
    global ACN_NavigationLibrary.NavigationList GetNavigationList (ACN_NavigationLibrary.NavigationRequest request) {
        System.debug('Entering Provider');
        ACN_NavigationProviderService originalProvider = new ACN_CustomObjectListViewProvider();
        
        String composedRequestId = request.Id; //code nav item + ":" + currentRecordId ({!recordId})
        List<String> idParts = composedRequestId.split(':');
        String code = idParts[0];
        String recordId = '';
        if (idParts.size()>1) {
            recordId = idParts[1];
        }
        String value = '';
        if (idParts.size()>2) {
            value = idParts[2];
        } 
        System.debug('RecordId: ' + recordId);
        //recordId = 'a15r0000000iT5jAAE';
        
        //Grabs the Application record passesd in from the community 
        HR_Application__c currentApp = [SELECT Id, RecordType.Name, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c, Candidate__c, Application_Status__c FROM HR_Application__c WHERE Id = :recordId LIMIT 1];
        System.debug('Record Type Name: ' + currentApp.RecordType.Name);
        System.debug('Application: HiringStage: ' + currentApp.Hiring_Stage__c + ' External: ' + currentApp.Candidate_Portal_Hiring_Stage__c);
        
        //Grabs the Applicant hiring stages metadata
        List<HR_Application_Hiring_Stage__mdt> HiringStageOrder = [SELECT Id, Internal_Stages__c, External_Stages__c, Order__c, Hiring_Stages__c 
                                                                   FROM HR_Application_Hiring_Stage__mdt 
                                                                   WHERE Workstream__c = :currentApp.RecordType.Name 
                                                                   ORDER BY Order__c ASC];
        for (HR_Application_Hiring_Stage__mdt ah : HiringStageOrder){
            System.debug('Metadata: Internal: ' + ah.Internal_Stages__c + ' External: ' + ah.External_Stages__c + ' Order: ' + ah.Order__c);
        }
        
        //Compares the hiring stage from the metadata and matches it up the hiring stages on the Application record.
        //When they match the hiringStageNumber is set to the index
        Integer hiringStageNumber = -1;
        Integer index = 0;
        while(hiringStageNumber < 0 && index < HiringStageOrder.size()){
            if(currentApp.Hiring_Stage__c == HiringStageOrder[index].Hiring_Stages__c && 
               currentApp.Candidate_Portal_Hiring_Stage__c == HiringStageOrder[index].External_Stages__c){
                   hiringStageNumber = index;
               }
            
            index++;
        }
        
        System.debug('Hiring Stage Number: ' + hiringStageNumber);         //uncomment fot testing
        System.debug('Hiring Stage Number: ' + currentapp.RecordType.name);         //uncomment for testing
        
        //Grabs the record Id of the Master Navigation Item
        ACN_NavigationItem__c masterNI = [SELECT Id, Code__c FROM ACN_NavigationItem__c WHERE Code__c = :code LIMIT 1];
        
        //System.debug('Master Code: ' + masterNI.Code__c);
        
        //Grabs the Navigation Item that relates to the workstream of the application and the Master NI
        ACN_NavigationItem__c workstreamNI = [SELECT Id, Code__c, GroupName__c 
                                              FROM ACN_NavigationItem__c 
                                              WHERE GroupName__c = :currentApp.RecordType.Name 
                                              AND ParentNavigationItemId__c = :masterNI.Id
                                              AND IsActive__c = true
                                              LIMIT 1];
        
        System.debug('Workstream Code: ' + workstreamNI.Code__c);
        
        //Matches the hiring stage from the children of the workstream NI to the hiring stages on the Application record
        ACN_NavigationItem__c hiringStageNI = [SELECT Id, Code__c, Order__c
                                               FROM ACN_NavigationItem__c 
                                               WHERE ParentNavigationItemId__c = :workstreamNI.Id
                                               AND Order__c = :HiringStageOrder[hiringStageNumber].Order__c
                                               AND IsActive__c = true
                                               LIMIT 1];
        
        System.debug('Hiring Stage: ' + hiringStageNI.Code__c);
        System.debug('Hiring Stage Code: ' + hiringStageNI.Code__c);
        
        //Sets the code from the NI to the request Id so data can be displayed
        request.Id = hiringStageNI.Code__c; //conditionalCode;
        ACN_NavigationLibrary.NavigationList navList = originalProvider.GetNavigationList(request);
        List<ACN_NavigationLibrary.NavigationListItem> items = new List<ACN_NavigationLibrary.NavigationListItem>();
        Map<String, ACN_NavigationLibrary.NavigationListItem> groupItems = new Map<String, ACN_NavigationLibrary.NavigationListItem>();
        Map<String,String> cardValues = new Map<String,String>();
        
        System.debug('Calling Conditional Code');
        List<ACN_NavigationLibrary.NavigationListItem> navItems = new List<ACN_NavigationLibrary.NavigationListItem>();
        
        List<String> conditionalCode = getConditionalOrder(workstreamNI.GroupName__c, hiringStageNI.Id, hiringStageNI.Order__c, currentApp);
        
        
        System.debug('changing navitems');
        for (Integer i = 0; i < conditionalCode.size(); i++){
            
            for(Integer j = 0; j < navList.Items.size(); j++){
                if(navList.Items.get(j).Id == conditionalCode.get(i)){
                    System.debug('THis is conditional code: ' + navList.Items.get(j));
                    navItems.add(navList.Items.get(j));
                }
            }
        }     
        navList.Items = navItems;
        
        
        //change
        /**
        String query = 'SELECT ';
        for(Schema.FieldSetMember flm : appFieldSet){
            query += flm.getFieldPath() + ', ';
        }
        query += 'Id FROM HR_Application__c WHERE Id = \'' + currentApp.Id + '\' LIMIT 1';
**/
        System.debug('THis is assmt List: ' + HR_ApplicationHiringStageController.asmtList);
        System.debug('Space');
        navList = ApplicationMergeFields(navList, recordId);
        if(HR_ApplicationHiringStageController.asmtList != NULL ){
            navList = AssessmentMergeFields(navList, HR_ApplicationHiringStageController.asmtList);
        }
        
        
        return navList;
    }
    //end change
    private static List<String> getConditionalOrder(String workstream, String hiringStageId, Decimal order, HR_Application__c currentApp){
        //Account candidate = [SELECT Id, Name FROM Account WHERE Id = :currentApp.Candidate__c LIMIT 1];
        //Map<Integer,String> orderMap = new Map<Integer,String>{10 => 'Default', 20 => 'Invited', 30 => 'Scheduled', 40 => 'Positive', 50 => 'Negative', 99 => 'Withdrawn'};
        List<String> returnCode = new List<String>();
        List<Integer> orderList = new List<Integer>();
//        if(currentApp.Application_Status__c != 'Withdrawn' && currentApp.Application_Status__c != 'Declined' && currentApp.Application_Status__c != 'Accepted'){
        if(currentApp.Application_Status__c != 'Withdrawn'){
            
            //System.debug('Entering workstream');
            //System.debug(workstream);
            switch on workstream{
                when 'TSO'{
                    orderList = HR_ApplicationHiringStageController.checkTSO(currentApp, order);
                }
                when 'Field MAP'{
                    orderList = HR_ApplicationHiringStageController.checkFieldMAP(currentApp, order);
                }
                when 'Field MAP (STI)'{
                    orderList = HR_ApplicationHiringStageController.checkSTI(currentApp, order);
                }
                when 'Field MAP (TSS-EDCH)'{
                    orderList = HR_ApplicationHiringStageController.checkTSSEDCH(currentApp, order);
                }
                when 'Field MAP (TSI)'{
                    orderList = HR_ApplicationHiringStageController.checkTSI(currentApp, order);
                }
                when 'Field MAP (TSS-E)'{
                    orderList = HR_ApplicationHiringStageController.checkTSSE(currentApp, order);
                }
                when 'FAMS G'{
                    orderList = HR_ApplicationHiringStageController.checkFAMSG(currentApp, order);
                }
                when 'FAMS J (Phase 1)'{
                    orderList = HR_ApplicationHiringStageController.checkFAMSJP1(currentApp, order);
                }
                when 'FAMS J (Phase 2)'{
                    orderList = HR_ApplicationHiringStageController.checkFAMSJP2(currentApp, order);
                }
                when 'FAMS MAP'{
                    orderList = HR_ApplicationHiringStageController.checkFAMSMAP(currentApp, order);
                }
                when 'ERD KL'{
                    orderList = HR_ApplicationHiringStageController.checkERDKL(currentApp, order);
                }
                when 'ERD TSES'{
                    orderList = HR_ApplicationHiringStageController.checkERDTSES(currentApp, order);
                }
                when 'HQ'{
                    orderList = HR_ApplicationHiringStageController.checkHQ(currentApp, order);
                                }
                when else{
                    orderList.add(10);
                }
                
            }
        }
        else{
            orderList.add(99);
            
/*        else if(currentApp.Application_Status__c == 'Withdrawn'){
            orderList.add(99);
        }
         else if(currentApp.Application_Status__c == 'Declined'){
            orderList.add(50);
        }
         else if(currentApp.Application_Status__c == 'Accepted'){
            orderList.add(40);
*/        }
        System.debug(orderList);
        System.debug('Hiring STage id' + hiringStageId);
        List<ACN_NavigationItem__c> acnList = [SELECT Id, Code__c, Order__c 
                                               FROM ACN_NavigationItem__c 
                                               WHERE Order__c IN :orderList 
                                               AND ParentNavigationItemId__c = :hiringStageId];
        for(ACN_NavigationItem__c a : acnList){
            System.debug('This is the code: ' + a.Code__c);
            returnCode.add(a.Code__c);
        }
        
        return returnCode;
    }
    
    
    global ACN_NavigationLibrary.NavigationList GoUp (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
    
    global ACN_NavigationLibrary.NavigationList GoPrevious (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
    
    global ACN_NavigationLibrary.NavigationList GoNext (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
    
    global ACN_NavigationLibrary.NavigationList GoLast (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
    
    
    
    global ACN_NavigationLibrary.NavigationList SavePreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
    
    global ACN_NavigationLibrary.NavigationList LoadPreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
    
    private ACN_NavigationLibrary.NavigationList ApplicationMergeFields(ACN_NavigationLibrary.NavigationList navList, String recordId){
        List<Schema.FieldSetMember> appFieldSet = SObjectType.HR_Application__c.FieldSets.HR_ApplicationHiringStageProvider.getFields();
        HR_Application__c currentApp = [SELECT Id, Hiring_Stage__c, Job_Title__c FROM HR_Application__c WHERE Id = :recordId LIMIT 1];
        
        try{
        for(ACN_NavigationLibrary.NavigationListItem n : navList.Items){
            for(Schema.FieldSetMember flm : appFieldSet){
                n.description = n.description.replace('{!' + flm.getLabel() + '}', String.valueOf(currentApp.get(flm.getFieldPath())));
            }
        }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        return navList;
    }
    
    private ACN_NavigationLibrary.NavigationList AssessmentMergeFields(ACN_NavigationLibrary.NavigationList navList, List<HR_Assessment__c> asmtList){
        List<Schema.FieldSetMember> asmtFieldSet = SObjectType.HR_Assessment__c.FieldSets.HR_Assess_ApplicationHiringStageProvider.getFields();
        HR_Assessment__c currentAsmt = [SELECT Id, Assessment_Date__c, Location__c, Candidate__c, Assessment_Status__c, Assessment_Name__c //, Candidate_First_Name__c, Candidate_Last_Name__c, 
                                        FROM HR_Assessment__c WHERE Id = :asmtList[0].Id LIMIT 1];

/*                
        System.debug('First Name: ' + currentAsmt.Candidate_First_Name__c);
        System.debug('Last Name: ' + currentAsmt.Candidate_Last_Name__c);
        System.debug('Time Before: ' + currentAsmt.Assessment_Date__c);
        currentAsmt.Assessment_Date__c.format();
        System.debug('Time After: ' + currentAsmt.Assessment_Date__c);

        System.debug('Time Before: ' + currentAsmt.Assessment_Date__c);
        currentAsmt.Assessment_Date__c = currentAsmt.Assessment_Date__c.date();
         System.debug('Time After: ' + currentAsmt.Assessment_Date__c);
 */       
        try{
            for(ACN_NavigationLibrary.NavigationListItem n : navList.Items){
                for(Schema.FieldSetMember flm : asmtFieldSet){
                    System.debug('fm: '+flm);
                    System.debug('ni: ' +n);
                    if(String.valueOf(currentAsmt.get(flm.getFieldPath())) != NULL){
                        n.description = n.description.replace('{!' + flm.getLabel() + '}', String.valueOf(currentAsmt.get(flm.getFieldPath())));
                    }
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        return navList;
    }
    
}