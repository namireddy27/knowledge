global class ACN_CanvasDataProviderDataSource extends VisualEditor.DynamicPickList {
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('', '');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows  designPropertyValues = new VisualEditor.DynamicPickListRows();
        ApexClass[] classes = (ApexClass[])[FIND 'ACN_CanvasProviderService' 
                                    IN ALL FIELDS
                                    RETURNING ApexClass(Id, Name)][0];
                //SOSL never return results during test execution,. using a custom label to mock the names of all providers that need to be tested
        if (Test.isRunningTest()) {
            if (!String.isBlank(Label.ACN_NavigationProviderTestProviderNamesCSV)) {
                ApexClass testApexClass;
                List<String> testNavigationProviderClassNames = Label.ACN_NavigationProviderTestProviderNamesCSV.split(',');
                for (String testNavigationProviderClassName : testNavigationProviderClassNames) {
                    testApexClass = new ApexClass();
                    testApexClass.Name = testNavigationProviderClassName;
                    classes.add(testApexClass);
                }
            }
        }
                                    
        for (ApexClass classObject : classes) {
            Boolean classImplementsInterface = false;
            try {
                classImplementsInterface = Type.forName(classObject.Name).newInstance() instanceOf ACN_CanvasProviderService;
            }
            catch (Exception Ex) {
                
            }
            if (classImplementsInterface) {
                VisualEditor.DataRow designPropertyValue = new VisualEditor.DataRow(classObject.Name, classObject.Name);
                designPropertyValues.addRow(designPropertyValue);
            }
        }

        return designPropertyValues;
    }
}