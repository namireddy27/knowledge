({
    clearAllFilters: function(component, event, helper) {
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        var onNavigationFilterClearAllRequested = $A.get("e.c:ACN_NavigationFilterClearAllRequested");
        onNavigationFilterClearAllRequested.setParams({ 
            "filterContextIdentifier": filterContextIdentifier
        });
        onNavigationFilterClearAllRequested.fire();
        component.set("v.filterListItems", []);
        helper.filterChanged(component, event, helper);
    }, 
    handleNavigationFilterSelected: function(component, event, helper) {
        var configurationObject = {};
        configurationObject.isFilterPreSelected = false;
        helper.navigationFilterSelected(component, event, helper, configurationObject);
    },
    handleNavigationFilterPreSelected: function(component, event, helper) {
        var configurationObject = {};
        configurationObject.isFilterPreSelected = true;
        helper.navigationFilterPreSelected(component, event, helper, configurationObject);
    }
})