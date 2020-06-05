({
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
    },
    handleEdit : function(component, event, helper) {
        component.set("v.showConfirtmation",true);
    },
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
    },
    handleAccept : function(component, event,helper){      
        
        let applicationId	= component.get("v.recordId");
        
        let action			= component.get("c.accepted");
        action.setParams({
            applicationId : applicationId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
                //                console.log('Offer Accepted !');
                component.set("v.showConfirtmation",false);
                //                window.location.reload();
                $A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": response.getReturnValue()
                });
                toastEvent.fire();
                
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);         
    },
    
})