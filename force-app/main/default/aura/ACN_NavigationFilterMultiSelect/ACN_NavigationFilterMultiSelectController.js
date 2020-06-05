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
        //console.log("MultiSelect Options");
        //console.log(options);
    },
    handleNavigationFilterSelected: function (component, event, helper) {
        //debugger;
        var item = event.currentTarget;
        //changeValue = event.getParam("value");
        console.log("Pressed:" + item.dataset.value);
        var itemValue = item.dataset.value;
        var itemValueSelected = (item.dataset.selected == 'true');
        console.log("Selected: ", itemValueSelected);
        console.log("Toogle Selected: ", !(itemValueSelected));
        //get the navigationFilterItem
        var filterListItem;
        var itemGroup = component.get("v.filterItemGroup");
        itemGroup.option.forEach(function (opt) {
            //console.log(opt);
            if (opt.FilterIdentifier == itemValue) {
                // found the filter option
                filterListItem = opt;
                filterListItem.IsSelected = !itemValueSelected;
                opt.IsSelected = !itemValueSelected;
                console.log("option found!", opt);
            }
        });
        var optionGroup = component.get("v.filterOptions");
        optionGroup.forEach(function (opt) {
            //console.log('MultiSelect Option: ', opt);
            console.log(itemValue);
            if (opt.value == itemValue) {
                // found the filter option
                opt.selected = !itemValueSelected;
                console.log("MultiSelect option found!");
            }
        });
        console.log("Selected Options:");
        console.log(optionGroup);
        component.set("v.filterOptions", optionGroup);
        if (filterListItem) {
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
    },
    onfocus: function (component, event, helper) {
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        
        $A.util.toggleClass(forOpen, 'slds-hide');

    },
    searchOptions: function (component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.searchKeyword");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if (getInputkeyWord.length >= 0) {
            var forOpen = component.find("searchRes");
            $A.util.removeClass(forOpen, 'slds-hide');
            $A.util.addClass(forOpen, 'slds-show');
            helper.searchHelper(component, event, getInputkeyWord);
        }
        else {
            component.set("v.listOfSearchRecords", null);
            var forclose = component.find("searchRes");
            $A.util.removeClass(forclose, 'slds-show');
            $A.util.addClass(forclose, 'slds-hide');
        }
    },
    handleMouseLeave: function (component, event, helper) {
        //component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var mainDiv = component.find('searchRes');
        //$A.util.removeClass(mainDiv, 'slds-show');
        $A.util.addClass(mainDiv, 'slds-hide');
    }
})