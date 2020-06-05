({
    doInit: function(component, event, helper) {
        var action = component.get("c.getCurrentUser"); // method in the apex class
        action.setCallback(this, function(a) {
            component.set("v.runningUser", a.getReturnValue()); // variable in the component
            component.find("edit").get("e.recordSave").fire();
        });
        $A.enqueueAction(action);
    }
})