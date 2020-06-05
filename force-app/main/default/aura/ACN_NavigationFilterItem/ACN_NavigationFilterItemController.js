({
	doInit : function(component, event, helper) {
        
	}, 
    handleNavigationFilterClearAllRequested: function(component, event, helper) {
        var clearAllFilterContextIdentifier = event.getParam("filterContextIdentifier");
        var  filterContextIdentifier = component.get("v.filterContextIdentifier");
        if (clearAllFilterContextIdentifier && filterContextIdentifier == clearAllFilterContextIdentifier) {
	        var filterListItem = component.get("v.filterListItem");
            filterListItem.IsSelected = false;
            component.set("v.filterListItem", filterListItem);
        }
    },
    handleNavigationFilterSelected: function(component, event, helper) {
        var filterListItem = component.get("v.filterListItem");
        var fireEvent = false;
        var checked = false;
        
        switch(filterListItem.Type.toLowerCase()) {
            case "checkbox":
		        fireEvent = true;
                checked = component.find("filterSelection").get("v.checked");
                filterListItem.IsSelected = checked;
                component.set("v.filterListItem", filterListItem);
                break;
        }

        if (fireEvent) {
            var onNavigationFilterSelected = component.getEvent("navigationFilterItemPressed");
            onNavigationFilterSelected.setParams({ 
                "filterListItem": filterListItem
            });
            onNavigationFilterSelected.fire();
        }
    }
})