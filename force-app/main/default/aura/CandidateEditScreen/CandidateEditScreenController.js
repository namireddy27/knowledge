({
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
            "url" :"/candidateportal/s/"
        });
        urlEvent.fire();
    },
    // cancel button
         closeModel: function(component, event, helper){
          var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" :"/candidateportal/s/"
        });
        urlEvent.fire();
     }
    
    
    
})