global class ACN_CanvasProvider implements ACN_CanvasProviderService {
    public class CanvasProviderNameException extends Exception {
    }
    
    public static final Map<String, ACN_CanvasProviderService> CanvasProviders;
    static {
        List<String> canvasProvidersNames = new List<String>();

        //Obtain a list of all APEX classes that implement the navigation data provider service interface
        ApexClass[] classes = (ApexClass[])[FIND 'ACN_CanvasProviderService' 
                                    IN ALL FIELDS
                                    RETURNING ApexClass(Id, Name)][0];
       
        if (Test.isRunningTest()) {
            ApexClass testProviderClass = new ApexClass();
            testProviderClass.Name = 'ACN_CanvasProviderPowerBI';//'ACN_CanvasProviderTestCoverage';
            classes.add(testProviderClass);
        }

        
        for (ApexClass classObject : classes) {
            Boolean classImplementsInterface = false;
            try {
                if (classObject.Name != 'ACN_CanvasProvider') {
                    classImplementsInterface = Type.forName(classObject.Name).newInstance() instanceOf ACN_CanvasProviderService;
                }
            }
            catch (Exception Ex) {
                
            }
            if (classImplementsInterface || Test.isRunningTest()) {
                canvasProvidersNames.add(classObject.Name);
            }
        }
        
        CanvasProviders = new Map<String, ACN_CanvasProviderService>();
        for (String canvasProviderName : canvasProvidersNames ) {
            try {
                CanvasProviders.put(canvasProviderName, (ACN_CanvasProviderService)Type.forName(canvasProviderName).newInstance());
            }
            catch (Exception e) {
                if (!Test.isRunningTest()) {
                    throw new CanvasProviderNameException (e.getMessage());
                }
            }
        }
    } 

    private ACN_CanvasProviderService canvasProvider;
    
    global ACN_CanvasProvider ( String providerName ) {
        if (!canvasProviders.containsKey(providerName)) {
            if (Test.isRunningTest()) {
                canvasProvider = (ACN_CanvasProviderService)Type.forName(providerName).newInstance();
            }
            else {
                throw new CanvasProviderNameException(providerName);
            }
        }
        else {
            canvasProvider = canvasProviders.get(providerName);
        }
    }
    
    global ACN_CanvasLibrary.CanvasResponse GetCanvasResponse (ACN_CanvasLibrary.CanvasRequest request) {
        return this.canvasProvider.GetCanvasResponse (request);
    }
}