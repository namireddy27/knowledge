({
    doInit : function(component, event, helper) {
        var itemGroup = component.get("v.filterItemGroup");
        var options = [];
        itemGroup.option.forEach(function(option) {
            var opt = {};
            opt.label = option.Name; 
            opt.value = option.FilterIdentifier;
            options.push(opt);
        });
        component.set("v.filterOptions",options);
        console.log("Options");
        console.log(options);
    }, 
    handleNavigationFilterSelected: function(component, event, helper) {
        //debugger;
        var changeValue = event.getParam("value");
        console.log("Pressed:" + changeValue);
        //get the navigationFilterItem
        var filterListItem;
        var itemGroup = component.get("v.filterItemGroup");
        changeValue.forEach(function(val) {
            console.log("val:" + val)
            itemGroup.option.forEach(function(opt) {
                console.log(opt);
                if (opt.FilterIdentifier == val) {
                    // found the filter option
                    filterListItem = opt;
                    filterListItem.IsSelected = true;
                    console.log("option found!");
                    //break;
                }
            });
        });
        if (filterListItem) {
            var onNavigationFilterSelected = component.getEvent("navigationFilterItemPressed");
            onNavigationFilterSelected.setParams({ 
                "filterListItem": filterListItem
            });
            onNavigationFilterSelected.fire();
        }
    },
    handleNavigationFilterClearAllRequested: function(component, event, helper) {
        var clearAllFilterContextIdentifier = event.getParam("filterContextIdentifier");
        var  filterContextIdentifier = component.get("v.filterContextIdentifier");
        if (clearAllFilterContextIdentifier && filterContextIdentifier == clearAllFilterContextIdentifier) {
	        var filterValues = [];
            component.set("v.value", filterValues);
        }
    }
})