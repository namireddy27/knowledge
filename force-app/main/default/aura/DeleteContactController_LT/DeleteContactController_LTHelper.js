({
    onDelete: function(component, event, helper) {
        helper.deleteContact(component);
    },
    onCancel:function(component){
        $A.get('e.force:closeQuickAction').fire();
    }
})