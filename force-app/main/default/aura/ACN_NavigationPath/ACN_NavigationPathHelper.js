({
	updatePathRootNode: function(component, event, helper) {
        var navigationPathSegments = [];
        var navigationPathSegment = {};
        navigationPathSegment.Name = component.get("v.rootNavigationPathLabel");
        var rootNavigationPathLabelDefaultValue = component.get("v.rootNavigationPathLabelDefaultValue");

        if (!navigationPathSegment.Name && rootNavigationPathLabelDefaultValue) {
            component.set("v.rootNavigationPathLabel", rootNavigationPathLabelDefaultValue);
            navigationPathSegment.Name = rootNavigationPathLabelDefaultValue;
        }
        navigationPathSegment.Id = "";
		var contextParentIdentifier = component.get("v.contextParentIdentifier");
        if (contextParentIdentifier) {
            navigationPathSegment.Id = contextParentIdentifier;
        }        
        navigationPathSegment.Level = 0;
        navigationPathSegment.ImageUrl = "";
		navigationPathSegments.push(navigationPathSegment);
		component.set("v.navigationPathSegments", navigationPathSegments);
	}
})