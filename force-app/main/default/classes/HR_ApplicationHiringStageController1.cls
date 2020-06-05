public without sharing class HR_ApplicationHiringStageController1 {
    public static List<HR_Assessment__c> asmtList;
    //public static List<Integer> offerList;
    
    public static List<Integer> checkTSO(HR_Application__c currentApp, Decimal order){
        //CBT
        if(order == 20 ){
            asmtList = [SELECT Id, Assessment_Status__c, Name, Expired__c, RecordType.Name 
                        FROM HR_Assessment__c 
                        WHERE Candidate__c = :currentApp.Candidate__c 
                        AND RecordType.Name = 'CBT- TSO' AND Expired__c = false
                        ORDER BY Name ASC];           
        }
        /*
        //Contingent Offer
        else if(order == 30){
            return getOffer(currentApp);
        }
*/
        //Airport Assessment
        else if(order == 50){
            asmtList = getAssessments(currentApp, 'Airport Assessment');       
        }
        //Medical and Drug
        else if(order == 60){
            asmtList = getAssessments(currentApp, 'Medical (TSO)');
            asmtList.addAll(getAssessments(currentApp, 'Drug (TSO)')); 
        }
        //BI
        else if(order == 70){
            asmtList = getAssessments(currentApp, 'BI (TSO)');
        }
        //System.debug('this is asmtList: ' + asmtList);
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                }
        else{
            return checkAssessments();
        }
        
    }
    public static List<Integer> checkFieldMAP(HR_Application__c currentApp, Decimal order){
        //BI/Drug
        if(order == 50){
            asmtList = getAssessments(currentApp, 'BI (Field MAP)');
            asmtList.addAll(getAssessments(currentApp,'Drug (Field MAP)'));
        }
        /*
        //Tentative Job Offer
        else if(order == 40){
            return getOffer(currentApp);
        }
*/
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkTSSEDCH(HR_Application__c currentApp, Decimal order){
        //CBT
        if(order == 30){
            asmtList = getAssessments(currentApp, 'CHAB');
        }
        /*
        //Tentative Job Offer
        else if(order == 60){
            return getOffer(currentApp);
        }
*/
        //BI/Medical/Drug
        else if(order == 70){
            asmtList = getAssessments(currentApp, 'BI (TSS-EDCH)');
            asmtList.addAll(getAssessments(currentApp,'Drug (TSS-EDCH)'));
            asmtList.addAll(getAssessments(currentApp,'Medical (TSS-EDCH)'));
        }
        /*else if (order == 80){
            
        }*/
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkTSSE(HR_Application__c currentApp, Decimal order){
        //Missing Structured Interview
        if(order == 30){
            asmtList = getAssessments(currentApp, 'Structured Interview');
        }
        /*
        //Tentative Job Offer
        else if(order == 50){
            return getOffer(currentApp);
        }
*/
        else if(order == 60){
            asmtList = getAssessments(currentApp, 'BI (TSS-E)');
            asmtList.addAll(getAssessments(currentApp,'Drug (TSS-E)'));
            asmtList.addAll(getAssessments(currentApp,'Medical (TSS-E)'));
        }
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkTSI(HR_Application__c currentApp, Decimal order){
        System.debug('this is the order: ' + order);
        if(order == 30){
            asmtList = getAssessments(currentApp, 'Field MAP WSA');
        }
        /*
        //Tentative Job Offer
        else if(order == 50){
            return getOffer(currentApp);
        }
*/
        else if(order == 60){
            asmtList = getAssessments(currentApp, 'BI (TSI)');
            asmtList.addAll(getAssessments(currentApp,'Drug (TSI)'));
        }
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkSTI(HR_Application__c currentApp, Decimal order){
        //Missing Structured Interview/Training Demo
        if(order == 30){
            asmtList = getAssessments(currentApp, '');
        }
        /**
        else if(order ==){
            asmtList = getAssessments(currentApp, 'BI (STI)');
            asmtList.addAll(getAssessments(currentApp,'Drug (STI)'));
        }
**/
        //No Tentative Job Offer Order in Metadata
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkFAMSG(HR_Application__c currentApp, Decimal order){
        if(order == 20){
            asmtList = getAssessments(currentApp, 'FAB');
        }
        //Missing Field Office Assessment
        else if(order == 30){
            asmtList = getAssessments(currentApp, '');
        }
        /*
        //Conditional Job Offer
        else if(order == 50){
            return getOffer(currentApp);
        }
*/
        else if(order == 60){
            asmtList = getAssessments(currentApp, 'BI (FAMS G)');
        }
        else if(order == 65){
            asmtList = getAssessments(currentApp, 'Medical (FAMS G)');
            asmtList.addAll(getAssessments(currentApp,'Drug (FAMS G)'));
        }
        
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkFAMSJP1(HR_Application__c currentApp, Decimal order){
        if(order == 30){
            asmtList = getAssessments(currentApp, 'LBR/WSA CBT');
        }
        //Missing Leadership Job Simulation
        else if(order == 40){
            asmtList = getAssessments(currentApp, '');
        }
        //Missing Duty Office Assessment
        else if(order == 50){
            asmtList = getAssessments(currentApp, '');
        }
        //No Tentative Job Offer Order
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkFAMSJP2(HR_Application__c currentApp, Decimal order){
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkFAMSMAP(HR_Application__c currentApp, Decimal order){
        if(order == 50){
            asmtList = getAssessments(currentApp, 'BI (FAMS MAP)');
        }
        /*
        //Tentative Job Offer
        else if(order == 40){
            return getOffer(currentApp);
        }
*/
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    
    public static List<Integer> checkERDKL(HR_Application__c currentApp, Decimal order){    
        if(order == 50){
            asmtList = getAssessments(currentApp, 'BI (ERD)');
            asmtList.addAll(getAssessments(currentApp,'Drug (ERD)'));
        }
        /*
        //Tentative Job Offer
        else if(order == 40){
            return getOffer(currentApp);
        }
*/
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkERDTSES(HR_Application__c currentApp, Decimal order){    
        if(order == 60){
            asmtList = getAssessments(currentApp, 'BI (ERD)');
            asmtList.addAll(getAssessments(currentApp,'Drug (ERD)'));
        }
        /*
        //Tentative Job Offer
        else if(order == 50){
            return getOffer(currentApp);
        }
*/
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    public static List<Integer> checkHQ(HR_Application__c currentApp, Decimal order){    
        if(order == 50){
            asmtList = getAssessments(currentApp, 'BI (HQ)');
            asmtList.addAll(getAssessments(currentApp,'Drug (HQ)'));
        }
        /*
        //Tentative Job Offer
        else if(order == 40){
            return getOffer(currentApp);
        }
*/
        if(asmtList == NULL || asmtList.size() == 0){
            return new List<Integer>{10};
                
                }
        else{
            return checkAssessments();
        }
    }
    
    
    
    public static List<HR_Assessment__c> getAssessments(HR_Application__c currentApp, String assessmentType){
        return [SELECT Id, Assessment_Status__c, Name, Expired__c 
                FROM HR_Assessment__c 
                WHERE Candidate__c = :currentApp.Candidate__c 
                AND Assessment_Name__c = :assessmentType AND Expired__c = false
                ORDER BY Name DESC];
    }
    
    public static List<Integer> checkAssessments(){
        boolean foundFailed = false;
        List<Integer> intList = new List<Integer>();
        for(HR_Assessment__c a : asmtList){
            if(a.Assessment_Status__c == 'Invited' && a.Expired__c == false){
                intList.add(20);
            }
            else if(a.Assessment_Status__c == 'Scheduled' && a.Expired__c == false){
                intList.add(30);
            }
            else if(a.Assessment_Status__c == 'Passed' && a.Expired__c == false){
                intList.add(40);
            }
            else if(a.Assessment_Status__c == 'Failed' && a.Expired__c == false){
                intList.add(50);
                foundFailed = true;
            }
        }
        
        if(foundFailed && intList.size() > 1){
            intList.clear();
            intList.add(50);
        }
        if(intList.size() > 0){
            return intList;
        }
        else{
            intList.add(10);
            return intList;
        }
    }
    /*
    public static List<Integer> getOffer(HR_Application__c currentApp){
        HR_Offer__c oList = [SELECT Id, Name
                                FROM HR_Offer__c 
                                WHERE Application__c =: currentApp.Id
                                AND Candidate__c = :currentApp.Candidate__c 
                                AND Status__c = 'Pending Assessments' 
                                ORDER BY Name DESC];
        if(oList.Id != NULL){
            return new List<Integer>{40};
        }
        else{
            return new List<Integer>{10};
                }
    }
*/
}