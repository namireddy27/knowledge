({
    doInit : function(component, event, helper) {
        /*
        var cmpTarget = component.find('acn-preview-container');
        if (cmpTarget) {
            $A.util.addClass(cmpTarget, "acn-preview-content");
        }
        */
        
        /*
        var noContentsMessage = component.get("noContentsMessage");
        if (!noContentsMessage) {
            noContentsMessage = $A.get("$Label.c.ACN_NavigationContentPreviewEmptyMessage");
            component.set("v.rootNavigationPathLabel", navigationPathSegment.Name)
        }
        */
        
		helper.validatePreviewContent(component, event, helper);
    },
    handleNavigationItemContentPreviewPressed: function(component, event, helper) {
        component.set('v.hasPreviewContent', false);
        component.set('v.showContentsPreviewUnavailableMessage', false);
        var navigationItem = event.getParams("navigationItem").navigationItem;
        var eventContentPreviewIdentifier = event.getParams("contentPreviewIdentifier").contentPreviewIdentifier;
        var contentPreviewIdentifier = component.get("v.contentPreviewIdentifier");
        if (contentPreviewIdentifier && eventContentPreviewIdentifier && contentPreviewIdentifier == eventContentPreviewIdentifier) {
            component.set('v.navigationItem', navigationItem);
        }
		helper.validatePreviewContent(component, event, helper);
    }
})