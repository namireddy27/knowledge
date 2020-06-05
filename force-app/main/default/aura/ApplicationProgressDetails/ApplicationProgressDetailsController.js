({
    
    scriptsLoaded : function(component, event, helper) {
      	if(  component.get('v.loaded'))
        {
             helper.scriptsLoaded(component, event, helper);
        }
        component.set('v.loaded', true);
       
    },
    
})