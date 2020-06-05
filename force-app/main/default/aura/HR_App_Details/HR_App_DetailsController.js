({
    handleApplicationEvent : function(component, event, helper) {
        var message = event.getParam("allStages");
        var currentStage =event.getParam("currentStage");
        component.set('v.allStages',message);
        component.set('v.currentStage',currentStage);
        helper.scriptsLoaded(component, event, helper);
    },
    
    
    
})