({
	myAction : function(component, event, helper) {
		
	}, 
    selectMenu: function(component, event, helper) {
        var contextParentIdentifier = component.get('v.contextParentIdentifier');
        if (contextParentIdentifier) {
            var navigationMenuChangedEvent = $A.get("e.c:ACN_NavigationMenuChanged");
            if (navigationMenuChangedEvent) {
                navigationMenuChangedEvent.setParams({
                    navigationItem: {Id: contextParentIdentifier}
                });
                navigationMenuChangedEvent.fire();
            }
        }
    }
})