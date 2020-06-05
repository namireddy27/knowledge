({
    doInit: function(component, event, helper) {
        
                helper.getApplicationDetails(component, event, helper);

    },
	handleEdit : function(component, event, helper) {
          component.set("v.showConfirmation",true);
                    var flow = component.find("flowData");
       
                   var inputVariables = [
                        {
                            name : "vcity",
                            type : "String",
                            value:component.get('v.location')
                        },
                       {
                            name : "vairportCode",
                            type : "String",
                           value:component.get('v.airportCode')
                        },
                                             {
                            name : "vassesmentId",
                            type : "String",
                           value: component.get('v.assesmentId')
                        },
                        
                    ];
                    
                    // In that component, start your flow. Reference the flow's Unique Name.
                    flow.startFlow("HR_Inbound_Cancel_Service_Appointment",inputVariables);

        
	},
    closeModel : function(component, event, helper){
        component.set("v.showConfirmation",false);
    },
    handleScheduler : function(component, event,helper){      
 
        let applicationId	= component.get("v.recordId");

        let action			= component.get("c.scheduled");
        action.setParams({
            applicationId : applicationId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.showConfirmation",false);
                window.location.reload();
//                $A.get('e.force:refreshView').fire();
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);         
    },
   cancelAssessment : function(component, event, helper) {
                         component.set("v.showConfirmation",true);
                    var flow = component.find("cancelflowData");
       
                   var inputVariables = [
                       /* {
                            name : "vcity",
                            type : "String",
                            value:component.get('v.location')
                        },
                       {
                            name : "vairportCode",
                            type : "String",
                           value:component.get('v.airportCode')
                        },*/
                                             {
                            name : "vCancelAssessmentId",
                            type : "String",
                           value:  component.get("v.cancelAssessmentId")
                        },
                        
                    ];
                    
                    // In that component, start your flow. Reference the flow's Unique Name.
                    flow.startFlow("HR_Inbound_Cancel_Service_Appointment",inputVariables);

        
	},
   
})