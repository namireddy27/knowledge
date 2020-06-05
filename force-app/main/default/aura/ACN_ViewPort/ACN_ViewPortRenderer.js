({
    afterRender: function (component, helper) {
        this.superAfterRender();
        helper.loadViewport(component, helper);
    }
})