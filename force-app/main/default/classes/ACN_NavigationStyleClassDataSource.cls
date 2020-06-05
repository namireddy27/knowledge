global class ACN_NavigationStyleClassDataSource extends VisualEditor.DynamicPickList{
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('navigationCard', 'navigationCard');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows  designPropertyValues = new VisualEditor.DynamicPickListRows();
        Schema.DescribeFieldResult fieldResult = ACN_NavigationItem__c.StyleClassName__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListValue : pickListValues) {
            VisualEditor.DataRow designPropertyValue = new VisualEditor.DataRow(pickListValue.getLabel(), pickListValue.getValue());
            designPropertyValues.addRow(designPropertyValue);
        }
        return designPropertyValues;
    }
}