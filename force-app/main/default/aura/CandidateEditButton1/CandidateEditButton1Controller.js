({

    handleSuccess: function(component, event, helper){
        helper.handleFormSubmit(component);
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
    

    handleCancel : function(component, event, helper) {
     component.set("v.saved",true);
    },
    
    handelError : function(component,event,helper) {
             var error = event.getParam("error");
            if(error!=undefined) {
                if(error.body["output"].errors[0].errorCode == 'FIELD_CUSTOM_VALIDATION_EXCEPTION') {
                    errorDuplicate = error.body["output"].errors[0].message ; 
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": errorDuplicate,
                        "type":"Error"
                    });
                } else {
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Some Error Occured!",
                        "type":"Error"
                    });
                }
                
            }
    }
    
    
})