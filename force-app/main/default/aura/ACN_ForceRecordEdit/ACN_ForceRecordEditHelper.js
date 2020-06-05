({
	setAutoSave: function(component, event, helper) {
        if (component.isValid()) {
            if (component.get("v.isAutoSaveEnabled")) {
                window.setTimeout(
                    $A.getCallback(function() {
                        var recordId = component.get("v.recordId");
                        var divContainerId = "acn-record-edit-id-" + recordId;
                        var divContainer = document.getElementById(divContainerId);
                        if (divContainer) {
                            var elements = divContainer.getElementsByTagName("input");
                            var callBack = function(event) {
                                component.set("v.saveNow", true);
                            };
                            
                            for (var elementIndex = 0; elementIndex < elements.length; elementIndex++) {
                                var element = elements[elementIndex];
                                
                                if (element.offsetParent !== null) {
                                    element.addEventListener("blur", callBack);
                                }
                            }
                        }
                    }), 5000
                );
            }                
        }		
	},
    monitorSaveException: function(component, event, helper) {
		var recordId = component.get("v.recordId");
		var sectionId = component.get("v.sectionId");
        var exceptionMessageInterval = component.get("v.exceptionMessageInterval");
        var isSaving = component.get("v.isSaving");
        var isLightningComponent = component.get("v.isLightningComponent");
        var validationIsRequired = component.get("v.validationIsRequired");
        var validationProviderName = component.get("v.validationProviderName");
        if(isSaving && exceptionMessageInterval===-1) {
            exceptionMessageInterval = window.setInterval(
                $A.getCallback(function() {
                    var divContainerId = "acn-record-edit-id-" + recordId;
                    var divContainer = document.getElementById(divContainerId);
                    if (divContainer) {
                        if (!isLightningComponent) {
                            var pageLevelErrors = divContainer.getElementsByClassName("pageLevelErrors");
                            if (pageLevelErrors && pageLevelErrors.length > 0) {
                                if (pageLevelErrors[0].innerHTML) {
                                    helper.stopSaveExceptionMonitor(component, event, helper);
                                    component.set("v.hasSaveException", true);
                                    component.set("v.isSaving", false);
                                    var forceRecordEditSaveFailed = $A.get("e.c:ACN_ForceRecordEditSaveFailed");
                                    forceRecordEditSaveFailed.setParams({
                                        "recordId": recordId, 
                                        "sectionId": sectionId
                                    });
                                    forceRecordEditSaveFailed.fire();
                                }
                            }
                        }
                    }
                }), 2000
            );
            component.set("v.exceptionMessageInterval", exceptionMessageInterval);
        }
    }, 
    stopSaveExceptionMonitor: function(component, event, helper) {
        var exceptionMessageInterval = component.get("v.exceptionMessageInterval");
        if (exceptionMessageInterval !==-1) {
			window.clearInterval(exceptionMessageInterval);
            component.set("v.exceptionMessageInterval", -1);
        }
    }
})