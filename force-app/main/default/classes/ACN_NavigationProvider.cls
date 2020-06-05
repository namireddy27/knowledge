global class ACN_NavigationProvider implements ACN_NavigationProviderService {
    public class NavigationProviderNameException extends Exception {
    }
    
    //variable declaration
    public static final Map<String, ACN_NavigationProviderService> NavigationProviders;
    
    //Initialization Code/Instance Method?
    static {
        ACN_CommunityNavigationConfig__c config = ACN_CommunityNavigationConfig__c.getInstance();
        List<String> navigationProvidersNames = new List<String>();

        //Obtain a list of all APEX classes that implement the navigation data provider service interface
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
        
        System.debug('Classes: ' + classes);                                    
        for (ApexClass classObject : classes) {
            Boolean classImplementsInterface = false;
            try {
                classImplementsInterface = Type.forName(classObject.Name).newInstance() instanceOf ACN_NavigationProviderService;
                System.debug(classObject + ' ' + classImplementsInterface);
            }
            catch (Exception Ex) {
                System.debug('$$$$$$ACN_NavigationProvider - classObject.Name: ' + classObject.Name + ' Ex: ' + Ex.getMessage());
            }
            if (classImplementsInterface) {
                navigationProvidersNames.add(classObject.Name);
            }
        }
        
        NavigationProviders = new Map<String, ACN_NavigationProviderService>();
        for (String navigationProviderName : navigationProvidersNames ) {
            try {
                //System.debug('$$$$$$ navigationProviderName: ' + navigationProviderName);
                NavigationProviders.put(navigationProviderName, (ACN_NavigationProviderService)Type.forName(navigationProviderName).newInstance());
            }
            catch (Exception e) {
                throw new NavigationProviderNameException (e.getMessage());
                //System.debug('ACN_NavigationProvider caught Exception: ' + e);
                continue;
            }
        }
        System.debug('this is the map: ' + NavigationProviders);
    } 

    private ACN_NavigationProviderService navigationProvider;
    
    global ACN_NavigationProvider ( String navigationProviderName ) {
        system.debug('===> ENTER ACN_NavigationProviderService\n\t\t\t navigationProviderName: ' + navigationProviderName + '\n');
        if (!navigationProviders.containsKey(navigationProviderName)) {
            throw new NavigationProviderNameException(navigationProviderName);
        }
        navigationProvider = navigationProviders.get(navigationProviderName);
        //system.debug('===> ENTER CS_CalendarDataProvider(dataProviderName)\n\t\t\t calendarDataProvider: ' + calendarDataProvider + '\n');
    }

    global ACN_NavigationLibrary.NavigationList GetNavigationList (ACN_NavigationLibrary.NavigationRequest request) {
        return this.navigationProvider.GetNavigationList (request);
    }

    global ACN_NavigationLibrary.NavigationList GoUp (ACN_NavigationLibrary.NavigationRequest request) {
        return this.navigationProvider.GoUp (request); 
    }
    
    global ACN_NavigationLibrary.NavigationList GoPrevious (ACN_NavigationLibrary.NavigationRequest request)
    {
        return this.navigationProvider.GoPrevious (request);
    }
    
    global ACN_NavigationLibrary.NavigationList GoNext (ACN_NavigationLibrary.NavigationRequest request)
    {
        return this.navigationProvider.GoNext (request);
    }
    
    global ACN_NavigationLibrary.NavigationList GoLast (ACN_NavigationLibrary.NavigationRequest request)
    {
        return this.navigationProvider.GoLast (request);
    }

    global ACN_NavigationLibrary.NavigationList SavePreference (ACN_NavigationLibrary.NavigationRequest request)
    {
        return this.navigationProvider.SavePreference (request);
    }
 
    global ACN_NavigationLibrary.NavigationList LoadPreference (ACN_NavigationLibrary.NavigationRequest request)
    {
        return this.navigationProvider.LoadPreference (request);
    }
    
    /*global String getNavigationURL(String navigationType, String navigationTarget) {
        return this.navigationProvider.getNavigationURL(navigationType, navigationTarget);
    }*/
    
}