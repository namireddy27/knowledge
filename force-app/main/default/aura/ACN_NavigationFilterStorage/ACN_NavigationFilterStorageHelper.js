({
    filterChanged: function (component, event, helper) {
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        var filterListItems = component.get("v.filterListItems");
        var filterList = [];
        
        for ( var filterListItemIndex = 0; filterListItemIndex < filterListItems.length; filterListItemIndex++ ) {
            filterList.push(filterListItems[filterListItemIndex].AttributeName + ':' + filterListItems[filterListItemIndex].AttributeOperator + ':' + filterListItems[filterListItemIndex].AttributeValue);
        }
        
        var onNavigationFilterChanged = $A.get("e.c:ACN_NavigationFilterChanged");
        onNavigationFilterChanged.setParams({ 
            "filterList": filterList, 
            "filterContextIdentifier": filterContextIdentifier
        });
        onNavigationFilterChanged.fire();
    }, 
    navigationFilterSelected: function(component, event, helper, configurationObject) {
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        var eventFilterContextIdentifier = event.getParam("filterContextIdentifier");
        if (!filterContextIdentifier || !eventFilterContextIdentifier || filterContextIdentifier !== eventFilterContextIdentifier) {
            return;
        }
        var filterListItems = component.get("v.filterListItems");
        var nonSelectItems = [];
        var filterListItem = event.getParam("filterListItem");
        var filterListItemExists = false;
        var itemIndex = -1;
        var selectSpliceIndexArray = [];
        if (filterListItem.Type.toLowerCase() === "select") {
            nonSelectItems = [];
            for ( var filterListItemIndex = 0; filterListItemIndex < filterListItems.length; filterListItemIndex++ ) {
                if (filterListItems[filterListItemIndex].Type.toLowerCase() !== "select" || filterListItems[filterListItemIndex].GroupName.toLowerCase() != filterListItem.GroupName.toLowerCase() ) {
                    nonSelectItems.push(filterListItems[filterListItemIndex]);
                }
            }
            filterListItems = nonSelectItems;
        }
        if (filterListItem.IsClearAll) {
            nonSelectItems = [];
            for ( var filterListItemIndex = 0; filterListItemIndex < filterListItems.length; filterListItemIndex++ ) {
                if (filterListItems[filterListItemIndex].GroupName.toLowerCase() !== filterListItem.GroupName.toLowerCase() ) {
                    nonSelectItems.push(filterListItems[filterListItemIndex]);
                }
            }
            filterListItems = nonSelectItems;
        }
        for ( var filterListItemIndex = 0; filterListItemIndex < filterListItems.length; filterListItemIndex++ ) {
            if (filterListItem.Id === filterListItems[filterListItemIndex].Id) {
                filterListItemExists = true;
                itemIndex = filterListItemIndex;
                break;
            }
        }
        if (!filterListItem.IsSelected && filterListItemExists && itemIndex > -1 && filterListItems.length >= itemIndex) {
            filterListItems.splice(itemIndex, 1);
        }    
        // filterListItem exist and should be replaced
        if (filterListItem.IsSelected && filterListItemExists && itemIndex > -1 && filterListItems.length >= itemIndex) {
            filterListItems.splice(itemIndex, 1, filterListItem);
        }    
        if (filterListItem.IsSelected && !filterListItemExists) {
            if (!filterListItem.IsClearAll) {
                filterListItems.push(filterListItem);
            }
        }        
        component.set("v.filterListItems", filterListItems);
        var isPreSelection = false;
        if (configurationObject && configurationObject.isFilterPreSelected && configurationObject.isFilterPreSelected === true) {
            isPreSelection = true;
        }
        if (!isPreSelection) {
            helper.filterChanged(component, event, helper);
        }
    },
    navigationFilterPreSelected: function(component, event, helper, configurationObject) {
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        var eventFilterContextIdentifier = event.getParam("filterContextIdentifier");
        if (!filterContextIdentifier || !eventFilterContextIdentifier || filterContextIdentifier !== eventFilterContextIdentifier) {
            return;
        }
        var filterListItems = component.get("v.filterListItems");
        var nonSelectItems = [];
        var eventFilterListItems = event.getParam("filterList");
        var filterListItemExists = false;
        
        for (var filterListItemIndex in eventFilterListItems) {
            var filterListItem = eventFilterListItems[filterListItemIndex];
            if (filterListItem.IsSelected) {
                filterListItemExists = false;
                for ( var filterListItemIndex = 0; filterListItemIndex < filterListItems.length; filterListItemIndex++ ) {
                    if (filterListItem.Id === filterListItems[filterListItemIndex].Id) {
                        filterListItems[filterListItemIndex].IsSelected = filterListItem.IsSelected;
                        filterListItemExists = true;
                        break;
                    }
                }
                if (filterListItemExists === false) {
                    filterListItems.push(filterListItem);
                }
            }
        }
        
        component.set("v.filterListItems", filterListItems);
    }
})