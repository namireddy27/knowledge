({ //automation
    doInit: function(component, event, helper) {
        let applicationId	= component.get("v.recordId");
        let action			= component.get("c.getButtonDetails");
        action.setParams({
            applicationId : applicationId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.showButton",response.getReturnValue());
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
    },     // automation end
    handleEdit : function(component, event, helper) {
        component.set("v.showConfirtmation",true);
    },
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
    },
    handleDecline : function(component, event,helper){      
        
        var decreason = component.find("declineReason");
        var value=decreason.get("v.value");
        if(value == "" && value.trim() == ""){
           decreason.set("v.errors", [{message:"Please select a reason of  declining offer"}]);
            $A.util.addClass(decreason, 'slds-has-error');
            decreason.showHelpMessageIfInvalid();
            
        } else {
            decreason.set("v.errors",null);
             $A.util.removeClass(decreason, 'slds-has-error');
            let applicationId	= component.get("v.recordId");
            let reason	= component.get("v.reason");
            
            let action= component.get("c.declined"); //automation
            action.setParams({
                applicationId : applicationId,
                reason : reason,
            });
            //        debugger;
            action.setCallback(this, function(response){
                let state = response.getState();
                if(state == "SUCCESS"){
                    //                console.log('Application Offer Declined !');
                    component.set("v.showConfirtmation",false);
                    //                window.location.reload();
                    $A.get('e.force:refreshView').fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Offer Declined Succesfully"
                    });
                    toastEvent.fire();
                }
                else{
                    alert('ERROR');
                }
            });
            $A.enqueueAction(action);       
        }
        
        
    },
    
})

/*    requestContact: function(component, event, helper) {
		  let applicationId	= component.get("v.recordId");
        let action			= component.get("c.requestandEmail");
        action.setParams({
            applicationId : applicationId,
        });
         action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){

            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
	},
*/