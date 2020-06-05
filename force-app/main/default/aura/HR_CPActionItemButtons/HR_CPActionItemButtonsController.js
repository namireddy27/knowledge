({
    doInit: function(component, event, helper) {
        var applicationId	= component.get("v.recordId");
       	console.log('applicationId'+applicationId);
        component.set('v.applicationId',applicationId);
       // $A.get('e.force:refreshView').fire(); 
    }
})