({
    doInit: function (component, event, helper) {
        var itemGroup = component.get("v.filterItemGroup");
        var options = [];
        itemGroup.option.forEach(function (option) { 
            var opt = {};
            opt.label = option.Name;
            opt.value = option.FilterIdentifier;
            opt.selected = option.IsSelected;
            options.push(opt);
        });
        component.set("v.filterOptions", options);
    },
    handleNavigationFilterSelected: function (component, event, helper) {
        //debugger;
        var itemValue = event.getParam("value");;
        console.log("Pressed:" + itemValue);
        //get the navigationFilterItem
        var filterListItem;
        var itemGroup = component.get("v.filterItemGroup");
        itemGroup.option.forEach(function (opt) {
            console.log(opt);
            if (opt.FilterIdentifier == itemValue) {
                // found the filter option
                filterListItem = opt;
                filterListItem.IsSelected = true;
                //filterListItem.IsSelected = !itemValueSelected;
                //opt.IsSelected = !itemValueSelected;
                console.log("option found!", opt);
            }
        });
/*        var optionGroup = component.get("v.filterOptions");
        optionGroup.forEach(function (opt) {
            //console.log('MultiSelect Option: ', opt);
            console.log(itemValue);
            if (opt.value == itemValue) {
                // found the filter option
                opt.selected = !itemValueSelected;
            }
        });  */
        //component.set("v.filterOptions", optionGroup);
        if (filterListItem) {
            console.log('filterListItem:', filterListItem);
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
        if (clearAllFilterContextIdentifier && filterContextIdentifier == clearAllFilterContextIdentifier) {
            var itemGroup = component.get("v.filterItemGroup");
            itemGroup.option.forEach(function (opt) {
                opt.IsSelected = false;
            });
            var optionGroup = component.get("v.filterOptions");
            optionGroup.forEach(function (opt) {
                opt.selected = false;
            });
            component.set("v.filterOptions", optionGroup);
            component.set("v.filterItemGroup", itemGroup);
        }
    }
})