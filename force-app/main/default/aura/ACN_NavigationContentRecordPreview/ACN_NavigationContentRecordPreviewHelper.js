({
	validatePreviewContent: function(component, event, helper) {
		var navigationItem = component.get('v.navigationItem');
        var hasPreviewContent = false;
        var showContentsPreviewUnavailableMessage = false;
        if (navigationItem && navigationItem.NavigationType && navigationItem.NavigationType == "Preview") {
            if (navigationItem.NavigationTarget) {
	            hasPreviewContent = true;
	            showContentsPreviewUnavailableMessage = false;
            } 
            else {
	            showContentsPreviewUnavailableMessage = true;
            }
        }
        else {
            hasPreviewContent = false;
        }
		
        var configurationObject = {};
        configurationObject.hasPreviewContent = hasPreviewContent;
        configurationObject.showContentsPreviewUnavailableMessage = showContentsPreviewUnavailableMessage;

        window.setTimeout($A.getCallback(function() {
            if(component.isValid()) {
		        component.set('v.hasPreviewContent', configurationObject.hasPreviewContent);
		        component.set('v.showContentsPreviewUnavailableMessage', configurationObject.showContentsPreviewUnavailableMessage);
            }
        }), 500);        
    }
})