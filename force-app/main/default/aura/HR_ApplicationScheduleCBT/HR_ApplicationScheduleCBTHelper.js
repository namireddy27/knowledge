({
	updateSSOFieldHelper : function(component, event, helper) {
		    

        var applicationID	= component.get("v.recordId");
        var action = component.get("c.updateTogetSSOLink");
        action.setParams({
            "applicationId" : applicationID
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                 console.log('Update SSO Link !');   
            }
            else{
                alert('ERROR');
            }
         
        });
        $A.enqueueAction(action);
	},
    
    
    getnewSSOlink : function(component, event, helper) {
         var applicationID	= component.get("v.recordId");
        var action = component.get("c.getnewSSOLink");
        action.setParams({
            "applicationId" : applicationID
        });
        
               
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){                
                console.log('New SSO Link!');
              //  alert(" SSO link :" +response.getReturnValue());
                
                var  urllink =response.getReturnValue();
                console.log('New SSO Link! :'+urllink );
                                
              //  window.open("https://www.w3schools.com");
                
                   this.navigateToURL(component,urllink);
                
                  component.set("v.showConfirtmation",false);               
                 
                // this.navigateToURL(component,urllink);
                
                
                
            }
            else{
                alert('ERROR');
            }
        });
                
        $A.enqueueAction(action); 
     },
    
   
    navigateToURL :function(component,urllink){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urllink
        });
        urlEvent.fire();
    }
    
})