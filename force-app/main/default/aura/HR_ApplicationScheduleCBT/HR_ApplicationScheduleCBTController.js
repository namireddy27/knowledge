({
	clickCBTLink : function(component, event, helper) {	
        helper.updateSSOFieldHelper (component, event, helper);
         component.set("v.showConfirtmation",true);
        
         window.setTimeout(
            $A.getCallback(function() {
             component.set("v.isButtonActive",true);                
            }), 20000
           );                 
        
	},
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
    },
    
    scheduleCBT : function(component, event, helper){          
     
      helper.getnewSSOlink(component, event, helper);
      component.set("v.showConfirtmation",false);  
    },
    
    
   
})