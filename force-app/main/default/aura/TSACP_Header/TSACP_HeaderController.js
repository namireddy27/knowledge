({
	handleMobileMenu : function(component, event, helper) {
		component.set("v.showConfirtmation",true);
	},
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
    },
})