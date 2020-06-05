global with sharing class ACN_CustomObjectListViewProvider implements ACN_NavigationProviderService {
    /*








    
    
    
    final String DEFAULT_GROUP_KEY = 'defaultGroup';

    global ACN_CommunityNavigationConfig__c settings {get; set;}
    
    global ACN_CustomObjectListViewProvider() {
        settings = ACN_CommunityNavigationConfig__c.getInstance();
    }
    


    



    global ACN_NavigationLibrary.NavigationList GetNavigationList (ACN_NavigationLibrary.NavigationRequest request) {
        ACN_NavigationLibrary.NavigationList navList = new ACN_NavigationLibrary.NavigationList();
        navList.ParentId = request.Id;
        navList.IsInfiniteLoading = request.IsInfiniteLoading;
        navList.PageSize = request.PageSize;
        navList.CurrentPage = request.CurrentPage;
        navList.ItemsOffset = request.ItemsOffset;
        
        if (request.IsIdRequired && String.isBlank(request.Id)) {
            return navList;
        }

        List<ACN_NavigationItem__c> navItemsList = getNavigationItems(request);
        request.IncludeRecommendations = request.IncludeRecommendations == null ? false : request.IncludeRecommendations;
        request.UseContextForCarousel = request.UseContextForCarousel == null ? false : request.UseContextForCarousel;
        request.IsMenuItem = request.IsMenuItem == null ? false : request.IsMenuItem;

        Map<String, ACN_NavigationLibrary.NavigationFilterItem> filtersMap = new Map<String, ACN_NavigationLibrary.NavigationFilterItem>();
        String filterName = '';
        ACN_NavigationLibrary.NavigationFilterItem filterItem = new ACN_NavigationLibrary.NavigationFilterItem();
        filterItem.Id = 'ClearAll';
        filterItem.Name = 'Clear All';
        filterItem.Type = 'checkbox';
        filterItem.GroupName = 'Name';
        filterItem.Level = 1;
        filterItem.AttributeName = 'Name';
        filterItem.AttributeOperator = '=';
        filterItem.AttributeValue = '';
        filterItem.IsMultipleSelection = false;
        filterItem.IsSelected = false;
        filterItem.IsClearAll = true;
        
        filterName = filterItem.GroupName + '|' + filterItem.Name + '|' + filterItem.AttributeValue + '|' + filterItem.AttributeOperator + '|' + filterItem.AttributeValue;
        filterItem.FilterIdentifier = filterName;
        filtersMap.put(filterName, filterItem);

        Integer itemsCount = 0;

        for(ACN_NavigationItem__c navItem : navItemsList) {
            ACN_NavigationLibrary.NavigationListItem item = new ACN_NavigationLibrary.NavigationListItem();
            item.ParentId = navItem.ParentNavigationItemId__r.ContextIdentifier__c;
            item.Id = navItem.ContextIdentifier__c;
            item.Name = ACN_NavigationLibrary.getMergedString(navItem.Name, null);
            item.Description = ACN_NavigationLibrary.getMergedString(navItem.Description__c, null);
            item.Code = navItem.Code__c;
            item.GroupName = navItem.GroupName__c;
            //item.LargeImageUrl = navItem.LargeImage__c;
            //item.SmallImageUrl = navItem.SmallImage__c;
            item.ImageUrl = navItem.LargeImage__c;
            if (request.BrowserFormFactor.toLowerCase() == 'phone') {
                item.ImageUrl = navItem.SmallImage__c;
            }
            if (!String.isBlank(item.ImageUrl) && item.ImageUrl.contains('{!$Resource}')) {
                //item.ImageUrl = item.ImageUrl.replace('{' + '!' + '$Resource' + '}','/sfsites/c/resource/').replace('//', '/');
                item.ImageUrl = '<img src="' + item.ImageUrl.replace('{' + '!' + '$Resource' + '}','/sfsites/c/resource/').replace('//', '/') + '" />';
                //workaround for Salesofrce adding <p> around RTF
                if (item.ImageUrl.contains('<p>')) {
                    item.ImageUrl = item.ImageUrl.replace('<p>', '').replace('</p>', '');
                }
            }
            //System.debug('\n\n\n$$$$$$$item.ImageUrl: ' + item.ImageUrl + '\n\n\n');
            item.Level = navItem.Level__c == null ? 1 : Integer.valueOf( navItem.Level__c );
            //item.Link.add('http://www.google.com/');
            //item.Link.add('http://en.wikipedia.org/');
            //item.TargetUrl = 'http://www.google.com/';
            item.StyleClassName = String.isBlank(navItem.StyleClassName__c) ? String.isBlank(this.settings.DefaultItemStyleClassName__c) ? '' : this.settings.DefaultItemStyleClassName__c : navItem.StyleClassName__c;

            item.DecorationClassItemBody = String.isBlank(navItem.DecorationClassItemBody__c) ? '' : navItem.DecorationClassItemBody__c;
            item.DecorationClassItemBodyBlock01 = String.isBlank(navItem.DecorationClassItemBodyBlock01__c) ? '' : navItem.DecorationClassItemBodyBlock01__c;
            item.DecorationClassItemBodyBlock02 = String.isBlank(navItem.DecorationClassItemBodyBlock02__c) ? '' : navItem.DecorationClassItemBodyBlock02__c;
            item.DecorationClassItemBodyBlock03 = String.isBlank(navItem.DecorationClassItemBodyBlock03__c) ? '' : navItem.DecorationClassItemBodyBlock03__c;
            
            item.NavigationType = navItem.NavigationType__c;
            item.ShowInterstitial = navItem.ShowInterstitial__c;
            item.NavigationTarget = ACN_NavigationLibrary.getMergedString(navItem.NavigationTarget__c, null);
            item.ShowInCarousel = request.IncludeRecommendations 
                                    && ( navItem.IsRecommendation__c == null ? false : navItem.IsRecommendation__c ) 
                                    && ( navItem.RecommendationExpirationDate__c == null 
                                        || navItem.RecommendationExpirationDate__c != null && System.today() < navItem.RecommendationExpirationDate__c) 
                                    && (request.UseContextForCarousel ? (request.id == navItem.ParentNavigationItemId__r.ContextIdentifier__c 
                                        || request.id == navItem.ContextIdentifier__c 
                                            && (navItem.IsIncludedInChildrenList__c == null ? false : navItem.IsIncludedInChildrenList__c)) : true );
            item.ShowInNavigationList = false;
            item.IsMenuItem = navItem.IsMenuItem__c == null ? false : navItem.IsMenuItem__c;
            item.IsDefault = navItem.IsDefault__c == null ? false : navItem.IsDefault__c;
            if (!String.isBlank(request.SelectedId) && (item.Id == request.SelectedId || item.Code == request.SelectedId || item.Name == request.SelectedId)) {
                item.IsSelected = true;
            }
            item.IsTemplateItem = navItem.IsTemplateItem__c == null ? false : navItem.IsTemplateItem__c;
            item.IsSortableItem = navItem.IsSortableItem__c == null ? false : navItem.IsSortableItem__c;
            item.IsFilterableItem = navItem.IsFilterableItem__c == null ? false : navItem.IsFilterableItem__c;
            item.IsGroupableItem = navItem.IsGroupNavigationItem__c == null ? false : navItem.IsGroupNavigationItem__c;
            
            item.ItemGridSize = request.ItemGridSize;
            if (request.ShowGroups && navItem.IsGroupNavigationItem__c) {
                item.ItemGridSize = request.GroupItemGridSize;
            }
            item.ItemGridSize = request.ItemGridSize;
            if (!String.isBlank(item.ItemGridSize)) {
                List<String> itemGridSizeArray = item.ItemGridSize.split(',');
                if(navItem.get('ItemSizeDefault__c') != null) {
                    if (!String.isBlank(navItem.ItemSizeDefault__c)) {
                        if (itemGridSizeArray.size()>0) {
                            itemGridSizeArray[0] = navItem.ItemSizeDefault__c;
                        }
                        else {
                            itemGridSizeArray.add(navItem.ItemSizeDefault__c);
                        }
                        item.ItemGridSizeDefault = itemGridSizeArray[0];
                    }
                }
                if(navItem.get('ItemSizeDesktop__c') != null) {
                    if (!String.isBlank(navItem.ItemSizeDesktop__c)) {
                        if (itemGridSizeArray.size()>1) {
                            itemGridSizeArray[1] = navItem.ItemSizeDesktop__c;
                        }
                        else {
                            itemGridSizeArray.add(navItem.ItemSizeDesktop__c);
                        }
                        item.ItemGridSizeDesktop = itemGridSizeArray[1];
                    }
                }
                if(navItem.get('ItemSizeTablet__c') != null) {
                    if (!String.isBlank(navItem.ItemSizeTablet__c)) {
                        if (itemGridSizeArray.size()>2) {
                            itemGridSizeArray[2] = navItem.ItemSizeTablet__c;
                        }
                        else {
                            itemGridSizeArray.add(navItem.ItemSizeTablet__c);
                        }
                        item.ItemGridSizeTablet = itemGridSizeArray[2];
                    }
                }
                if(navItem.get('ItemSizePhone__c') != null) {
                    if (!String.isBlank(navItem.ItemSizePhone__c)) {
                        if (itemGridSizeArray.size()>3) {
                            itemGridSizeArray[3] = navItem.ItemSizePhone__c;
                        }
                        else {
                            itemGridSizeArray.add(navItem.ItemSizePhone__c);
                        }
                        item.ItemGridSizePhone = itemGridSizeArray[3];
                    }
                }
                item.ItemGridSize = String.Join(itemGridSizeArray, ',');
            }
            
            if(String.isEmpty(request.Id)) {
                if(item.Level == request.Level) {
                    item.ShowInNavigationList = true;
                }
            }
            else if(navItem.ParentNavigationItemId__r.ContextIdentifier__c == request.Id) {
                item.ShowInNavigationList = true;
            }
            
            if (item.NavigationType == 'Event' || !String.isBlank(navItem.NavigationTargetVariables__c)) {
                item.SerializedNavigationTargetVariable = navItem.NavigationTargetVariables__c;
            }
            
            if(!String.isBlank(navItem.NavigationTargetVariables__c)) {

                String rawNavTargetVariables = navItem.NavigationTargetVariables__c;
                rawNavTargetVariables = rawNavTargetVariables.remove('\n');
                rawNavTargetVariables = rawNavTargetVariables.remove('\r');

                for(String rawPair : rawNavTargetVariables.split(';')) {
                    List<String> keyValuePair = rawPair.split(':');
                    if(keyValuePair.size() == 2) {
                        String variableValue = keyValuePair[1];
                        variableValue = variableValue.replace('{' + '!' + 'name' + '}', item.Name);
                        variableValue = variableValue.replace('{' + '!' + 'code' + '}', item.Code);
                        variableValue = variableValue.replace('{' + '!' + 'id' + '}', item.Id);
                        if (navList.items.size() > 0) {
                            variableValue = variableValue.replace('{' + '!' + 'firstItem' + '}', navList.items[0].Name);
                        }
                        else {
                            variableValue = variableValue.replace('{' + '!' + 'firstItem' + '}', item.Name);
                        }
                        
                        item.NavigationTargetVariable.put(keyValuePair[0], variableValue);
                    }
                    else {
                        //Maybe throw an exception?
                    }
                }
            }

            if (item.NavigationType == 'Record') { 
                if (this.settings != null && !String.isBlank(this.settings.RecordUrlTemplate__c)) {
                    Id recordId = navItem.Id;
                    String recordName = navItem.Name;
                    String sobjectName = item.NavigationTarget;
                    if (!String.isBlank(recordName)) {
                        recordName = recordName.toLowerCase().replace('__c','').replace('_','-').replace(' ','-');
                    }
                    if (!String.isBlank(sobjectName)) {
                        sobjectName = sobjectName.toLowerCase().replace('__c','').replace('_','-');
                    }

                    String recordUrlTemplate = this.settings.RecordUrlTemplate__c;
                    recordUrlTemplate = recordUrlTemplate.replace('{' + '!' + 'urlRecordId' + '}', recordId);
                    recordUrlTemplate = recordUrlTemplate.replace('{' + '!' + 'urlRecordName' + '}', recordName);
                    recordUrlTemplate = recordUrlTemplate.replace('{' + '!' + 'urlObjectName' + '}', sobjectName);
                    item.NavigationTarget = recordUrlTemplate;
                    if (request!= null && request.ExtendedProperty != null && request.ExtendedProperty.size() > 0) {
                        for (String key : request.ExtendedProperty.keySet()) {
                            item.NavigationTargetVariable.put(key, request.ExtendedProperty.get(key));
                        }
                        //item.NavigationTargetVariable = itemRequest.ExtendedProperty;
                    }
                }
            }

            //System.debug('$$$$ NavigationTarget: ' + item.NavigationTarget);

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
                    itemRequest.ExtendedProperty = item.NavigationTargetVariable;
                }
                
                //itemRequest.ItemDefaultGroup = to-do: get default list view for current user for the object in ItemName;
                List<ACN_NavigationLibrary.NavigationItem> itemsList = new List<ACN_NavigationLibrary.NavigationItem>();
                if (item.NavigationType == 'Topic') {
                    itemsList = ACN_NavigationLibrary.getNavigationTopics (itemRequest);
                    //System.debug('$$$$topic itemsList: ' + itemsList);
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
                 //System.debug('1111 itemsList: ' + itemsList);
            }
            
            if (item.NavigationType == 'Preview') {
                //need to find out if the target is an id. For Articles or topics could be a name
                String previewTarget = item.NavigationTarget;
                
                if((previewTarget.length() == 15 || previewTarget.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', previewTarget)) {
                    Id previewTargetId = previewTarget;
                    item.NavigationTarget = previewTargetId;
                }
                else {
                    //To-Do: figure out how to get an id from a record name?
                }                
            }
            
            item.ContentRows = 3;
            item.ContentColumns = 3;
            
            Map<Integer, Integer> rows = new Map<Integer, Integer>();
            Map<Integer, Integer> columns = new Map<Integer, Integer>();
            Integer rowNumber = 0;
            Integer columnNumber = 0;
            
            //system.debug('####### item: ' + item);

            filterItem = new ACN_NavigationLibrary.NavigationFilterItem();
            filterItem.Id = item.Id;
            filterItem.Name = Item.Name;
            filterItem.Type = 'checkbox';
            filterItem.GroupName = 'Name';
            filterItem.Level = 1;
            filterItem.AttributeName = 'Name';
            filterItem.AttributeOperator = '=';
            filterItem.AttributeValue = '\'' + item.Name + '\'';
            filterItem.IsMultipleSelection = false;
            filterItem.IsSelected = false;
            filterItem.IsClearAll = false;

            filterName = filterItem.GroupName + '|' + filterItem.Name + '|' + filterItem.AttributeValue + '|' + filterItem.AttributeOperator + '|' + filterItem.AttributeValue;
            filterItem.FilterIdentifier = filterName;
            filtersMap.put(filterName, filterItem);

            filterItem = new ACN_NavigationLibrary.NavigationFilterItem();
            filterItem.Id = item.Id;
            filterItem.Name = Item.GroupName;
            filterItem.Type = 'checkbox';
            filterItem.GroupName = 'Group';
            filterItem.Level = 1;
            filterItem.AttributeName = 'GroupName__c';
            filterItem.AttributeOperator = '=';
            filterItem.AttributeValue = '\'' + item.GroupName + '\'';
            filterItem.IsMultipleSelection = false;
            filterItem.IsSelected = false;
            filterItem.IsClearAll = false;

            filterName = filterItem.GroupName + '|' + filterItem.Name + '|' + filterItem.AttributeValue + '|' + filterItem.AttributeOperator + '|' + filterItem.AttributeValue;
            filterItem.FilterIdentifier = filterName;
            filtersMap.put(filterName, filterItem);

            if (request.ShowGroups) {
                if (item.IsGroupableItem) {
                    String description = item.Description;
                    if (!String.isBlank(description)) {
                        description = description.unescapeHtml4();
                        item.Description = description;
                    }
                    navList.GroupItems.put(item.GroupName, item);
                } 
                else {
                    if (request.PageSize == null || request.PageSize == 0 || request.PageSize > 0 && itemsCount < request.PageSize) {
                        navList.items.add(item);
                    }
                    itemsCount++;
                }
            }
            else {
                if (navItem.get('IsGroupNavigationItem__c') == null || (navItem.IsGroupNavigationItem__c == null ? true : !navItem.IsGroupNavigationItem__c)) {
                    if (request.PageSize == null || request.PageSize == 0 || request.PageSize > 0 && itemsCount < request.PageSize) {
                        navList.items.add(item);
                    }
                    itemsCount++;
                }
            }
        }

        if ( filtersMap != null && filtersMap.size() > 0 ) {
            navList.FilterItem.addAll(filtersMap.values());
        }

        navList.GroupItemGridSize = '-1,-1,-1,-1';
        navList.GroupItemGridSizeDefault = '-1';
        navList.GroupItemGridSizeDesktop = '-1';
        navList.GroupItemGridSizeTablet = '-1';
        navList.GroupItemGridSizePhone = '-1';
        
        navList.IsLastItemPresent = true;
        if (request.PageSize != null && request.PageSize > 0 && request.PageSize < itemsCount) {
            navList.IsLastItemPresent = false;
        }

        return navList;
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
        String limitClause = ' ';
        
        if(String.isEmpty(request.Id)) {
            if (request.IncludeRecommendations) {
                whereConditions.add( '( Level__c = ' + request.Level + ' OR IsRecommendation__c = true ) ');
            }
            else {
                whereConditions.add( 'Level__c = ' + request.Level + ' ');
            }
        }
        else {
            List<String> processedIds = new List<String>();
            List<String> ids = request.Id.split(String.isblank(navSettings.CSVSeparator__c) ? ',' : navSettings.CSVSeparator__c);
            for (String id : ids) {
                if (id.toLowerCase().contains('userpreferences') || id.toLowerCase().contains('rated') || id.toLowerCase().contains('visited') ) {
                    processedIds.addAll(getIdsForKeyWords(id.trim())); 
                }
                else {
                    processedIds.add(id.trim()); 
                }
            }
            
            if (request.IncludeRecommendations) {
                whereConditions.add( '( ParentNavigationItemId__r.ContextIdentifier__c = :processedIds OR IsRecommendation__c = true OR (ContextIdentifier__c = :processedIds AND IsIncludedInChildrenList__c = true) ) ');
            }
            else {
                whereConditions.add( '( ParentNavigationItemId__r.ContextIdentifier__c = :processedIds OR (ContextIdentifier__c = :processedIds AND IsIncludedInChildrenList__c = true) ) ');
            }
        }
        //

        // Always filter out inactive topics
        whereConditions.add('IsActive__c = true ');

        if(!navSettings.CanViewUnpublishedItems__c) {
            whereConditions.add('IsPublished__c = true ');
        }

        Map<String,List<String>> whereClauseConditionsMap = new Map<String,List<String>>();
        
        if (request.Filter != null && request.Filter.size()>0) {
            for (String filterString : request.Filter) {
                String[] filterParts = filterString.split(':');
                
                if (!whereClauseConditionsMap.containsKey(filterParts[0])) {
                    whereClauseConditionsMap.put(filterParts[0], new List<String>());
                }
                
                whereClauseConditionsMap.get(filterParts[0]).add(filterParts[0] + ' ' + filterParts[1] + ' ' + filterParts[2] + ' ');
            }
        }

        String whereClauseFilterCondition = '';
        for (String fieldName : whereClauseConditionsMap.keySet()) {
            whereClauseFilterCondition += 'AND ( ' + String.join ( whereClauseConditionsMap.get(fieldName), ' OR ') + ' ) ';
        }
        
        String whereClause = '';

        if (whereConditions != null && whereConditions.size()>0) {
            whereClause += 'WHERE ' + String.join ( whereConditions, ' AND ' ) + ' ';
        }

        if (!String.isBlank(whereClauseFilterCondition)) {
            if (String.isBlank(whereClause)) {
                whereClause += 'WHERE ' + whereClauseFilterCondition + ' ';
            }
            else {
                whereClause += whereClauseFilterCondition + ' ';
            }
        }

        if ( request.ShowGroups ) {
            orderClause += 'GroupName__c, Order__c, Name';
        }
        else {
            orderClause += 'Order__c, Name';
        }
        
        Boolean usePagination = false;
        Integer currentPageNumber = request.CurrentPage == null ? 1 : request.CurrentPage;
        Integer offsetNumber = request.ItemsOffset == null ? 0 : request.ItemsOffset;
        Integer limitNumber = navSettings.NavigationItemsLimit__c == null ? 50 : Integer.valueOf(navSettings.NavigationItemsLimit__c);
        Boolean isInfiniteLoading = request.IsInfiniteLoading != null ? request.IsInfiniteLoading : false;
        
        if (request.PageSize != null && request.PageSize > 0 ) {
            limitNumber = request.PageSize+10;
            usePagination = true;
        }
        limitClause += ' LIMIT ';
        limitClause += String.valueOf(limitNumber);
        if (usePagination && !isInfiniteLoading) {
            limitClause += ' OFFSET ';
            limitClause += String.valueOf(offsetNumber);
        }
        //to-do - load more
        
        String queryString = selectClause + fromClause + whereClause + orderClause + limitClause;
        //System.debug ('$$$$$$  getNavigationItems dynamic query: ' + queryString);

        List<ACN_NavigationItem__c> navigationItemsList = Database.query(queryString);

        //system.debug('$$$$$$ navigationItemsList: ' + navigationItemsList);

        return navigationItemsList;
    }
    
    private Static List<String> getIdsForKeyWords (String keyWord) {
        List<String> ids = new List<String>();
        
        //For Kevin
        //To-Do: get a list of ids based on specific keywords 
        //       special keywords examples: UserPreferences, Top__Rated, Top__Visited
        //       use the number specified in __ to select only that number of records

        //System.debug('getIdsForKeyWords keywords: ' + keywords);

        //ACN_CommunityNavigationConfig__c navSettings = ACN_CommunityNavigationConfig__c.getInstance();
        //Set<Id> knowledgeArticleVersionIds = new Set<Id>();
        //Integer articleRecordsLimit = navSettings.ArticleRecordsLimit__c == null ? 1000 : Integer.valueOf(navSettings.ArticleRecordsLimit__c);
        
        //Id networkId = Network.getNetworkId();
        //List<Topic> topicsInNetwork = [SELECT Id, Name FROM Topic WHERE NetworkId = :networkId];
        //Map<String, Id> topicIdForName = new Map<String, Id>();

        //for(Topic topic : topicsInNetwork) {
            //topicIdForName.put(topic.Name, topic.Id);
        //}

        //List<String> keywordList = keywords.split(this.csvListSeparator);
        //System.debug('Keyword list: ' + keywordList);

        //Boolean includeUserPreferences = false;
        //Boolean includeTopRated = false;
        //Boolean includeTopVisited = false;
        //Integer numberTopRated = 0;
        //Integer numberTopVisited = 0;
        //Set<Id> topicIds = new Set<Id>();
        //for(String keyword : keywordList) {
            //String lowerCaseKeyword = keyword.toLowerCase();
            //if(lowerCaseKeyword == 'userpreferences') {
                //includeUserPreferences = true;
            //} else if(lowerCaseKeyword.contains('rated')) {
                //includeTopRated = true;
                //numberTopRated = Integer.valueOf(lowerCaseKeyword.substring(0, lowerCaseKeyword.indexOf('p') + 1))
            //} else if(lowerCaseKeyword.contains('visited')) {
                //includeTopVisited = true;
            //} else {
                //topicIds.add(topicIdForName.get(keyword));
            //}
        //}

        //System.debug('topicIds: ' + topicIds);

        //List<TopicAssignment> topicAssignments = 
            //[SELECT Id, TopicId, EntityId FROM TopicAssignment 
             //WHERE NetworkId = :networkId AND TopicId IN :topicIds LIMIT 1000];

        //for(TopicAssignment assignment : topicAssignments) {
            //knowledgeArticleVersionIds.add(assignment.EntityId);
        //}

        //if(includeUserPreferences) {
            //List<User> currentUser = [SELECT Id, TopicInterests__c FROM User WHERE Id = :System.UserInfo.getUserId() LIMIT 1];
            //if(currentUser.size() == 1 && String.isNotEmpty(currentUser[0].TopicInterests__c)) {     
                //List<String> userPreferredTopics;
                //System.debug(currentUser);
                //String userInterests = currentUser[0].TopicInterests__c;
                //System.debug(userInterests);
                //userPreferredTopics = userInterests.split(';');

                //Integer numPreferredTopics = userPreferredTopics != null ? userPreferredTopics.size() : 0;
            
                //Integer minArticlesPerTopic = 0;
                //Integer remainder = 0;     
                //if(numPreferredTopics > 0) {
                    //minArticlesPerTopic = articleRecordsLimit / numPreferredTopics;
                    //remainder = Math.mod(articleRecordsLimit, numPreferredTopics);

                    //System.debug('minArticlesPerTopic: ' + minArticlesPerTopic);
                    //System.debug('remainder: ' + remainder);
                //}

                //Map<Id, List<TopicAssignment>> topicAssignmentMap = new Map<Id, List<TopicAssignment>>();

                //// Won't run if user has no preferred topics, because numPreferredTopics will be 0
                //for(Integer i=0; i<numPreferredTopics; i++) {
                    //Id nextTopicId = topicIdForName.get(userPreferredTopics.get(i));
                    //Integer limitForTopic = minArticlesPerTopic;
                    //if(i<remainder) {
                        //limitForTopic++;
                    //}
                    //System.debug('Limit for topic "' + userPreferredTopics.get(i) + '" is ' + limitForTopic);
                    //List<TopicAssignment> nextTopicAssignments = [SELECT Id, TopicId, EntityId FROM TopicAssignment WHERE NetworkId = :networkId AND TopicId = :nextTopicId LIMIT :limitForTopic];
                    //topicAssignmentMap.put(nextTopicId, nextTopicAssignments);
                //}

            

                //for(Id assignmentListId : topicAssignmentMap.keySet()) {
                    //List<TopicAssignment> nextTopicAssignments = topicAssignmentMap.get(assignmentListId);
                    //for(TopicAssignment assignment : nextTopicAssignments) {
                        //knowledgeArticleVersionIds.add(assignment.EntityId);
                    //}
                //}
            //}
        //}


        
        return ids;
    } */
}