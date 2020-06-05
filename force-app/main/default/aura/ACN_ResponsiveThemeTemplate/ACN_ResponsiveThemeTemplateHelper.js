({
	populateSizeArrays: function(component, event, helper) {
        var firstElementWidthString = component.get("v.firstElementWidthString");
        component.set("v.firstElementWidth", helper.getIntegersArray(firstElementWidthString));
        var secondElementWidthString = component.get("v.secondElementWidthString");
        component.set("v.secondElementWidth", helper.getIntegersArray(secondElementWidthString));
        var thirdElementWidthString = component.get("v.thirdElementWidthString");
        component.set("v.thirdElementWidth", helper.getIntegersArray(thirdElementWidthString));
        var fourthElementWidthString = component.get("v.fourthElementWidthString");
        component.set("v.fourthElementWidth", helper.getIntegersArray(fourthElementWidthString));
        var fifthElementWidthString = component.get("v.fifthElementWidthString");
        component.set("v.fifthElementWidth", helper.getIntegersArray(fifthElementWidthString));
        var heroBackgroundImageHeight = component.get("v.heroBackgroundImageHeight");
        component.set("v.heroBackgroundImageHeightArray", helper.getStringsArray(heroBackgroundImageHeight));
	},
    getIntegersArray: function(arrayElementsCsv) {
    	var arrayElements = arrayElementsCsv.split(",");
        var integersArray = [];
        for (var arrayIndex in arrayElements) {
            try {
                integersArray.push(parseInt(arrayElements[arrayIndex]));
            } 
            catch(e) {
                
            }
        }
        return integersArray;
	}, 
    getStringsArray: function(arrayElementsCsv) {
    	var arrayElements = arrayElementsCsv.split(",");
        var stringsArray = [];
        var defaultHeight = '';
        var elementsCount = 4;
        var elementIndex = 0;
        for (var arrayIndex in arrayElements) {
            if (!defaultHeight) {
            	defaultHeight = arrayElements[arrayIndex];
            }
            stringsArray.push(arrayElements[arrayIndex]);
            elementIndex++;
        }
        if (elementIndex < elementsCount) {
            while (elementIndex < elementsCount) {
                stringsArray.push(defaultHeight);
                elementIndex++;
            }
        }
        return stringsArray;
	}
})