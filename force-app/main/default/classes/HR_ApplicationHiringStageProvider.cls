Global class HR_ApplicationHiringStageProvider implements ACN_NavigationProviderService{
    /*
 
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
        //recordId = 'a15r0000000aDNdAAM';
        
        //Grabs the Application record passesd in from the community 
        HR_Application__c currentApp = [SELECT Id, RecordType.Name, Hiring_Stage__c, Candidate_Portal_Hiring_Stage__c FROM HR_Application__c WHERE Id = :recordId LIMIT 1];
        
        //System.debug('Application: HiringStage: ' + currentApp.Hiring_Stage__c + ' External: ' + currentApp.Candidate_Portal_Hiring_Stage__c);
        
        //Grabs the Applicant hiring stages metadata
        List<HR_Application_Hiring_Stage__mdt> HiringStageOrder = [SELECT Id, Internal_Stages__c, External_Stages__c, Order__c 
                                                                   FROM HR_Application_Hiring_Stage__mdt 
                                                                   WHERE Workstream__c = :currentApp.RecordType.Name 
                                                                   ORDER BY Order__c ASC];
        
        //Compares the hiring stage from the metadata and matches it up the hiring stages on the Application record.
        //When they match the hiringStageNumber is set to the index
        Integer hiringStageNumber = -1;
        Integer index = 0;
        while(hiringStageNumber < 0 && index < HiringStageOrder.size()){
            if(currentApp.Hiring_Stage__c == HiringStageOrder[index].Internal_Stages__c && 
               currentApp.Candidate_Portal_Hiring_Stage__c == HiringStageOrder[index].External_Stages__c){
                hiringStageNumber = index;
            }
            index++;
        }
        
        //System.debug('Hiring Stage Number: ' + hiringStageNumber);
        
        //Grabs the record Id of the Master Navigation Item
        ACN_NavigationItem__c masterNI = [SELECT Id, Code__c FROM ACN_NavigationItem__c WHERE Code__c = :code LIMIT 1];
        
        //System.debug('Master Code: ' + masterNI.Code__c);
        
        //Grabs the Navigation Item that relates to the workstream of the application and the Master NI
        ACN_NavigationItem__c workstreamNI = [SELECT Id, Code__c, GroupName__c 
                                              FROM ACN_NavigationItem__c 
                                              WHERE GroupName__c = :currentApp.RecordType.Name 
                                              AND ParentNavigationItemId__c = :masterNI.Id
                                              LIMIT 1];
        
        //System.debug('Workstream Code: ' + workstreamNI.Code__c);
        
        //Matches the hiring stage from the children of the workstream NI to the hiring stages on the Application record
        ACN_NavigationItem__c hiringStageNI = [SELECT Id, Code__c, Order__c
                                               FROM ACN_NavigationItem__c 
                                               WHERE ParentNavigationItemId__c = :workstreamNI.Id
                                               AND Order__c = :HiringStageOrder[hiringStageNumber].Order__c];
        
        //System.debug('Hiring Stage: ' + hiringStageNI.Code__c);
        //System.debug('Hiring Stage Code: ' + hiringStageNI.Code__c);
        
        //Sets the code from the NI to the request Id so data can be displayed
        request.Id = hiringStageNI.Code__c;
        ACN_NavigationLibrary.NavigationList navList = originalProvider.GetNavigationList(request);
        List<ACN_NavigationLibrary.NavigationListItem> items = new List<ACN_NavigationLibrary.NavigationListItem>();
        Map<String, ACN_NavigationLibrary.NavigationListItem> groupItems = new Map<String, ACN_NavigationLibrary.NavigationListItem>();
        Map<String,String> cardValues = new Map<String,String>();
        
        return navList;
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
    }        */
}