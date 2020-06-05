({
	handleMobileMenu : function(component, event, helper) {
		component.set("v.showConfirtmation",true);
	},
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
    },
        logout : function(component, event, helper) {
        //var url= window.location.href;
         // var domain =url.split("/")[0]+'//'+url.split("/")[2];
          // var logouturl= domain+'/servlet/networks/switch?startURL=%2Fsecur%2Flogout.jsp';
          //  window.location.href(logouturl);
       var logoutUrl =$A.get("$Label.c.Logout_url");
       window.location.replace(logoutUrl+"servlet/networks/switch?startURL=%2Fsecur%2Flogout.jsp");
    },
    
    
        doinit : function(component, event, helper) {
        var action = component.get("c.getUserContact");
        action.setParams({
            Userid : component.get("v.currentUser"),
        });
        action.setCallback(this, function(response){
            var result =response.getReturnValue();
//            console.log('@@@'+result.Id);
            component.set("v.contact",result);
           // component.set("v.AccountId",result);
            //alert(result);
        });
      
        $A.enqueueAction(action);
        //$A.enqueueAction(action1);
    },

    
})