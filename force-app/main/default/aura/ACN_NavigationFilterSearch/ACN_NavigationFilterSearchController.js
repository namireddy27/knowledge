({
    handleKeyUp: function (component, event, helper) {
        var isEnterKey = event.keyCode === 13; 
        if (isEnterKey) {
            var queryTerm = component.find('searchFilter').get('v.value');
            var itemGroup = component.get("v.filterItemGroup");
            var filterListItem = itemGroup.option[0];
            filterListItem.IsSelected = (queryTerm !== '');
            filterListItem.AttributeValue = queryTerm;
            filterListItem.Name = queryTerm;
            if (filterListItem) {
                console.log('filterListItem:', filterListItem);
                var onNavigationFilterSelected = component.getEvent("navigationFilterItemPressed");
                onNavigationFilterSelected.setParams({
                    "filterListItem": filterListItem
                });
                onNavigationFilterSelected.fire();
            }
        }
    },
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
    handleNavigationFilterClearAllRequested: function (component, event, helper) {
        var clearAllFilterContextIdentifier = event.getParam("filterContextIdentifier");
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        if (clearAllFilterContextIdentifier && filterContextIdentifier == clearAllFilterContextIdentifier) {
            var itemGroup = component.get("v.filterItemGroup");
            itemGroup.option.forEach(function (opt) {
                opt.IsSelected = false;
                opt.AttributeValue = "";
            });
            component.set("v.filterItemGroup", itemGroup);
            component.set("v.searchValue", "");
        }
    }
});