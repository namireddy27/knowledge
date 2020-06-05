({
    doInit : function(component, event, helper) {
        helper.getApplcationHelper(component, event, helper);
        helper.getPickListValues(component, event, helper);
        helper.checkApplicationStatus(component, event, helper);
    },
    ononstepblurO : function(component,event,helper) {
        event.preventDefault();
    },
    handlestepblur: function(component,event,helper)
    {
        var steps = component.get('v.steps');
        
    	var stepIndex = event.getParam('index');
        steps[stepIndex].showHover = false;
          component.set('v.steps',steps);
      
	},
    handlestepfocus: function(component,event,helper)
    {
          var steps = component.get('v.steps');
    	var stepIndex = event.getParam('index');
        steps[stepIndex].showHover = true;
        component.set('v.steps',steps);
     
	}
})