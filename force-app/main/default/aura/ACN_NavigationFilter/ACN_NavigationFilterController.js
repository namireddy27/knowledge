({
    doInit : function(component, event, helper) {
        var selectName = "";
        var selectLabel = "";
        var selectIsRequired = false;
        var isSelectPresent = false;
        var filterGroupNamesCsv = component.get("v.filterGroupNamesCsv");
        var filterAlignment = component.get("v.filterAlignment");
        var groupStyle;
        if (filterAlignment === "vertical") {
            groupStyle = "acn-navigation-filtergroup-vertical";
        }
        else {
            groupStyle = "acn-navigation-filtergroup";
        }
        
        var filterGroupNames = [];
        if (filterGroupNamesCsv) {
            var filterGroupNamesCsvArray = filterGroupNamesCsv.split(',');
            for ( var filterGroupNamesCsvIndex = 0; filterGroupNamesCsvIndex < filterGroupNamesCsvArray.length; filterGroupNamesCsvIndex++ ) {
                var filterGroupName = filterGroupNamesCsvArray[filterGroupNamesCsvIndex].trim();
                if (filterGroupName) {
                    filterGroupNames.push(filterGroupName);
                }
            }
        }
        component.set("v.filterGroupNames", filterGroupNames);
        
        var dataProviderName = component.get("v.dataProviderName");
        var filterListItems = [];
        var filterItem = {};
        
        component.set("v.filterListItems", filterListItems);
        component.set("v.selectName", selectName);
        component.set("v.selectLabel", selectLabel);
        component.set("v.selectIsRequired", selectIsRequired);
        component.set("v.isSelectPresent", isSelectPresent);
        component.set("v.groupStyle", groupStyle);
},
    handleNavigationFilterSelected: function(component, event, helper) {
        var filterGroupNames = component.get("v.filterGroupNames");
        if (filterGroupNames.length <= 0 ) {
            return;
        }
        
        var filterListItems = component.get("v.filterListItems");
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        var filterListItem = {};
        var selectedValue = component.find("filterSelect").get("v.value");
        if (selectedValue) {
            for (var filterListItemIndex = 0; filterListItemIndex < filterListItems.length; filterListItemIndex++) {
                if (filterListItems[filterListItemIndex].Id == selectedValue) {
                    filterListItem = filterListItems[filterListItemIndex];
                    break;
                }
            }
        }
        filterListItem.IsSelected = true;
        
        //        if (filterListItem && filterListItem.GroupName && filterListItem.Name && filterGroupNames.includes(filterListItem.GroupName)) {
        if (filterListItem && filterListItem.GroupName && filterListItem.Name && filterGroupNames.indexOf(filterListItem.GroupName)) {
            var onNavigationFilterSelected = $A.get("e.c:ACN_NavigationFilterSelected");
            onNavigationFilterSelected.setParams({ 
                "filterListItem": filterListItem, 
                "filterContextIdentifier": filterContextIdentifier
            });
            onNavigationFilterSelected.fire();
        }
    }, 
    handleNavigationFilterItemPressed: function(component, event, helper) {
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        var filterListItem = event.getParam("filterListItem");
        var filterListItems = component.get("v.filterListItems");
        
        var onNavigationFilterSelected = $A.get("e.c:ACN_NavigationFilterSelected");
        onNavigationFilterSelected.setParams({ 
            "filterListItem": filterListItem, 
            "filterContextIdentifier": filterContextIdentifier
        });
        onNavigationFilterSelected.fire();
        
        for ( var filterListItemIndex = 0; filterListItemIndex < filterListItems.length; filterListItemIndex++ ) {
            if (filterListItem.IsClearAll) {
                if (filterListItems[filterListItemIndex].GroupName.toLowerCase() == filterListItem.GroupName.toLowerCase() ) {
                    filterListItems[filterListItemIndex].IsSelected = false;
                }
            }
            else {
                if (filterListItems[filterListItemIndex].Id == filterListItem.Id) {
                    filterListItems[filterListItemIndex].IsSelected = filterListItem.IsSelected;
                }
            }
        }
        component.set("v.filterListItems", filterListItems);
    },
    handleNavigationFilterValuesChanged: function(component, event, helper) {
        //component.set("v.isLoading", true);
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        var eventFilterContextIdentifier = event.getParam("filterContextIdentifier");
        
        if (!eventFilterContextIdentifier || !filterContextIdentifier || filterContextIdentifier != eventFilterContextIdentifier) {
            return;
        }
        
        var filterGroupNames = component.get("v.filterGroupNames");
        if (filterGroupNames.length <= 0 ) {
            return;
        }
        
        var filterItems = event.getParam("filterItems");
        var preSelectedFilters = [];
        
        var filterListItems = [];
        var filterItemGroup = [];
        var isSelectPresent = component.get("v.isSelectPresent");
        var selectName = component.get("v.selectName");
        var selectLabel = component.get("v.selectLabel");
        var selectIsRequired = component.get("v.selectIsRequired");
        
        for (var filterItemIndex = 0; filterItemIndex < filterItems.length; filterItemIndex++) {
            var filterItem = filterItems[filterItemIndex];
            if (filterItem.IsSelected) {
                preSelectedFilters.push(filterItem);
            }
            if (filterItem && filterItem.GroupName && filterItem.Name && filterGroupNames.indexOf(filterItem.GroupName)>-1) {
                filterListItems.push(filterItem);
                if (filterItem.Type == "Select") {
                    isSelectPresent = true;
                    selectName = filterItem.GroupName;
                    selectLabel = filterItem.GroupName;
                    //selectIsRequired = false;
                }

                var groupExists = false;
                filterItemGroup.forEach(function(group) {
                    if (filterItem.GroupName === group.groupLabel) { // group found
                        group.option.push(filterItem);
                        groupExists = true;
                    }
                });
                if (!groupExists) {
                    var newGroup = {};
                    newGroup.groupName = filterItem.AttributeName;
                    newGroup.groupType = filterItem.Type;
                    newGroup.groupLabel = filterItem.GroupName;
                    newGroup.option = [];
                    newGroup.option.push(filterItem);
                    filterItemGroup.push(newGroup);
                }
            }
        }
        component.set("v.filterListItems", filterListItems);
        component.set("v.filterItemGroup", filterItemGroup);
        component.set("v.selectName", selectName);
        component.set("v.selectLabel", selectLabel);
        component.set("v.selectIsRequired", selectIsRequired);
        component.set("v.isSelectPresent", isSelectPresent);
        
        if (preSelectedFilters && preSelectedFilters.length > 0) {
            var navigationFilterItemPreSelectedEvent = $A.get("e.c:ACN_NavigationFilterItemPreSelected");
            navigationFilterItemPreSelectedEvent.setParams({
                "filterList": preSelectedFilters,
                "filterContextIdentifier": filterContextIdentifier
            });
            navigationFilterItemPreSelectedEvent.fire();
        }
    }, 
    handleNavigationFilterSelected: function(component, event, helper) {
        var filterListItemId = event.getSource().get("v.value");

        var filterListItems = component.get("v.filterListItems");
        var filterListItem = {};
        for (var filterListItemsIndex in filterListItems) {
            if (filterListItems[filterListItemsIndex].Id == filterListItemId) {
                filterListItem = filterListItems[filterListItemsIndex];
                break;
            }
        }
        debugger;
        if (filterListItem && filterListItem.Type) {
            var fireEvent = false;
            switch(filterListItem.Type.toLowerCase()) {
                case "select":
                    fireEvent = true;
                    filterListItem.IsSelected = true;
                    component.set("v.filterListItems", filterListItems);
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
    }
})