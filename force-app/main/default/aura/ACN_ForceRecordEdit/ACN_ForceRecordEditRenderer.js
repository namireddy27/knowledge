({
    afterRender: function (component, event, helper) {
        var superAfterRender = this.superAfterRender();
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
        return superAfterRender;        
    }
})