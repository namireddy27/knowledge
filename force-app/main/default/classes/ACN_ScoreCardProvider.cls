global with sharing class ACN_ScoreCardProvider implements ACN_NavigationProviderService {
    
    final String DEFAULT_GROUP_KEY = 'defaultGroup';

    global ACN_CommunityNavigationConfig__c settings {get; set;}

    global ACN_ScoreCardProvider() {
        settings = ACN_CommunityNavigationConfig__c.getInstance();
    }

    global ACN_NavigationLibrary.NavigationList GetNavigationList (ACN_NavigationLibrary.NavigationRequest request) {
        ACN_NavigationLibrary.NavigationList navList = new ACN_NavigationLibrary.NavigationList();

        List<ACN_NavigationItem__c> navItemsList = getNavigationItems(request);
        request.IncludeRecommendations = request.IncludeRecommendations == null ? false : request.IncludeRecommendations;

        Map<String,String> currentUserInfo = ACN_CurrentUserInformation.CurrentUserInfo();

        for(ACN_NavigationItem__c navItem : navItemsList) {
            ACN_NavigationLibrary.NavigationListItem item = new ACN_NavigationLibrary.NavigationListItem();
            item.Id = navItem.ContextIdentifier__c;
            item.Name = navItem.Name;
            item.Description = replaceMergeFields(navItem.Description__c, item);
            item.Description = navItem.Description__c.replace('{' + '!' + 'pendingTransactions' + '}', '3').replace('{' + '!' + 'checkoutTransactions' + '}', '1');
            
            for (String userAttribute : currentUserInfo.keySet()) {
                if (item.Description.contains(userAttribute)) {
                    item.Description = item.Description.replace('{' + '!' + 'UserInfo.' + userAttribute + '}', currentUserInfo.get(userAttribute));
                }
            }
            
            item.Code = navItem.Code__c;
            item.GroupName = navItem.GroupName__c;
            //item.LargeImageUrl = navItem.LargeImage__c;
            //item.SmallImageUrl = navItem.SmallImage__c;
            item.ImageUrl = navItem.LargeImage__c;

            if (request.BrowserFormFactor.toLowerCase() == 'phone') {
                item.ImageUrl = navItem.SmallImage__c;
            }
            item.Level = navItem.Level__c == null ? 1 : Integer.valueOf( navItem.Level__c );
            //item.Link.add('http://www.google.com/');
            //item.Link.add('http://en.wikipedia.org/');
            //item.TargetUrl = 'http://www.google.com/';
            item.StyleClassName = String.isBlank(navItem.StyleClassName__c) ? String.isBlank(this.settings.DefaultItemStyleClassName__c) ? '' : this.settings.DefaultItemStyleClassName__c : navItem.StyleClassName__c;
            item.NavigationType = navItem.NavigationType__c;
            item.NavigationTarget = navItem.NavigationTarget__c;
            item.ShowInCarousel = request.IncludeRecommendations && ( navItem.IsRecommendation__c == null ? false : navItem.IsRecommendation__c ) && ( navItem.RecommendationExpirationDate__c == null || navItem.RecommendationExpirationDate__c != null && System.today() < navItem.RecommendationExpirationDate__c);
            item.ShowInNavigationList = false;

            if(String.isEmpty(request.Id)) {
                if(item.Level == request.Level) {
                    item.ShowInNavigationList = true;
                }
            }
            else if(navItem.ParentNavigationItemId__r.ContextIdentifier__c == request.Id) {
                item.ShowInNavigationList = true;
            }
            
            if(navItem.NavigationTargetVariables__c != null &&
               navItem.NavigationTargetVariables__c != '') {

                item.NavigationTargetVariable = new Map<String, String>();
                String rawNavTargetVariables = navItem.NavigationTargetVariables__c;
                rawNavTargetVariables = rawNavTargetVariables.remove('\n');
                rawNavTargetVariables = rawNavTargetVariables.remove('\r');

                for(String rawPair : rawNavTargetVariables.split(';')) {
                    List<String> keyValuePair = rawPair.split(':');
                    if(keyValuePair.size() == 2) {
                        item.NavigationTargetVariable.put(keyValuePair[0], keyValuePair[1]);
                    }
                    else {
                        //Maybe throw an exception?
                    }
                }
            }
                
            if (item.NavigationType == 'Topic' 
                || item.NavigationType == 'Object'
                || item.NavigationType == 'Community') {
                ACN_NavigationLibrary.ItemRequest itemRequest = new ACN_NavigationLibrary.ItemRequest();
                itemRequest.ItemCommunityId = ACN_NavigationLibrary.GetCurrentCommunityId();
                itemRequest.ItemName = item.NavigationTarget;

                // If we have any Navigation Target variables, process them here
                if(item.NavigationTargetVariable != null) {
                    if(item.NavigationTargetVariable.containsKey(DEFAULT_GROUP_KEY)) {
                        itemRequest.ItemDefaultGroup = item.NavigationTargetVariable.get(DEFAULT_GROUP_KEY);
                    }
                }

                //itemRequest.ItemDefaultGroup = to-do: get default list view for current user for the object in ItemName;
                List<ACN_NavigationLibrary.NavigationItem> itemsList = new List<ACN_NavigationLibrary.NavigationItem>();
                if (item.NavigationType == 'Topic') {
                    itemsList = ACN_NavigationLibrary.getNavigationTopics (itemRequest);
                }
                if (item.NavigationType == 'Object') {
                    itemsList = ACN_NavigationLibrary.getObjectNavigationItems (itemRequest);
                }
                if (item.NavigationType == 'Community') {
                    itemsList = ACN_NavigationLibrary.getPageNavigationItems (itemRequest);
                }
                
                if (itemsList.size()>0) {
                    item.NavigationType = 'URL';
                    item.NavigationTarget = itemsList[0].CommunityItemURL;
                }
            }
            
            item.ContentRows = 3;
            item.ContentColumns = 3;
            
            Map<Integer, Integer> rows = new Map<Integer, Integer>();
            Map<Integer, Integer> columns = new Map<Integer, Integer>();
            Integer rowNumber = 0;
            Integer columnNumber = 0;
            /*
            for(ACN_NavigationItemContent__c content : navItem.NavigationItemContent__r ) {
                if(item.ItemContent == null) {
                    item.ItemContent = new List<List<ACN_NavigationLibrary.NavigationListItemContent>>();
                }
                
                Integer rowIndex = content.SubItemIndex__c == null ? -1 : Integer.valueOf(content.SubItemIndex__c);
                Integer colIndex = content.SubItemCellIndex__c == null ? -1 : Integer.valueOf(content.SubItemCellIndex__c);
                
                if(!rows.containsKey(rowIndex)) {
                    rows.put(rowIndex, rowNumber);
                    List<ACN_NavigationLibrary.NavigationListItemContent> itemContentList = new List<ACN_NavigationLibrary.NavigationListItemContent>();
                    item.ItemContent.add(itemContentList);
                    rowNumber++;
                    columnNumber = 0;
                    columns = new Map<Integer, Integer>();
                }

                if(!columns.containsKey(colIndex)) {
                    columns.put(colIndex, columnNumber);
                    
                    ACN_NavigationLibrary.NavigationListItemContent ct = new ACN_NavigationLibrary.NavigationListItemContent();
                    ct.CellIndex = colIndex;
                    ct.Content = String.isBlank(navItem.ContentHTML__c) ? '<span>hello world</span>' : navItem.ContentHTML__c;
                    item.ItemContent[rows.get(rowIndex)].add(ct);
                    columnNumber++;
                }
            }
            */
            replaceItemMergeFields(item);

            navList.items.add(item);
        }

        return navList;
    }

    global ACN_NavigationLibrary.NavigationList GoUp (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }
    
    global ACN_NavigationLibrary.NavigationList GoPrevious (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }
    
    global ACN_NavigationLibrary.NavigationList GoNext (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }
    
    global ACN_NavigationLibrary.NavigationList GoLast (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }

    global ACN_NavigationLibrary.NavigationList SavePreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }
 
    global ACN_NavigationLibrary.NavigationList LoadPreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }

    private void replaceItemMergeFields(ACN_NavigationLibrary.NavigationListItem item) {
        /*ACN_NavigationLibrary.NavigationListItem*/
        if(item.Description != null) {
            item.Description = item.Description.replace('{!SummaryNumber}', getScore(item));
            item.Description = item.Description.replace('{!SummaryDescription}', getSummaryDescription(item));
        }

        //return item;
    }
    
    private String replaceMergeFields(String textWithMergeFields, ACN_NavigationLibrary.NavigationListItem navigationItem) {
        System.debug('textWithMergeFields = ' + textWithMergeFields);
        String result = null;

        if(textWithMergeFields != null) {
            result = textWithMergeFields.replace('{!SummaryNumber}', getScore(navigationItem));
            result = result.replace('{!SummaryDescription}', getSummaryDescription(navigationItem));
        }
        
        return result;
    }

    private String getScore(ACN_NavigationLibrary.NavigationListItem item) {
        Integer scoreNumber = 0;
        
        if (item.Name == 'Collateral') {
            //To-Do: calculate the number of what is considered collateral in the org
            scoreNumber = 5;
        }
        if (item.Name == 'Careers') {
            //To-Do: calculate the number of what is considered Careers in the org
            scoreNumber = 15;
        }
        if (item.Name == 'Training') {
            //To-Do: calculate the number of what is considered Training in the org
            scoreNumber = 1;
        }
        if (item.Name == 'Research') {
            //To-Do: calculate the number of what is considered Research in the org
            scoreNumber = 1;
        }
        if (item.Name == 'Tools') {
            //To-Do: calculate the number of what is considered Tools in the org
            scoreNumber = 2;
        }
        if (item.Name == 'HR Awards and Recognitions') {
            //To-Do: calculate the number of what is considered Training in the org
            //scoreNumber = 6;
        }
    
        if (scoreNumber == 0) {
            return '';
        }
    
        //scoreNumber = (Integer)(Math.random() * 50) + 50);
        return String.valueOf(scoreNumber);
    }

    private String getSummaryDescription(ACN_NavigationLibrary.NavigationListItem item) {
        return 'mock description';
    }

    private List<ACN_NavigationItem__c> getNavigationItems(ACN_NavigationLibrary.NavigationRequest request) {
        ACN_CommunityNavigationConfig__c navSettings = ACN_CommunityNavigationConfig__c.getInstance();
        request.IncludeRecommendations = request.IncludeRecommendations == null ? false : request.IncludeRecommendations;
        request.ShowGroups = request.ShowGroups == null ? false : request.ShowGroups;

        String selectClause = 'SELECT ContextIdentifier__c, ParentNavigationItemId__r.ContextIdentifier__c, ';

        List<Schema.FieldSetMember> fieldList = SObjectType.ACN_NavigationItem__c.FieldSets.getMap().get(navSettings.ListViewProviderQueryFieldSet__c).getFields();
        List<String> fieldNamesList = new List<String>();
        
        for(Schema.FieldSetMember fieldSetMemberElement : fieldList) {
            fieldNamesList.add(fieldSetMemberElement.getFieldPath());
        }

        selectClause += String.join(fieldNamesList, ', ') + ' ';

        String fromClause = ' FROM ACN_NavigationItem__c ';
        List<String> whereConditions = new List<String>();
        String orderClause = ' ORDER BY ';
        String limitClause = ' LIMIT ';
        
        
        if(String.isEmpty(request.Id)) {
            if (request.IncludeRecommendations) {
                whereConditions.add( '( Level__c = ' + request.Level + ' OR IsRecommendation__c = true )');
            }
            else {
                whereConditions.add( 'Level__c = ' + request.Level + ' ');
            }
        }
        else {
            if (request.IncludeRecommendations) {
                whereConditions.add( '( ParentNavigationItemId__r.ContextIdentifier__c = \'' + request.Id + '\' OR IsRecommendation__c = true )');
            }
            else {
                whereConditions.add( 'ParentNavigationItemId__r.ContextIdentifier__c = \'' + request.Id + '\' ');
            }
        }

        // Always filter out inactive items
        whereConditions.add('IsActive__c = true');

        if(!navSettings.CanViewUnpublishedItems__c) {
            whereConditions.add('IsPublished__c = true');
        }

        String whereClause = '';

        for(Integer i=0; i<whereConditions.size(); i++)
        {
            if(i == 0) {
                whereClause += ' WHERE ';
            }
            else {
                whereClause += ' AND ';
            }

            whereClause += whereConditions[i];
        }

        orderClause += ' GroupName__c, Order__c';
        limitClause += Integer.valueOf(navSettings.NavigationItemsLimit__c);
        
        String queryString = selectClause + fromClause + whereClause + orderClause + limitClause;

        return Database.query(queryString);
    }

}