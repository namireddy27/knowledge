({
	doInit : function(component, event, helper) {
        var navigationPathException = component.get("v.navigationPathException");
        navigationPathException = {};
		navigationPathException.HasError = false;
		navigationPathException.Error = "";
        component.set("v.navigationPathException", navigationPathException);
    }, 
    onClickEventHandler : function(component, event, helper) {
		var navigationPathSegmentPressedEvent = component.getEvent("navigationPathSegmentPressed");
        var navigationPathSegmentPressed = component.get("v.navigationPathSegment");

        navigationPathSegmentPressedEvent.setParams({
    		navigationPathSegment: navigationPathSegmentPressed
		}).fire();
        
        var contentPreviewIdentifier = component.get("v.contentPreviewIdentifier");
        if (contentPreviewIdentifier) {
            var navigationItemContentPreviewPressedEvent = $A.get("e.c:ACN_NavigationItemContentPreviewPressed");
            if (navigationItemContentPreviewPressedEvent) {
                navigationItemContentPreviewPressedEvent.setParams({
                    navigationItem: {},
                    contentPreviewIdentifier: contentPreviewIdentifier
                });
                navigationItemContentPreviewPressedEvent.fire();
            }
        }
    }
})