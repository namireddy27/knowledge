({
    doInit: function(component, event, helper) {
        var isCanvas = component.get("v.isCanvas");
        //debugger;
        if (isCanvas) {
            helper.getCanvasResponse(component, event, helper);
        }
        else {
            var urlFieldName = component.get("v.urlFieldName");
            var recordFields = component.get("v.recordFields");
            recordFields = [];
            recordFields.push(urlFieldName);
            component.set("v.recordFields", recordFields);
        }
    },
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            //console.log("Record is loaded successfully.");
			//helper.loadViewport(component, event, helper);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
            
        }
    },
    onCanvasAppLoad: function(component, event, helper) {
    }, 
    onCanvasSubscribed: function(component, event, helper) {
    }, 
    onCanvasAppError: function(component, event, helper) {
    }
})