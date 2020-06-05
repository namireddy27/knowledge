({
    doinit : function(component, event, helper) {
        var action = component.get("c.getUserContact");
        var action1 = component.get("c.getCurrentUser");
         component.set("v.isModalOpen",false);
        action.setParams({
            Userid : component.get("v.recordId"),
        });
        action.setCallback(this, function(response){
            var result =response.getReturnValue();
		// console.log('@@@'+result.Id);  
            //component.set("v.account",result);
            component.set("v.AccountId",result);
//            alert(result);
        });
        action1.setParams({
            Userid : component.get("v.recordId"),
        });  // 1st Change
        action1.setCallback(this, function(response){
            var result1 =response.getReturnValue();
            console.log("result1"+result1);
            // getting string of values and finding the phone and validating, formatting before we club them together.
            component.set("v.currentUser",result1);
        });
        $A.enqueueAction(action);
        $A.enqueueAction(action1);
    },
    handleClick2: function(component, event, helper) {
       // var opptyid = event.getParam("value");
       component.set("v.isModalOpen",true);
        
    },
     closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },

 })

//If your legal name or Social Security number require changes, please fax current Federal or State issued documentation 
//(i.e. Social Security card, Driver's License, Marriage Certificate, etc.) to