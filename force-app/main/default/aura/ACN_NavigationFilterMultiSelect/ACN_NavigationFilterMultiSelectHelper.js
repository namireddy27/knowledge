({
    searchHelper : function(component, event, getInputkeyWord) {
        // call the apex class method 
        console.log('Searching filter options. ', getInputkeyWord);
        var filterItemGroup = component.get("v.filterItemGroup");
        var filteredItems;
        if (filterItemGroup) {
            filteredItems = filterItemGroup.option.filter(function(opt) {
                return opt.Name.toUpperCase().includes(getInputkeyWord.toUpperCase());
            });
        }
        var options = [];
        filteredItems.forEach(function (option) { 
            var opt = {};
            opt.label = option.Name;
            opt.value = option.FilterIdentifier;
            opt.selected = option.IsSelected;
            options.push(opt);
        });
        component.set("v.filterOptions", options);
        console.log("new filtered options: ", options);
    }
    
})