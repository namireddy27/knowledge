({
    doInit: function (component, event, helper) {
        var recordIds = [];
        var recordIdsCsv = component.get("v.recordIdsCsv");
        if (recordIdsCsv) {
		    var recordIdsCsvArray = recordIdsCsv.split(",");
            for (var recordIdsCsvArrayIndex in recordIdsCsvArray) {
                recordIds.push(recordIdsCsvArray[recordIdsCsvArrayIndex]);
            }
        }
        
        var recordId = component.get("v.recordId");
        recordIds.push(recordId);
        component.set("v.recordIds", recordIds);
        component.set("v.customLightningComponent", []);
        window.setTimeout(
            $A.getCallback(function() {
                //debugger;
                if(component.isValid()) {
                    var isLightningComponent = component.get("v.isLightningComponent");
                    if (isLightningComponent) {
                        var lightningComponentName = component.get("v.lightningComponentName");
                        var lightningComponentSerializedParameters = component.get("v.lightningComponentParameters");
                        var lightningComponentParameters = {};
                        try {
                            lightningComponentParameters = JSON.parse(lightningComponentSerializedParameters);
                        }
                        catch(e) {
                            
                        }
                        if (lightningComponentName) {
                            $A.createComponent(
                                lightningComponentName, 
                                lightningComponentParameters, 
                                function (newCustomComponent, status, errorMessage) {
                                    switch(status) {
                                        case "SUCCESS":
                                            var customLightningComponent = component.get("v.customLightningComponent");
                                            customLightningComponent.push(newCustomComponent);
                                            component.set("v.customLightningComponent", customLightningComponent);
                                            break;
                                            
                                        case "INCOMPLETE":
                                            console.log("No response from server or client is offline.")
                                            break;
                                            
                                        case "ERROR":
                                            console.log("Error: " + errorMessage);
                                            break;
                                    }
                                }
                            );
                        }
                    }
                }
            }), 500);
    },
    handleExternalValidationRequestCompleted: function(component, event, helper) {
        helper.stopSaveExceptionMonitor(component, event, helper);
        var recordId = component.get("v.recordId");
        var sectionId = component.get("v.sectionId");
        var validationContextId = event.getParam("validationContextId");
        var validationIsRunning = event.getParam("validationIsRunning");
        var validationIsFailed = event.getParam("validationIsFailed");
        var validationMessage = event.getParam("validationMessage");
        
        if (recordId === validationContextId) {
            component.set("v.hasSaveException", validationIsFailed);
            component.set("v.isSaving", validationIsRunning);
            component.set("v.validationIsRunning", validationIsRunning);
            component.set("v.validationIsFailed", validationIsFailed);
            component.set("v.validationMessage", validationMessage);
            //debugger;
            if (validationIsFailed) {
                var forceRecordEditSaveFailed = $A.get("e.c:ACN_ForceRecordEditSaveFailed");
                forceRecordEditSaveFailed.setParams({
                    "recordId": validationContextId, 
                    "sectionId": sectionId
                });
                forceRecordEditSaveFailed.fire();
            }
            else {
                var forceRecordEditSaveCompleted = $A.get("e.c:ACN_ForceRecordEditSaveCompleted");
                forceRecordEditSaveCompleted.setParams({
                    "recordId": validationContextId, 
                    "sectionId": sectionId
                });
                forceRecordEditSaveCompleted.fire();
            }
        }
    },
    handleForceRecordEditSaveRequested: function(component, event, helper) {
        if (component.isValid()) {
            var recordId = component.get("v.recordId");
            var sectionId = component.get("v.sectionId");
            var eventRecordId = event.getParam("recordId");
            var eventsectionId = event.getParam("sectionId");
            var isReadOnly = component.get("v.isReadOnly");
            if (eventRecordId && eventRecordId === recordId && sectionId === sectionId && !isReadOnly) {
                component.set("v.hasSaveException", false);
                component.set("v.isSaving", true);

	            var isLightningComponent = component.get("v.isLightningComponent");
                if (isLightningComponent) {
                    var validationProviderName = component.get("v.validationProviderName");
                    var validationIsRequired = component.get("v.validationIsRequired");
                    if (validationIsRequired && validationProviderName) {
                        component.set("v.validationIsFailed", false);
                        component.set("v.validationIsRunning", true);
                        component.set("v.validationMessage", "");
                        
                        var externalValidationRequestedEvent = $A.get("e.c:ACN_ExternalValidationRequested");
                        externalValidationRequestedEvent.setParams({
                            "validationProviderName": validationProviderName, 
                            "validationContextId": eventRecordId 
                        });
                        externalValidationRequestedEvent.fire();
                        console.log("validation required+++++++++++++++");
                    }
                    else {
                        component.set("v.validationIsFailed", false);
                        component.set("v.validationIsRunning", false);
                        component.set("v.validationMessage", "");
                        component.set("v.isSaving", false);
                        component.set("v.hasSaveException", false);
                        
                        var forceRecordEditSaveCompleted = $A.get("e.c:ACN_ForceRecordEditSaveCompleted");
                        forceRecordEditSaveCompleted.setParams({
                            "recordId": eventRecordId, 
                            "sectionId": sectionId
                        });
                        forceRecordEditSaveCompleted.fire();
                        console.log("not validation _------------------");
                    }
                }
                else {
                    var findResults = component.find('acn-force-record-edit');
                    //note: sometimes the component.find returns an array of objects, sometimes just one object
                    if (findResults.length) {
                        var pageLayouts = findResults;
                        for (var pageLayoutsIndex = 0; pageLayoutsIndex < pageLayouts.length; pageLayoutsIndex++) {
                            var pageLayout = pageLayouts[pageLayoutsIndex];
                            if (pageLayout) {
                                var pageLayoutRecordId = pageLayout.get("v.recordId");
                                if (eventRecordId === pageLayoutRecordId) {
                                    pageLayout.get("e.recordSave").fire();
                                }
                            }
                        }
                    }
                    else {
                        var pageLayout = findResults;
                        var pageLayoutRecordId = pageLayout.get("v.recordId");
                        if (eventRecordId === pageLayoutRecordId) {
                            pageLayout.get("e.recordSave").fire();
                        }
                    }
                    helper.monitorSaveException(component, event, helper);
                }
            }
        }
    }, 
    handleSaveSuccess: function(component, event, helper) {
        if (component.isValid()) {
            var recordId = component.get("v.recordId");
            var sectionId = component.get("v.sectionId");
            var eventRecordId = event.getSource().get("v.recordId");
            var isSaving = component.get("v.isSaving");
            if (isSaving && eventRecordId === recordId) {
                helper.stopSaveExceptionMonitor(component, event, helper);
                
                var validationIsRequired = component.get("v.validationIsRequired");
                var validationProviderName = component.get("v.validationProviderName");
                if (validationIsRequired && validationProviderName) {
                    component.set("v.validationIsFailed", false);
                    component.set("v.validationIsRunning", true);
                    component.set("v.validationMessage", "");
                    
                    var externalValidationRequestedEvent = $A.get("e.c:ACN_ExternalValidationRequested");
                    externalValidationRequestedEvent.setParams({
                        "validationProviderName": validationProviderName, 
                        "validationContextId": recordId 
                    });
                    externalValidationRequestedEvent.fire();
                }
                else {
                    component.set("v.isSaving", false);
                    component.set("v.hasSaveException", false);
                    
                    //var recordIds = [];
                    //component.set("v.recordIds", recordIds)
                    //component.set("v.hasSaveException", false);
                    //recordIds.push(recordId);
                    //component.set("v.recordIds", recordIds)
                    
                    var forceRecordEditSaveCompleted = $A.get("e.c:ACN_ForceRecordEditSaveCompleted");
                    forceRecordEditSaveCompleted.setParams({
                        "recordId": recordId, 
                        "sectionId": sectionId
                    });
                    forceRecordEditSaveCompleted.fire();
                }
            }
        }
    }, 
    saveNowChangedHandler: function(component, event, helper) {
        var saveNow = component.get("v.saveNow");
        if (saveNow) {
            component.set("v.saveNow", false);
            var recordId = component.get("v.recordId");
            var forceRecordEditSaveRequested = $A.get("e.c:ACN_ForceRecordEditSaveRequested");
            forceRecordEditSaveRequested.setParams({
                "recordId": recordId 
            });
            forceRecordEditSaveRequested.fire();
        }
    }, 
    printRecord: function(component, event, helper) {
        var htmlToPrint = "";
        var printRegion = component.find("acn_print_region");
        if (printRegion) {
            htmlToPrint = printRegion.getElement().innerHTML;
        }
        debugger;
        console.log(htmlToPrint);
    }, 
    recordUpdated: function(component, event, helper) {
        var changeType = event.getParams().changeType;
        
        if (changeType === "ERROR") { /* handle error; do this first! */ }
        else if (changeType === "LOADED") { /* handle record load */ }
            else if (changeType === "REMOVED") { /* handle record removal */ }
                else if (changeType === "CHANGED") { 
                    /* handle record change; reloadRecord will cause you to lose your current record, including any changes you’ve made */ 
                    component.find("forceRecord").reloadRecord();
                    var targetRecord = component.get("v.targetRecord");
                    console.log("Update detected\n" + JSON.stringify(targetRecord));
                }
    }, 
    handleReloadSectionsRequested: function(component, event, helper) {
        debugger;
        var targetFields = component.get("v.targetFields");
        var sections = event.getParam("sections");
        var isReloadTarget = false;
        for (var sectionIndex in sections) {
            var section = sections[sectionIndex];
            var eventSectionOrder = section.SectionOrder;
            var eventOrder = section.Order;
            var currentSectionOrder = '' + targetFields.SectionOrder__c;
            var currentOrder = '' + targetFields.Order__c;

            //console.log(eventSectionOrder + "===" + currentSectionOrder + "\n");
            //console.log(eventOrder + "===" + currentOrder + "\n");

            if (eventSectionOrder === currentSectionOrder && eventOrder === currentOrder) {
                //console.log("Refresh me");
                var recordIds = component.get("v.recordIds");
                var recordId = component.get("v.recordId")
                recordIds = [];
                component.set("v.recordIds", recordIds);
				recordIds.push(recordId);
                component.set("v.recordIds", recordIds);
            }
        }
    }
})