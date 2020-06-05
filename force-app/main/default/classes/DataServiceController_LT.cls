/**
 * Wires community data service with LWC and Aura components.
 */
public with sharing class DataServiceController_LT {
    // TODO: fix me or remove me!!!
    /**
     * Provisional implementation of NGPS Claim defaults initialization for a given caseGroup.
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getClaimData(String caseGroup) {
        return new Map<String, Object> {
            'contact' => CommunityDataService.getCurrentUserContact(),
            'products' => CommunityDataService.getProductsForRecordType(caseGroup)
        };
    }

    /**
     * Temporary implementation of BLM Cases (Claims) retrieval based on current user contact account.
     */
    @AuraEnabled(cacheable=true)
    public static List<NGPS_Case__c> getMyClaims() {
        return new Elevator().getMyClaims();
    }

    /**
     * Temporary implementation of BLM Case (Claims) retrieval for the current user.
     */
    @AuraEnabled(cacheable=true)
    public static NGPS_Case__c getClaimDetails(Id recordId) {
        return new Elevator().getClaimDetails(recordId);
    }

    /**
     * Allows running code without sharing considerations.
     */
    private without sharing class Elevator {
        public List<NGPS_Case__c> getMyClaims() {
            return CommunityDataService.getRelatedClaims();
        }

        public NGPS_Case__c getClaimDetails(Id recordId) {
            return CommunityDataService.getClaimDetails(recordId);
        }
    }
}