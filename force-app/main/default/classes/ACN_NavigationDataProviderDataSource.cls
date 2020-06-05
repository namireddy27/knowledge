global class ACN_NavigationDataProviderDataSource extends VisualEditor.DynamicPickList{
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('', '');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows  designPropertyValues = new VisualEditor.DynamicPickListRows();
        List<String> strategyClasses = new List<String>();
        strategyClasses.add('ACN_NavigationProviderService');
        strategyClasses.add('ACN_NavigationProvider');

        ApexClass[] classes = (ApexClass[])[FIND 'ACN_NavigationProviderService' 
                                    IN ALL FIELDS
                                    RETURNING ApexClass(
                                        Id, 
                                        Name 
                                        WHERE Name != :strategyClasses 
                                        ORDER BY Name)][0];
                                    
        for (ApexClass classObject : classes) {
            Boolean classImplementsInterface = false;
            try {
                classImplementsInterface = Type.forName(classObject.Name).newInstance() instanceOf ACN_NavigationProviderService;
            }
            catch (Exception Ex) {
                System.debug('$$$$$$ACN_NavigationDataProviderDataSource - classObject.Name: ' + classObject.Name + ' Ex: ' + Ex.getMessage());
            }
            if (classImplementsInterface) {
                VisualEditor.DataRow designPropertyValue = new VisualEditor.DataRow(classObject.Name, classObject.Name);
                designPropertyValues.addRow(designPropertyValue);
            }
        }

        return designPropertyValues;
    }
}