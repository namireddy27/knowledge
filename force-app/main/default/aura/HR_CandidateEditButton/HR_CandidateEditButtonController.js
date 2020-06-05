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
//            console.log('@@@'+result.Id);
            //component.set("v.contact",result);
            component.set("v.AccountId",result);
            //alert(result);
        });
        action1.setParams({
            Userid : component.get("v.recordId"),
        });  // 1st Change
        action1.setCallback(this, function(response){
            var result1 =response.getReturnValue();
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