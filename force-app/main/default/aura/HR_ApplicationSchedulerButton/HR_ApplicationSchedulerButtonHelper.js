({
	getApplicationDetails : function(component, event, helper) {
		  let applicationId	= component.get("v.recordId");
        let action			= component.get("c.getApplicationDetails");
        action.setParams({
            applicationId : applicationId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
               var returnValue = response.getReturnValue();
                if(returnValue !=null && returnValue !='') {
                    console.log('returnValue'+returnValue);
                   
                      component.set("v.assesmentId",returnValue.assessmentId);
                    if(returnValue.assessmentId !=null && returnValue.assessmentId !='') {
                        component.set("v.showButton",true);
                    } else{
                         component.set("v.showButton",false);
                    }
                      component.set("v.location",returnValue.location);
                      component.set("v.airportCode",returnValue.airportCode);
                     component.set("v.cancelAssessmentId",returnValue.cancelAssessmentId);
                 if(returnValue.cancelAssessmentId !=null && returnValue.cancelAssessmentId !='') {
                         component.set("v.cancelButton",true);
                 }else{
                     component.set("v.cancelButton",false);
                 }
                    
                } else{
                    
                }

            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action)
	}
})