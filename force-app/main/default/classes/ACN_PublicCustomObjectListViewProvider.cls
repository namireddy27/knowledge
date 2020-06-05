global without sharing class ACN_PublicCustomObjectListViewProvider implements ACN_NavigationProviderService {
    final String DEFAULT_GROUP_KEY = 'defaultGroup';

    global ACN_CommunityNavigationConfig__c settings {get; set;}
    
    global ACN_PublicCustomObjectListViewProvider() {
        settings = ACN_CommunityNavigationConfig__c.getInstance();
    }
    
    global ACN_NavigationLibrary.NavigationList GetNavigationList (ACN_NavigationLibrary.NavigationRequest request) {
        ACN_NavigationLibrary.NavigationList navList = new ACN_NavigationLibrary.NavigationList();
        navList.ParentId = request.Id;
        
        String staticResourcePath = this.settings.StaticResourceImagesFolder__c;

        List<ACN_NavigationItem__c> topicList = getNavigationTopics(request);

        request.IncludeRecommendations = request.IncludeRecommendations == null ? false : request.IncludeRecommendations;
        request.UseContextForCarousel = request.UseContextForCarousel == null ? false : request.UseContextForCarousel;
        request.IsMenuItem = request.IsMenuItem == null ? false : request.IsMenuItem;

        for(ACN_NavigationItem__c topic : topicList) {
            ACN_NavigationLibrary.NavigationListItem item = new ACN_NavigationLibrary.NavigationListItem();
            item.Id = topic.Id;
            item.Name = ACN_NavigationLibrary.getMergedString(topic.Name, null);
            item.Description = ACN_NavigationLibrary.getMergedString(topic.Description__c, null);
            item.Code = topic.Code__c;
            item.GroupName = topic.GroupName__c;
            //item.LargeImageUrl = topic.LargeImage__c;
            //item.SmallImageUrl = topic.SmallImage__c;
            item.ImageUrl = topic.LargeImage__c;
            if (request.BrowserFormFactor.toLowerCase() == 'phone') { 
                item.ImageUrl = topic.SmallImage__c;
            }
            if (!String.isBlank(item.ImageUrl) && item.ImageUrl.contains('static-resource:')) {
                List<String> imageUrlArray = item.ImageUrl.split(':');
                if (imageUrlArray.size() > 1) {
                    if (String.isBlank(staticResourcePath)) {
                        staticResourcePath = '{!communityPathSegment}/resource/ACN_NavigationItems/img/';
                    }
                    if (!String.isBlank(ACN_NavigationLibrary.GetCurrentCommunityId())) {
                        staticResourcePath = staticResourcePath.replace('{!communityPathSegment}', '/sfsites/c/');
                    }
                    item.ImageUrl = '<img src="' + staticResourcePath + '/' + imageUrlArray[1] + '" alt="' + item.Name + '">';
                    item.ImageUrl = item.ImageUrl.replaceAll('///', '/');
                    item.ImageUrl = item.ImageUrl.replaceAll('//', '/');
                }
            }
            
            item.Level = topic.Level__c == null ? 1 : Integer.valueOf( topic.Level__c );
            //item.Link.add('http://www.google.com/');
            //item.Link.add('http://en.wikipedia.org/');
            //item.TargetUrl = 'http://www.google.com/';
            item.StyleClassName = String.isBlank(topic.StyleClassName__c) ? String.isBlank(this.settings.DefaultItemStyleClassName__c) ? '' : this.settings.DefaultItemStyleClassName__c : topic.StyleClassName__c;
            item.NavigationType = topic.NavigationType__c;
            item.NavigationTarget = ACN_NavigationLibrary.getMergedString(topic.NavigationTarget__c, null);
            item.SerializedNavigationTargetVariable = ACN_NavigationLibrary.getMergedString(topic.NavigationTargetVariables__c, null);
            item.ShowInCarousel = request.IncludeRecommendations && ( topic.IsRecommendation__c == null ? false : topic.IsRecommendation__c ) && ( topic.RecommendationExpirationDate__c == null || topic.RecommendationExpirationDate__c != null && System.today() < topic.RecommendationExpirationDate__c) && (request.UseContextForCarousel ? request.id == topic.ParentNavigationItemId__c : true);
            item.ShowInNavigationList = false;
            item.IsMenuItem = topic.IsMenuItem__c == null ? false : topic.IsMenuItem__c;
            item.IsDefault = topic.IsDefault__c == null ? false : topic.IsDefault__c;
        
            String parentId = topic.ParentNavigationItemId__c;
            String parentCode = topic.ParentNavigationItemId__r.Code__c;
            
            if(String.isEmpty(request.Id)) {
                if(item.Level == request.Level) {
                    item.ShowInNavigationList = true;
                }
            }
            else if(parentId == request.Id || parentCode == request.Id) {
                item.ShowInNavigationList = true;
            }
            /*if(String.isEmpty(request.Id)) {
                whereConditions.add('Level__c = ' + request.Level);
            }
            else {
                whereConditions.add('ParentNavigationTopicId__c = \'' + request.Id + '\'');
            }*/
            
            if(topic.NavigationTargetVariables__c != null &&
               topic.NavigationTargetVariables__c != '') {

                item.NavigationTargetVariable = new Map<String, String>();
                String rawNavTargetVariables = topic.NavigationTargetVariables__c;
                rawNavTargetVariables = rawNavTargetVariables.remove('\n');
                rawNavTargetVariables = rawNavTargetVariables.remove('\r');

                for(String rawPair : rawNavTargetVariables.split(';')) {
                    List<String> keyValuePair = rawPair.split(':');
                    if(keyValuePair.size() == 2) {
                        String variableValue = keyValuePair[1];
                        variableValue = variableValue.replace('{' + '!' + 'name' + '}', item.Name);
                        variableValue = variableValue.replace('{' + '!' + 'code' + '}', item.Code);
                        variableValue = variableValue.replace('{' + '!' + 'id' + '}', item.Id);
                        item.NavigationTargetVariable.put(keyValuePair[0], variableValue);
                    }
                    else {
                        //Maybe throw an exception?
                    }
                }
            }

            //System.debug('$$$$ NavigationTarget: ' + item.NavigationTarget);

            if (item.NavigationType == 'Topic' 
                || item.NavigationType == 'Object'
                || item.NavigationType == 'Community') {
                ACN_NavigationLibrary.ItemRequest topicRequest = new ACN_NavigationLibrary.ItemRequest();
                topicRequest.ItemCommunityId = ACN_NavigationLibrary.GetCurrentCommunityId();
                topicRequest.ItemName = item.NavigationTarget;

                // If we have any Navigation Target variables, process them here
                if(item.NavigationTargetVariable != null) {
                    if(item.NavigationTargetVariable.containsKey(DEFAULT_GROUP_KEY)) {
                        topicRequest.ItemDefaultGroup = item.NavigationTargetVariable.get(DEFAULT_GROUP_KEY);
                    }
                }

                //topicRequest.TopicDefaultGroup = to-do: get default list view for current user for the object in TopicName;
                List<ACN_NavigationLibrary.NavigationItem> topicsList = new List<ACN_NavigationLibrary.NavigationItem>();
                if (item.NavigationType == 'Topic') {
                    topicsList = ACN_NavigationLibrary.getNavigationTopics (topicRequest);
                    //System.debug('$$$$topic topicsList: ' + topicsList);
                }
                if (item.NavigationType == 'Object') {
                    topicsList = ACN_NavigationLibrary.getObjectNavigationItems (topicRequest);
                }
                if (item.NavigationType == 'Community') {
                    topicsList = ACN_NavigationLibrary.getPageNavigationItems (topicRequest);
                }
                
                if (topicsList.size()>0) {
                    item.NavigationType = 'URL';
                    item.NavigationTarget = topicsList[0].CommunityItemURL;
                }
                 //System.debug('1111 topicsList: ' + topicsList);
            }
            
            item.ContentRows = 3;
            item.ContentColumns = 3;
            
            Map<Integer, Integer> rows = new Map<Integer, Integer>();
            Map<Integer, Integer> columns = new Map<Integer, Integer>();
            Integer rowNumber = 0;
            Integer columnNumber = 0;
            
            if (!String.isBlank(request.SelectedId) && (item.Id == request.SelectedId || item.Code == request.SelectedId || item.Name == request.SelectedId)) {
                item.IsSelected = true;
            }
            
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

    private List<ACN_NavigationItem__c> getNavigationTopics(ACN_NavigationLibrary.NavigationRequest request) {
        ACN_CommunityNavigationConfig__c navSettings = ACN_CommunityNavigationConfig__c.getInstance();
        request.IncludeRecommendations = request.IncludeRecommendations == null ? false : request.IncludeRecommendations;

        String selectClause = 'SELECT ';

        List<Schema.FieldSetMember> fieldList = 
            SObjectType.ACN_NavigationItem__c.FieldSets.getMap().get(
                navSettings.ListViewProviderQueryFieldSet__c).getFields();

        for(Integer i=0; i<fieldList.size(); i++) {
            selectClause += fieldList[i].getFieldPath();
            
            if(i < fieldList.size() - 1) {
                selectClause += ', ';
            }
        }

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
            List<Id> processedIds = new List<Id>();
            List<String> processedStringIds = new List<String>();
            List<String> ids = request.Id.split(String.isblank(navSettings.CSVSeparator__c) ? ',' : navSettings.CSVSeparator__c);
            for (String id : ids) {
                try {
                    processedIds.add(id.trim());
                }
                catch (Exception ex) {
                    processedStringIds.add(id.trim());
                }
                
                // Replace the above line with the below if/else 
                // if getIdsForKeywords gets implemented
                /*if (id.toLowerCase().contains('userpreferences') || id.toLowerCase().contains('rated') || id.toLowerCase().contains('visited') ) {
                    processedIds.addAll(getIdsForKeyWords(id.trim())); 
                }
                else {
                    processedIds.add(id.trim()); 
                }*/
            }
            
            if (request.IncludeRecommendations) {
                if (processedIds != null && processedIds.size() > 0) {
                    whereConditions.add( '( ParentNavigationTopicId__c = :processedIds AND IsRecommendation__c = true )');
                }
                else {
                    if (processedStringIds != null && processedStringIds.size() > 0) {
                        whereConditions.add( '( ParentNavigationTopicId__r.Code__c = :processedStringIds AND IsRecommendation__c = true )');
                    }
                }
            }
            else {
                if (processedIds != null && processedIds.size() > 0) {
                    whereConditions.add( 'ParentNavigationTopicId__c = :processedIds ');
                }
                else {
                    if (processedStringIds != null && processedStringIds.size() > 0) {
                        whereConditions.add( 'ParentNavigationTopicId__r.Code__c = :processedStringIds ');
                    }
                }
            }
        }

        // Always filter out inactive topics
        whereConditions.add('IsActive__c = true');

        if(!navSettings.CanViewUnpublishedItems__c) {
            whereConditions.add('IsPublished__c = true');
        }

        whereConditions.add('IsPubliclyAvailable__c = true');

        String whereClause = ' WHERE ';
        whereClause += String.join(whereConditions, ' AND ');
        /*
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
        */

        orderClause += ' GroupName__c, Order__c';
        limitClause += Integer.valueOf(navSettings.NavigationItemsLimit__c);
        
        String queryString = selectClause + fromClause + whereClause + orderClause + limitClause;
        //System.debug ('getNavigationTopics dynamic query: ' + queryString);

        return Database.query(queryString);
    }
    
    /*private Static List<String> getIdsForKeyWords (String keyWord) {
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
    }*/
}