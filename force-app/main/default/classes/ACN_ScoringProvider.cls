global class ACN_ScoringProvider {
    public class ScoringProviderNameException extends Exception {
    }
    
    public static final Map<String, ACN_ScoringProviderService> ScoringProviders;
    
    static {
        //Obtain a list of all APEX classes that implement the navigation data provider service interface
        ApexClass[] classes = (ApexClass[])[FIND 'ACN_ScoringProviderService' 
                                    IN ALL FIELDS
                                    RETURNING ApexClass(Id, Name)][0];
                                    
        List<String> scoringProvidersNames = new List<String>();
        for (ApexClass classObject : classes) {
            Boolean classImplementsInterface = false;
            try {
                if (classObject.Name != 'ACN_ScoringProvider') {
                    classImplementsInterface = Type.forName(classObject.Name).newInstance() instanceOf ACN_ScoringProviderService;
                }
            }
            catch (Exception Ex) {
                
            }
            if (classImplementsInterface) {
                scoringProvidersNames.add(classObject.Name);
            }
        }    
    
        ScoringProviders = new Map<String, ACN_ScoringProviderservice>();
        for (String scoringProviderName : scoringProvidersNames ) {
            try {
                ScoringProviders.put(scoringProviderName, (ACN_ScoringProviderservice)Type.forName(scoringProviderName).newInstance());
            }
            catch (Exception e) {
                System.debug('ACN_ScoringProvider caught Exception: ' + e);
                continue;
            }
        }
    } 

    private ACN_ScoringProviderservice scoringProvider;
    
    global ACN_ScoringProvider ( String scoringProviderName ) {
        if (!ScoringProviders.containsKey(scoringProviderName)) {
            throw new scoringProviderNameException(scoringProviderName);
        }
        scoringProvider = ScoringProviders.get(scoringProviderName);
    }

    global ACN_ScoringLibrary.ScoringResponse GetScoringResponse (ACN_ScoringLibrary.ScoringRequest request) {
        return this.scoringProvider.GetScoringResponse (request);
    }
}