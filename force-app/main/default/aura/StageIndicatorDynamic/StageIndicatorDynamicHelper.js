({
    getApplcationHelper : function(component, event, helper) {
        
        var appl = component.get("c.AppQuery");
        appl.setParams({"appId" : component.get('v.recordId') });
        
        appl.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS"){
                // component.set("v.statusValue", response.getReturnValue());
                var v=  response.getReturnValue();
                //if (v != null && v.Candidate_Portal_Hiring_Stage__c != undefined && v.Candidate_Portal_Hiring_Stage__c != null)
                //{
                var status= v.Candidate_Portal_Hiring_Stage__c;
                component.set("v.statusValue",v.Candidate_Portal_Hiring_Stage__c);
                component.set("v.myChild",v.Candidate_Portal_Hiring_Stage__c);    
                //}
                helper.getPickListValues(component, event, helper);
                helper.checkApplicationStatus(component, event, helper);
            }
            else
                console.log('Search Error::'+ response.getError());
        });
        $A.enqueueAction(appl);
    },
    
    getPickListValues : function(component,event,helper) {
        var action = component.get("c.getStatusValues");
        var para =  component.get("v.recordId");
        var currentStage =component.get("v.statusValue");
        action.setParams( {
            "appId" :para
        }) ;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                component.set('v.steps',response.getReturnValue());
                var appEvent = $A.get("e.c:StageEvents");
                appEvent.setParams({ "allSatges" : response.getReturnValue(),"currentStage":currentStage });
                appEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    checkApplicationStatus : function(component,event,helper){
        var action = component.get("c.shouldHiringStageBeRed");
        var para =  component.get("v.recordId");
        action.setParams( {
            "appId" :para
        }) ;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                component.set('v.failedStep',response.getReturnValue());
            }
            
        });
        $A.enqueueAction(action);
    }
})