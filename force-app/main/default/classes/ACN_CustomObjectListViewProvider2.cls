global with sharing class ACN_CustomObjectListViewProvider2 implements ACN_NavigationProviderService {
    final String DEFAULT_GROUP_KEY = 'defaultGroup';

 

    global ACN_CommunityNavigationConfig__c settings {get; set;}
    
    global ACN_CustomObjectListViewProvider2() {
        settings = ACN_CommunityNavigationConfig__c.getInstance();
    }
    
    global ACN_NavigationLibrary.NavigationList GetNavigationList (ACN_NavigationLibrary.NavigationRequest request) {
        ACN_NavigationProviderService originalProvider = new ACN_CustomObjectListViewProvider();
        
        String composedRequestId = request.Id; //code nav item + ":" + currentRecordId ({!recordId})
        List<String> idParts = composedRequestId.split(':');
        String code = idParts[0];
        String recordId = '';
        if (idParts.size()>1) {
            recordId = idParts[1];
        }
        String value = '';
        if (idParts.size()>2) {
            value = idParts[2];
        }
        
        request.Id = code;
        ACN_NavigationLibrary.NavigationList navList = originalProvider.GetNavigationList(request);
        List<ACN_NavigationLibrary.NavigationListItem> items = new List<ACN_NavigationLibrary.NavigationListItem>();
        Map<String, ACN_NavigationLibrary.NavigationListItem> groupItems = new Map<String, ACN_NavigationLibrary.NavigationListItem>();
        Map<String,String> cardValues = new Map<String,String>();

 

        /*
        //record 01
        cardValues.put('groupName','001');
        cardValues.put('action_accept','action_accept_' + cardValues.get('groupName'));
        cardValues.put('action_decline','action_decline_' + cardValues.get('groupName'));
        cardValues.put('action_update','action_update_' + cardValues.get('groupName'));
        cardValues.put('caseNumber', cardValues.get('groupName'));
        cardValues.put('chatterPostMessage', 'chatterPostMessage_' + cardValues.get('groupName'));
        cardValues.put('guestName', 'guestName_' + cardValues.get('groupName'));
        cardValues.put('roomNumber', 'roomNumber_' + cardValues.get('groupName'));
        items.addAll(getMergedListItems(navList.Items, cardValues));
        groupItems.putAll(getMergedMapItems(navList.GroupItems.values(), cardValues));
        
        //record 02
        cardValues.put('groupName','002');
        cardValues.put('action_accept','action_accept_' + cardValues.get('groupName'));
        cardValues.put('action_decline','action_decline_' + cardValues.get('groupName'));
        cardValues.put('action_update','action_update_' + cardValues.get('groupName'));
        cardValues.put('caseNumber', cardValues.get('groupName'));
        cardValues.put('chatterPostMessage', 'chatterPostMessage_' + cardValues.get('groupName'));
        cardValues.put('guestName', 'guestName_' + cardValues.get('groupName'));
        cardValues.put('roomNumber', 'roomNumber_' + cardValues.get('groupName'));
        items.addAll(getMergedListItems(navList.Items, cardValues));
        groupItems.putAll(getMergedMapItems(navList.GroupItems.values(), cardValues));
        */

 
        /**
        for (Case caseRecord : [SELECT Id, CaseNumber, CreatedDate, Subject, Account.Name, Contact.FirstName, Contact.LastName FROM Case WHERE ContactId != null]) {
            cardValues.put('groupName', caseRecord.CaseNumber);
            cardValues.put('caseNumber', cardValues.get('groupName'));
            cardValues.put('chatterPostMessage', caseRecord.Subject);
            cardValues.put('guestName', caseRecord.Contact.LastName + ', ' + caseRecord.Contact.FirstName);
            cardValues.put('roomNumber', String.valueOf(caseRecord.CreatedDate.day()));
            items.addAll(getMergedListItems(navList.Items, cardValues));
            groupItems.putAll(getMergedMapItems(navList.GroupItems.values(), cardValues));
        }

    **/

        /*
        for (Contact contactRecord : [SELECT Id, LastName, FirstName FROM Contact WHERE LastName != null AND FirstName != null]) {
            cardValues.put('groupName', contactRecord.Id);
            cardValues.put('caseNumber', cardValues.get('groupName'));
            cardValues.put('chatterPostMessage', 'chatterPostMessage_' + cardValues.get('groupName'));
            cardValues.put('guestName', contactRecord.LastName + ', ' + contactRecord.FirstName);
            cardValues.put('roomNumber', 'roomNumber_' + cardValues.get('groupName'));
            items.addAll(getMergedListItems(navList.Items, cardValues));
            groupItems.putAll(getMergedMapItems(navList.GroupItems.values(), cardValues));
        }
        */
        /**        
        navList.Items.clear();
        navList.Items.addAll(items);
        navList.GroupItems.clear();
        navList.GroupItems.putAll(groupItems);
**/        
        return navList;
    }

 

    private Map<String, ACN_NavigationLibrary.NavigationListItem> getMergedMapItems ( List<ACN_NavigationLibrary.NavigationListItem> templateItems, Map<String,String> mergeVariablesMap) {
        List<ACN_NavigationLibrary.NavigationListItem> mergedItems = getMergedListItems (templateItems, mergeVariablesMap);
        Map<String, ACN_NavigationLibrary.NavigationListItem> mergedItemsMap = new Map<String, ACN_NavigationLibrary.NavigationListItem>();
        for (ACN_NavigationLibrary.NavigationListItem navItem : mergedItems ) {
            mergedItemsMap.put(navItem.GroupName, navItem);
        }
        
        return mergedItemsMap;
    }

 

    private List<ACN_NavigationLibrary.NavigationListItem> getMergedListItems ( List<ACN_NavigationLibrary.NavigationListItem> templateItems, Map<String,String> mergeVariablesMap) {
        List<ACN_NavigationLibrary.NavigationListItem> mergedItems = new List<ACN_NavigationLibrary.NavigationListItem>();
        
        for (ACN_NavigationLibrary.NavigationListItem navItem : templateItems) {
            ACN_NavigationLibrary.NavigationListItem newItem = new ACN_NavigationLibrary.NavigationListItem();
            newItem = (ACN_NavigationLibrary.NavigationListItem)JSON.deserialize(JSON.serialize(navItem), ACN_NavigationLibrary.NavigationListItem.class);
            
            for (String key : mergeVariablesMap.keySet()) {
                if (!String.isBlank(newItem.Name) && newItem.Name.contains('{!' + key + '}')) {
                    newItem.Name = newItem.Name.replace('{!' + key + '}', mergeVariablesMap.get(key));
                }
                if (!String.isBlank(newItem.Description) && newItem.Description.contains('{!' + key + '}')) {
                    newItem.Description = newItem.Description.replace('{!' + key + '}', mergeVariablesMap.get(key));
                }
                if (!String.isBlank(newItem.GroupName) && newItem.GroupName.contains('{!' + key + '}')) {
                    newItem.GroupName = newItem.GroupName.replace('{!' + key + '}', mergeVariablesMap.get(key));
                }
                if (!String.isBlank(newItem.SerializedNavigationTargetVariable) && newItem.SerializedNavigationTargetVariable.contains('{!' + key + '}')) {
                    newItem.SerializedNavigationTargetVariable = newItem.SerializedNavigationTargetVariable.replace('{!' + key + '}', mergeVariablesMap.get(key));
                }
            }
            
            mergedItems.add(newItem);
        }
        return mergedItems;
    }

 

    global ACN_NavigationLibrary.NavigationList GoUp (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
    
    global ACN_NavigationLibrary.NavigationList GoPrevious (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
    
    global ACN_NavigationLibrary.NavigationList GoNext (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
    
    global ACN_NavigationLibrary.NavigationList GoLast (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }

 

    global ACN_NavigationLibrary.NavigationList SavePreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
 
    global ACN_NavigationLibrary.NavigationList LoadPreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        //return null;
    }
}