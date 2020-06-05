({
	myAction : function(component, event, helper) {
		
	}
})({
    myAction : function(component, event, helper) {
        
    },
    handleSuccess: function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
       
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" :"/capricorncafe/s/"
        });
        urlEvent.fire();
    },
    
    
    
})