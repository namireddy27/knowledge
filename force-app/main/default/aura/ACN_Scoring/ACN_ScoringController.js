({
    doInit : function(component, event, helper) {
        var averageFiveStarsRating = component.get("v.averageFiveStarsRating");
		var averageFiveStarsRatingNumber = parseFloat(averageFiveStarsRating);
		component.set("v.averageFiveStarsRatingNumber", averageFiveStarsRatingNumber);
        
        var inactiveIconColor = component.get("v.inactiveIconColor");
        var activeIconColor = component.get("v.activeIconColor");
        var starsColors = [];
        for (var i = 0; i < 5; i++) {
            if (i+1 > parseInt(averageFiveStarsRatingNumber)){
                starsColors.push(inactiveIconColor);
            }
            else {
                starsColors.push(activeIconColor);
            }
        }
        component.set("v.starsColors", starsColors);
        
        /*
        helper.initializeIconsArray(component, event, helper, {});

		var isLovedIconName = component.get("v.isLovedIconName");
        var isLovedIconValue = component.get("v.isLovedIconValue");
        if (!isLovedIconValue) {
			isLovedIconValue = helper.getIconForName(component, event, helper, {'IconName': isLovedIconName});
            component.set("v.isLovedIconValue", isLovedIconValue);
        }
        console.log('Icon Value: ' + isLovedIconValue);
        
        var isLikedIconName = component.get("v.isLikedIconName");
        var isLikedIconValue = component.get("v.isLikedIconValue");
        var isNotLikedIconName = component.get("v.isNotLikedIconName");
        var isNotLikedIconValue = component.get("v.isNotLikedIconValue");
        */
	}
})