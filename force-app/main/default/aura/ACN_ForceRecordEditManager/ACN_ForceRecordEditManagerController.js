({
    handleRefresh: function(component, event, helper) {
        //to-do
    }, 
    handleEdit: function(component, event, helper) {
        component.set("v.isReadOnly", false);
    }, 
    handleSave: function(component, event, helper) {
        var forceRecordEditRecordId = component.get("v.recordId");
        if (!forceRecordEditRecordId) {
            return;
        }
        var forceRecordEditSaveRequested = $A.get("e.c:ACN_ForceRecordEditSaveRequested");
        forceRecordEditSaveRequested.setParams({
            "recordId": forceRecordEditRecordId, 
            "sectionId": forceRecordEditRecordId
        });
        forceRecordEditSaveRequested.fire();
    },
    handleForceRecordEditSaveFailed: function(component, event, helper) {
        
    },
    handleForceRecordEditSaveCompleted: function(component, event, helper) {
        component.set("v.isReadOnly", true);
    }
})