({
	clickCBTLink : function(component, event, helper) {	
        

       
  	    helper.updateSSOFieldHelper (component, event, helper);
    	component.set("v.showConfirmation",true);
        helper.getExternalSysStatus(component, event, helper);    
          
        /*clearInterval(component.get('v.timerobj'));
       	clearTimeout(component.get('v.timerobj1'));
      	component.set("v.timer",0); 
		component.set("v.countdowntimer",component.get('v.timeout')); */
        
       
      /* window.setTimeout(helper.getExternalSystemStatus(component, event, helper),10000);
         window.setTimeout(
            $A.getCallback(function() {
             component.set("v.isinvited",false);    
             component.set("v.externalSystemSuccess",true); 
             component.set("v.isButtonActive",true);   
                
            }), 20000
           );*/                 
        
    },
    closeModel : function(component, event, helper){
        component.set("v.showConfirmation",false);
    },
    scheduleCBT : function(component, event, helper){          
     	helper.getnewSSOlink(component, event, helper);
        component.set("v.showConfirmation",false);  
    },
           
})