trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {

    BatchLeadConvertErrors__c[] insertErrorList = new BatchLeadConvertErrors__c[]{};
    //Loop over the error events
        for (BatchApexErrorEvent err : Trigger.new){
            BatchLeadConvertErrors__c tmpLog = new BatchLeadConvertErrors__c();
            
            tmpLog.AsyncApexJobId__c = err.AsyncApexJobId;
            tmpLog.Records__c = err.JobScope;
            tmpLog.StackTrace__c = err.StackTrace;
            insertErrorList.add(tmpLog);
          }
    
//insert batch error records

    insert insertErrorList;
}