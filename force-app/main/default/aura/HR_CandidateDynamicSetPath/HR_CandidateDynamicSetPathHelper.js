({
    getApplcationHelper : function(component, event, helper) {
		
        var appl = component.get("c.AppQuery");
       appl.setParams({"appId" : component.get('v.recordId') });
        
        appl.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS"){
                var v=  response.getReturnValue();
                var status= v.Candidate_Portal_Hiring_Stage__c;
                let environment = component.get("v.environmentType");
                console.log(environment);
                if(environment === 'Community'){
                    component.set("v.statusValue",v.Candidate_Portal_Hiring_Stage__c);
                }
                else if(environment === 'Lightning'){
                    console.log("value: ");
                    component.set("v.statusValue", v.Hiring_Stage__c);
                }
                //component.set("v.myChild",v.Candidate_Portal_Hiring_Stage__c);    
                helper.getPickListValues(component, event, helper); // added this from controller
            }
            else
                console.log('Search Error::'+ response.getError());
        });
        $A.enqueueAction(appl);
    },
    getPickListValues : function(component,event,helper) {
        var action = component.get("c.getStatusValues");
        var para =  component.get("v.recordId");
        var environment = component.get("v.environmentType");
//        var currentStage = component.get("v.statusValue");      ////
        action.setParams( {
            "appId" :para,
            "environmentType" : environment
        }) ;
        action.setCallback(this, function(response) {
           var state = response.getState();
            if(state == 'SUCCESS') {
                var stagesDetails = new Array();
                
                var stages = response.getReturnValue();
                var stagesLength = stages.length;
                //Check the length of component
                var length = 1120;
                var lengthofoneblock = 1120 / stages.length;
                var halflength = lengthofoneblock / 2;
                
                //Current status
                var statusValue = component.get("v.statusValue");
                var completed = 1;
                
                //completed is 3 = none
                //completed is 2 = In Progress
                //completed is 1 = Completed
                if(statusValue == null)
                {
                    completed = 3;
                }
                for(var i = 0; i < stages.length; i ++)
                {
                    //set completed to 3 after completed
                     if(completed == 2)
                     {
                         completed = 3;
                     }
                    //set completed to 3 after completed
                    if(statusValue == stages[i])
                    {
                        completed = 2;
                    }
                  
                    stagesDetails.push({step: stages[i], style: 'left:' + ((i * lengthofoneblock )) + 'px' , showHover: false, completed:completed });
                }
                //set steps object for iteration
               component.set('v.steps',stagesDetails);
               
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