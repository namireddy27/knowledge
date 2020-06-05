({
    doInit : function(component, event, helper) {
        var navigationPathException = component.get("v.navigationPathException");
        navigationPathException = {};
		navigationPathException.HasError = false;
		navigationPathException.Error = "";
        component.set("v.navigationPathException", navigationPathException);
		
        window.setTimeout($A.getCallback(function() {
            if(component.isValid()) {
		        helper.updatePathRootNode(component, event, helper);
                var StyleClass = component.get("v.StyleClass");
                if (!StyleClass) {
                    component.get("v.navigationPathSegmentChevron");
                }
            }
        }), 500);
    }, 
    handlePathChanged: function(component, event, helper) {
        var navigationPathSegments = component.get("v.navigationPathSegments");
        var navigationItem = event.getParam("navigationItem");
        var navigationPathSegment = {};
        navigationPathSegment.Name = navigationItem.Name;
        navigationPathSegment.Id = navigationItem.Id;
        navigationPathSegment.Level = navigationItem.Level;
        navigationPathSegment.ImageUrl = navigationItem.SmallImageUrl;
		navigationPathSegments.push(navigationPathSegment);
        
        component.set("v.navigationPathSegments", navigationPathSegments);
        component.set("v.selectedNavigationItem", navigationItem.navigationItem);
    },
    handleNavigationPathSegmentPressed: function(component, event, helper) {
        var pressedNavigationPathSegment = event.getParam("navigationPathSegment");
        var navigationPathSegments = component.get("v.navigationPathSegments");
        var newNavigationPathSegments = [];
        for (var navigationPathSegmentIndex = 0; navigationPathSegmentIndex < navigationPathSegments.length; navigationPathSegmentIndex++) {
            newNavigationPathSegments.push(navigationPathSegments[navigationPathSegmentIndex]);
            if (navigationPathSegments[navigationPathSegmentIndex].Id == pressedNavigationPathSegment.Id) {
				break;
            }
        }
        component.set("v.selectedPathSegment", pressedNavigationPathSegment);
        component.set("v.navigationPathSegments", newNavigationPathSegments);
    },
	updatePathRootNode: function(component, event, helper) {
        helper.updatePathRootNode(component, event, helper);
    }
})