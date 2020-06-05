({
    // Update Text
    doInit: function (component, event, helper) { 
        var itemGroup = component.get("v.filterItemGroup");
        var options = [];
        itemGroup.option.forEach(function (option) {
            var opt = {};
            opt.label = option.Name;
            opt.value = option.FilterIdentifier;
            opt.selected = false;
            options.push(opt);
        });
        component.set("v.filterOptions", options);
    },
    handleNavigationFilterSelected: function (component, event, helper) {
        // debugger;
        var itemValue = event.getParam("value");;
        // console.log("Date Selected:" + itemValue);
        // get the navigationFilterItem
        var itemGroup = component.get("v.filterItemGroup");
        var filterListItem = itemGroup.option[0];
        filterListItem.IsSelected = true;
        filterListItem.AttributeValue = itemValue;
        filterListItem.Name = itemValue;
        if (filterListItem) {
            // console.log('filterListItem:', filterListItem);
            var onNavigationFilterSelected = component.getEvent("navigationFilterItemPressed");
            onNavigationFilterSelected.setParams({
                "filterListItem": filterListItem
            });
            onNavigationFilterSelected.fire();
        }
    },

    handleNavigationFilterClearAllRequested: function (component, event, helper) {
        var clearAllFilterContextIdentifier = event.getParam("filterContextIdentifier");
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        if (clearAllFilterContextIdentifier && filterContextIdentifier === clearAllFilterContextIdentifier) {
            var itemGroup = component.get("v.filterItemGroup");
            if (itemGroup) {
                itemGroup.option[0].IsSelected = false;
                itemGroup.option[0].AttributeValue = null;
            }
            component.set("v.filterItemGroup", itemGroup);
            component.set("v.dateValue", "");
        }
    }
})