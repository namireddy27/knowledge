@isTest
public class HR_TestDataFactoryCreator {
/*    private static Integer NUM_ACCOUNTS;
    
    public static List<Account> acctsList = new List<Account>();
    
    public static List<HR_Application__c> tsoApps = new List<HR_Application__c>();
    public static List<HR_Application__c> erdKlExternalApps = new List<HR_Application__c>();
    public static List<HR_Application__c> erdKlInternalApps = new List<HR_Application__c>();
    public static List<HR_Application__c> erdTsesApps = new List<HR_Application__c>();
    public static List<HR_Application__c> fieldMapApps = new List<HR_Application__c>();
    public static List<HR_Application__c> fieldMapTSIApps = new List<HR_Application__c>();
    public static List<HR_Application__c> fieldMapTSSEApps = new List<HR_Application__c>();
    public static List<HR_Application__c> fieldMapSTIApps = new List<HR_Application__c>();
    public static List<HR_Application__c> fieldMapTSSEDCHApps = new List<HR_Application__c>();
    public static List<HR_Application__c> famsGApps = new List<HR_Application__c>();
    public static List<HR_Application__c> famsJP1Apps = new List<HR_Application__c>();
    public static List<HR_Application__c> famsJP2Apps = new List<HR_Application__c>();
    public static List<HR_Application__c> famsMapApps = new List<HR_Application__c>();
    public static List<HR_Application__c> hqApps = new List<HR_Application__c>();
    
    private static User LOCAL_AIRPORT_SPECIALIST;
    private static User CERT_SPECIALIST;
    private static User AIRPORT_OFFICIAL;
    
    public static HR_JOA__c tsoJOA;
    public static HR_JOA__c erdklJOA;
    public static HR_JOA__c erdtsesJOA;
    public static HR_JOA__c fieldMapJOA;
    public static HR_JOA__c famMapJOA;
    public static HR_JOA__c famsGJoa;
    
    public static HR_Cert__c tsoCert;
    public static HR_Cert__c erdKlExternalCert;
    public static HR_Cert__c erdKlInternalCert;
    public static HR_Cert__c fieldMapCert;
    public static HR_Cert__c erdTsesNonCompCert;
    
    public static Location__c loc;
    
    public static HR_JOA_Position_Location__c testJOALocPos;
    
    
    public static void createTestUsers(){
        Profile testProfile = [SELECT Id, Name FROM Profile WHERE Name='TSA Standard User' LIMIT 1];
        
        LOCAL_AIRPORT_SPECIALIST = new User(Alias='telas', 
                                            Username='testlocalairport__TESTCLASS@TESTCLASS.TEST',
                                            Email='hrit.test2@accenturefederal.com', 
                                            FirstName='Test', 
                                            LastName='Tester', 
                                            ProfileId=testProfile.Id,
                                            LanguageLocaleKey='en_US', 
                                            LOCALESIDKEY='en_US',
                                            EMAILENCODINGKEY='ISO-8859-1', 
                                            TIMEZONESIDKEY='America/Indiana/Indianapolis',
                                            Phone='1111111111',
                                            MobilePhone='1111111111',
                                            PostalCode='11111');
        CERT_SPECIALIST = new User(Alias='telax', 
                                   Username='testcertspecialist__TESTCLASS@TESTCLASS.TEST',
                                   Email='hrit.test2@accenturefederal.com', 
                                   FirstName='Test', 
                                   LastName='Tester', 
                                   ProfileId=testProfile.Id,
                                   LanguageLocaleKey='en_US', 
                                   LOCALESIDKEY='en_US',
                                   EMAILENCODINGKEY='ISO-8859-1', 
                                   TIMEZONESIDKEY='America/Indiana/Indianapolis',
                                   Phone='1111111111',
                                   MobilePhone='1111111111',
                                   PostalCode='11111');
        AIRPORT_OFFICIAL = new User(Alias='telac', 
                                    Username='testairportofficial__TESTCLASS@TESTCLASS.TEST',
                                    Email='hrit.test2@accenturefederal.com', 
                                    FirstName='Test', 
                                    LastName='Tester', 
                                    ProfileId=testProfile.Id,
                                    LanguageLocaleKey='en_US',
                                    LOCALESIDKEY='en_US',
                                    EMAILENCODINGKEY='ISO-8859-1', 
                                    TIMEZONESIDKEY='America/Indiana/Indianapolis',
                                    Phone='1111111111',
                                    MobilePhone='1111111111',
                                    PostalCode='11111');
        insert LOCAL_AIRPORT_SPECIALIST;
        insert CERT_SPECIALIST;
        insert AIRPORT_OFFICIAL;
    }
    
    public static void createLocation(){
        loc = new Location__c(
            RecordTypeId = Schema.SObjectType.Location__c.GetRecordTypeInfosByName().get('Airport').getRecordTypeId(),
            Name = 'Test Location',
            FAA_ID__c = 'TTL'
        );
        insert loc;
    }
    
    public static HR_JOA_Position_Location__c createJPL(HR_JOA__c testJOA){
        testJOALocPos = new HR_JOA_Position_Location__c(
            JOA__c = testJOA.Id,
            Location__c = loc.Id
        );
        insert testJOALocPos;
        
        return testJOALocPos;
    }
    
    public static HR_JOA__c createJOA_TSO(){
        tsoJOA = new HR_JOA__c(
            RecordTypeId = Schema.SObjectType.HR_JOA__c.GetRecordTypeInfosByName().get('Transportation Security Officer').getRecordTypeId(),
            Gender__c = '',
            FLSA_Category__c = 'Exempt',
            Permanent_Change_Of_Station__c = false,
            Calendar_days_open__c = 21,
            Vacancy_open_date__c = System.today(),
            Area_Of_Consideration__c = 'US-Wide',
            Financial_disclosure__c = false,
            Number_of_positions__c = NUM_ACCOUNTS,
            POC_1_user__c = LOCAL_AIRPORT_SPECIALIST.Id,
            POC_2_user__c = CERT_SPECIALIST.Id,
            POC_3_user__c = AIRPORT_OFFICIAL.Id,
            JOA_Status__c = 'New',
            Work_schedule__c = 'Full Time'
        );
        insert tsoJOA;
        return tsoJOA;
    }
    
    public static HR_JOA__c createJOA_ERDKL(){
        erdklJOA = new HR_JOA__c(
            RecordTypeId = Schema.SObjectType.HR_JOA__c.GetRecordTypeInfosByName().get('Executive Resource Division').getRecordTypeId(),
            Gender__c = '',
            FLSA_Category__c = 'Exempt',
            Permanent_Change_Of_Station__c = false,
            Calendar_days_open__c = 21,
            Vacancy_open_date__c = System.today(),
            Area_Of_Consideration__c = 'US-Wide',
            Financial_disclosure__c = false,
            Number_of_positions__c = NUM_ACCOUNTS,
            POC_1_user__c = LOCAL_AIRPORT_SPECIALIST.Id,
            POC_2_user__c = CERT_SPECIALIST.Id,
            POC_3_user__c = AIRPORT_OFFICIAL.Id,
            JOA_Status__c = 'Initiated',
            Work_schedule__c = 'Full Time',
            Job_Type__c = 'Exec'
        );
        insert erdklJOA;
        return erdklJOA;
    }
    
    public static HR_JOA__c createJOA_ERDTSES(){
        erdtsesJOA = new HR_JOA__c(
            RecordTypeId = Schema.SObjectType.HR_JOA__c.GetRecordTypeInfosByName().get('Executive Resource Division').getRecordTypeId(),
            Gender__c = '',
            FLSA_Category__c = 'Exempt',
            Permanent_Change_Of_Station__c = false,
            Calendar_days_open__c = 21,
            Vacancy_open_date__c = System.today(),
            Area_Of_Consideration__c = 'US-Wide',
            Financial_disclosure__c = false,
            Number_of_positions__c = NUM_ACCOUNTS,
            POC_1_user__c = LOCAL_AIRPORT_SPECIALIST.Id,
            POC_2_user__c = CERT_SPECIALIST.Id,
            POC_3_user__c = AIRPORT_OFFICIAL.Id,
            JOA_Status__c = 'Initiated',
            Job_Type__c = 'TSES'
        );
        insert erdtsesJOA;
        return erdtsesJOA;
    }
    
    public static HR_JOA__c createJOA_FieldMap(){
        fieldMapJOA = new HR_JOA__c(
            RecordTypeId = Schema.SObjectType.HR_JOA__c.GetRecordTypeInfosByName().get('Management, Administrative, and Professional').getRecordTypeId(),
            Calendar_days_open__c = 21,
            Vacancy_open_date__c = System.today(),
            Area_Of_Consideration__c = 'US-Wide',
            Number_of_positions__c = NUM_ACCOUNTS,
            POC_1_user__c = LOCAL_AIRPORT_SPECIALIST.Id,
            POC_2_user__c = CERT_SPECIALIST.Id,
            POC_3_user__c = AIRPORT_OFFICIAL.Id
        );
        insert fieldMapJOA;
        return fieldMapJOA;
    }
    
    public static HR_JOA__c createJOA_FamMap(){
        famMapJOA = new HR_JOA__c(
            RecordTypeId = Schema.SObjectType.HR_JOA__c.GetRecordTypeInfosByName().get('Federal Air Marshal - Management, Administrative, and Professional').getRecordTypeId(),
            Calendar_days_open__c = 21,
            Vacancy_open_date__c = System.today(),
            Area_Of_Consideration__c = 'US-Wide',
            Number_of_positions__c = NUM_ACCOUNTS,
            POC_1_user__c = LOCAL_AIRPORT_SPECIALIST.Id,
            POC_2_user__c = CERT_SPECIALIST.Id,
            POC_3_user__c = AIRPORT_OFFICIAL.Id
        );
        insert famMapJOA;
        return famMapJOA;
    }
    
    public static HR_JOA__c createJOA_FamsG(){
        famsGJOA = new HR_JOA__c(
            RecordTypeId = Schema.SObjectType.HR_JOA__c.GetRecordTypeInfosByName().get('Federal Air Marshal - G Band').getRecordTypeId(),
            Calendar_days_open__c = 21,
            Vacancy_open_date__c = System.today(),
            Area_Of_Consideration__c = 'US-Wide',
            Number_of_positions__c = NUM_ACCOUNTS,
            POC_1_user__c = LOCAL_AIRPORT_SPECIALIST.Id,
            POC_2_user__c = CERT_SPECIALIST.Id,
            POC_3_user__c = AIRPORT_OFFICIAL.Id
        );
        insert famsGJOA;
        return famsGJOA;
    }
    
    
    public static List<Account> createAccounts(Integer numAccts){
        NUM_ACCOUNTS = numAccts;
        for(Integer i = 0; i<numAccts; i++){
            Account a = new Account(
                RecordTypeId = Schema.SObjectType.Account.GetRecordTypeInfosByName().get('TSA Candidate').getRecordTypeId()
            );
            a.FirstName = 'TestAccount';
            a.LastName = String.valueOf(i);
            a.HR_EOD_Date__c = System.today().addDays(45);
            if(math.mod(i, 2) == 0){
                a.HR_Adjudicated_Veteran_Status__c = 'Veteran';
                a.HR_Veteran_Status__c = 'CP';
            }else{
                a.HR_Adjudicated_Veteran_Status__c = 'NV';
                a.HR_Veteran_Status__c = 'NV';
            }
            if(math.mod(Integer.valueof((Math.random() * 4)), 2) == 0){
                a.HR_Gender__c = 'Female';
            }else{
                a.HR_Gender__c = 'Male';
            }
            if(math.mod(Integer.valueof((Math.random() * 6)), 2) == 0){
                a.HR_Special_Status__c = '';
            }else if(math.mod(Integer.valueof((Math.random() * 6)), 3) == 0){
                a.HR_Special_Status__c = 'SP';
            }else{
                a.HR_Special_Status__c = 'PEP';
            }
            
            acctsList.add(a);
        }
        insert acctsList;
        return acctsList;
    }    
    
    public static void createApplications_TSO(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('TSO').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-30,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*30),
                Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id
            );
            tsoApps.add(na);
        }
        insert tsoApps;
    }
    
    public static void createApplications_ERDklExternal(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('ERD KL').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-30,
                Qualified_Date__c = System.today(),
                Candidate__c = acctsList[j].Id,
                Area_of_Consideration__c = 'KL_External',
                Monster_Status__c = 'BQ',
                JOA__c = erdklJOA.Id
            );
            erdKlExternalApps.add(na);
        }
        insert erdKlExternalApps;
    }
    
    public static void createApplications_ERDklInternal(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('ERD KL').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-30,
                Qualified_Date__c = System.today(),
                Candidate__c = acctsList[j].Id,
                Area_of_Consideration__c = 'KL_Internal',
                Monster_Status__c = 'BQ',
                JOA__c = erdklJOA.Id
            );
            erdKlInternalApps.add(na);
        }
        insert erdKlInternalApps;
    }
    
    public static void createApplications_ERDtses(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('ERD TSES').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-30,
                Qualified_Date__c = System.today(),
                Candidate__c = acctsList[j].Id,
                Area_of_Consideration__c = 'TSES - Non-Competitive',
                Monster_Status__c = 'BQNC',
                JOA__c = erdTsesJOA.Id
            );
            erdTsesApps.add(na);
        }
        insert erdTsesApps;
    }
    
    public static void createApplications_FieldMAP(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('Field MAP').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id,
                JOA__c = fieldMapJOA.Id
            );
            fieldMapApps.add(na);
        }
        insert fieldMapApps;
    }
    
    public static void createApplications_FieldMAPSTI(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('Field MAP (STI)').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id,
                JOA__c = fieldMapJOA.Id
            );
            fieldMapSTIApps.add(na);
        }
        insert fieldMapSTIApps;
    }
    
    public static void createApplications_FieldMAPTSI(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('Field MAP (TSI)').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id,
                JOA__c = fieldMapJOA.Id
            );
            fieldMapTSIApps.add(na);
        }
        insert fieldMapTSIApps;
    }
    
    public static void createApplications_FieldMAPTSSE(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('Field MAP (TSS-E)').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id,
                JOA__c = fieldMapJOA.Id
            );
            fieldMapTSSEApps.add(na);
        }
        insert fieldMapTSSEApps;
    }

    public static void createApplications_FieldMAPTSSEDCH(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('Field MAP (TSS-EDCH)').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id,
                JOA__c = fieldMapJOA.Id
            );
            fieldMapTSSEDCHApps.add(na);
        }
        insert fieldMapTSSEDCHApps;
    }
    
    public static void createApplications_FAMSG(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('FAMS G').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id,
                JOA__c = famsGJOA.Id
            );
            famsGApps.add(na);
        }
        insert famsGApps;
    }
    
     public static void createApplications_FAMSJP1(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('FAMS J (Phase 1)').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id
            );
            famsJP1Apps.add(na);
        }
        insert famsJP1Apps;
    }
    
    public static void createApplications_FAMSJP2(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('FAMS J (Phase 2)').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id
            );
            famsJP2Apps.add(na);
        }
        insert famsJP2Apps;
    }
    
    public static void createApplications_FAMSMAP(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('FAMS MAP').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id
            );
            famsMapApps.add(na);
        }
        insert famsMapApps;
    }
    
    public static void createApplications_HQ(){
        for (Integer j=0; j<NUM_ACCOUNTS;j++){
            Account acct = acctsList[j];
            HR_Application__c na = new HR_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Application__c.GetRecordTypeInfosByName().get('HQ').getRecordTypeId(),
                Application_Submission_Date__c = System.today()-20,
                EOD_Date__c = acctsList[j].HR_EOD_Date__c,
                Qualified_Date__c = System.today() - Integer.valueof(Math.random()*20),
                //Composite_Score__c = Integer.valueof(((Math.random() +5) * 15)),
                Candidate__c = acctsList[j].Id
            );
            hqApps.add(na);
        }
        insert hqApps;
    }
    
    public static HR_Cert__c createCert_TSO(){
        tsoCert = new HR_Cert__c(
            RecordTypeId = Schema.SObjectType.HR_Cert__c.GetRecordTypeInfosByName().get('TSO').getRecordTypeId(),
            Status__c = 'Requested',
            Work_Schedule__c = 'Full Time',
            Location__c = loc.Id,
            Cert_Name__c = ''
        );
        
        insert tsoCert;
        return tsoCert;
    }
    
    public static HR_Cert__c createCert_TSOPT(){
        tsoCert = new HR_Cert__c(
            RecordTypeId = Schema.SObjectType.HR_Cert__c.GetRecordTypeInfosByName().get('TSO').getRecordTypeId(),
            Status__c = 'Requested',
            Work_Schedule__c = 'Part Time',
            Location__c = loc.Id,
            Cert_Name__c = ''
        );
        
        insert tsoCert;
        return tsoCert;
    }
    
    public static HR_Cert__c createCert_ERDKLExternal(){
        erdKlExternalCert = new HR_Cert__c(
            RecordTypeId = Schema.SObjectType.HR_Cert__c.GetRecordTypeInfosByName().get('ERD').getRecordTypeId(),
            Status__c = 'Issued',
            Area_of_Consideration__c = 'KL_External',
            Expiration_Date__c = System.now()+30,
            JOA__c = erdKlJOA.Id,
            Cert_Name__c = '',
            Location__c = loc.Id
        );
        insert erdKlExternalCert;
        return erdKlExternalCert;
    }
    
    public static HR_Cert__c createCert_ERDKLInternal(){
        erdKlInternalCert = new HR_Cert__c(
            RecordTypeId = Schema.SObjectType.HR_Cert__c.GetRecordTypeInfosByName().get('ERD').getRecordTypeId(),
            Status__c = 'Issued',
            Area_of_Consideration__c = 'KL_Internal',
            Expiration_Date__c = System.now()+30,
            JOA__c = erdKlJOA.Id,
            Cert_Name__c = '',
            Location__c = loc.Id
        );
        insert erdKlInternalCert;
        return erdKlInternalCert;
    }
    
    public static HR_Cert__c createCert_ERDTSESNonComp(){
        erdTsesNonCompCert = new HR_Cert__c(
            RecordTypeId = Schema.SObjectType.HR_Cert__c.GetRecordTypeInfosByName().get('ERD').getRecordTypeId(),
            Status__c = 'Issued',
            Area_of_Consideration__c = 'TSES - Non-Competitive',
            Expiration_Date__c = System.now()+30,
            JOA__c = erdTsesJOA.Id,
            Cert_Name__c = '',
            Location__c = loc.Id
        );
        insert erdTsesNonCompCert;
        return erdTsesNonCompCert;
    }
    
    public static HR_Cert__c createCert_FieldMAP(){
        fieldMapCert = new HR_Cert__c(
            RecordTypeId = Schema.SObjectType.HR_Cert__c.GetRecordTypeInfosByName().get('MAP').getRecordTypeId(),
            Status__c = 'Issued',
            JOA__c = fieldMAPJOA.Id,
            Expiration_Date__c = System.now()+30,
            Cert_Name__c = '',
            Location__c = loc.Id
        );
        insert fieldMapCert;
        return fieldMapCert;
    }
    
    public static void createCertApps_TSO(){
        List<HR_Cert_Application__c> tsoCertApp = new List<HR_Cert_Application__c>();
        for(HR_Application__c ap : tsoApps){
            tsoCertApp.add(new HR_Cert_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Cert_Application__c.GetRecordTypeInfosByName().get('TSO').getRecordTypeId(),
                Application__c = ap.Id,
                Cert__c = tsoCert.Id,
                HR_Status__c = 'Eligible',
                Ranking__c = null
            ));
        }
        insert tsoCertApp;
    }
    
    public static void createCertApps_NonTSO(HR_Cert__c NonTsoCert, List<HR_Application__c> apps){
        List<HR_Cert_Application__c> nonTsoCertApp = new List<HR_Cert_Application__c>();
        for(HR_Application__c ap : apps){
            nonTsoCertApp.add(new HR_Cert_Application__c(
                RecordTypeId = Schema.SObjectType.HR_Cert_Application__c.GetRecordTypeInfosByName().get('Non-TSO').getRecordTypeId(),
                Application__c = ap.Id,
                Cert__c = NonTsoCert.Id,
                HR_Status__c = 'Eligible'
            ));
        }
        insert nonTsoCertApp;
    }

*/
}