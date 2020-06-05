global with sharing class ACN_NavigationChartProvider implements ACN_NavigationProviderService {
/*    final String DEFAULT_GROUP_KEY = 'defaultGroup';

    global ACN_CommunityNavigationConfig__c settings {get; set;}
    
    global ACN_NavigationChartProvider() {
        settings = ACN_CommunityNavigationConfig__c.getInstance();
    }
    
    global ACN_NavigationLibrary.NavigationList GetNavigationList (ACN_NavigationLibrary.NavigationRequest request) {
        ACN_NavigationLibrary.NavigationList navList = new ACN_NavigationLibrary.NavigationList();

        List<ACN_NavigationItem__c> navItemsList = getNavigationItems(request);
        request.IncludeRecommendations = request.IncludeRecommendations == null ? false : request.IncludeRecommendations;
        request.UseContextForCarousel = request.UseContextForCarousel == null ? false : request.UseContextForCarousel;
        request.IsMenuItem = request.IsMenuItem == null ? false : request.IsMenuItem;

        for(ACN_NavigationItem__c navItem : navItemsList) {
            ACN_NavigationLibrary.NavigationListItem item = new ACN_NavigationLibrary.NavigationListItem();
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
            item.Level = navItem.Level__c == null ? 1 : Integer.valueOf( navItem.Level__c );
            //item.Link.add('http://www.google.com/');
            //item.Link.add('http://en.wikipedia.org/');
            //item.TargetUrl = 'http://www.google.com/';
            item.StyleClassName = String.isBlank(navItem.StyleClassName__c) ? String.isBlank(this.settings.DefaultItemStyleClassName__c) ? '' : this.settings.DefaultItemStyleClassName__c : navItem.StyleClassName__c;
            item.NavigationType = navItem.NavigationType__c;
            item.NavigationTarget = ACN_NavigationLibrary.getMergedString(navItem.NavigationTarget__c, null);
            item.ShowInCarousel = request.IncludeRecommendations && ( navItem.IsRecommendation__c == null ? false : navItem.IsRecommendation__c ) && ( navItem.RecommendationExpirationDate__c == null || navItem.RecommendationExpirationDate__c != null && System.today() < navItem.RecommendationExpirationDate__c) && (request.UseContextForCarousel ? request.id == navItem.ParentNavigationItemId__r.ContextIdentifier__c : true);
            item.ShowInNavigationList = false;
            item.IsMenuItem = navItem.IsMenuItem__c == null ? false : navItem.IsMenuItem__c;
            item.IsDefault = navItem.IsDefault__c == null ? false : navItem.IsDefault__c;
        
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

            ACN_ChartLibrary.ChartSeries chartSeries = new ACN_ChartLibrary.ChartSeries();

            chartSeries.Dataset = new List<ACN_ChartLibrary.ChartDataSet>();
            
            ACN_ChartLibrary.ChartDataSet dataSet = new ACN_ChartLibrary.ChartDataSet();
            
            if (item.Name == 'Courses') {
                chartSeries.Labels = new list<string>{'Red','Yellow','Green'};

                dataSet.Label = 'Red';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#F7464A';
                dataSet.HighlightColor = '#F7464A';
                dataSet.PointValue = new list<integer>{300};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'Green';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#46BFBD';
                dataSet.HighlightColor = '#5AD3D1';
                dataSet.PointValue = new list<integer>{50};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'Yellow';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#FDB45C';
                dataSet.HighlightColor = '#FFC870';
                dataSet.PointValue = new list<integer>{100};
                    
                chartSeries.Dataset.add(dataSet);
                item.ExtendedProperty.put('ChartType','Pie');
            }
            else if (item.Name == 'Unread Articles') {
                chartSeries.Labels = new list<string>{'Jan','Feb','Mar','Apr','May','Jun','Jul'};
                dataSet.Label = 'Internal Users';
                dataSet.FillColor = 'rgba(220,220,220,0.2)';
                dataSet.StrokeColor = 'rgba(220,220,220,1)';
                dataSet.PointColor = 'rgba(220,220,220,1)';
                dataSet.PointStrokeColor = '#fff';
                dataSet.PointHighlightFill = '#fff';
                dataSet.PointHighlightStroke = 'rgba(220,220,220,1)';
                dataSet.PointValue = new list<integer>{65, 59, 80, 81, 56, 55, 40};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'External Users';
                dataSet.FillColor = 'rgba(151,187,205,0.2)';
                dataSet.StrokeColor = 'rgba(151,187,205,1)';
                dataSet.PointColor = 'rgba(151,187,205,1)';
                dataSet.PointStrokeColor = '#fff';
                dataSet.PointHighlightFill = '#fff';
                dataSet.PointHighlightStroke = 'rgba(151,187,205,1)';
                dataSet.PointValue = new list<integer>{28, 48, 40, 19, 86, 27, 90};
                    
                chartSeries.Dataset.add(dataSet);            
                item.ExtendedProperty.put('ChartType','Line');
            }
            else if (item.Name == 'Pending Tasks') {
                chartSeries.Labels = new list<string>{'In Progress','Completed','Not Started'};
                dataSet.Label = 'In Progress';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#76ded9';
                dataSet.HighlightColor = '#76ded9';
                dataSet.PointValue = new list<integer>{1};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'Completed';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#16325c';
                dataSet.HighlightColor = '#16325c';
                dataSet.PointValue = new list<integer>{1};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'Not Started';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#00a1e0';
                dataSet.HighlightColor = '#00a1e0';
                dataSet.PointValue = new list<integer>{3};
                    
                chartSeries.Dataset.add(dataSet);
                item.ExtendedProperty.put('ChartType','Doughnut');
            }
            else if (item.Name == 'My Achievements') {
                chartSeries.Labels = new list<string>{'Sup.'};
                dataSet.Label = 'Mgr.';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#76ded9';
                dataSet.HighlightColor = '#76ded9';
                dataSet.PointValue = new list<integer>{3,10};
                    
                chartSeries.Dataset.add(dataSet);

                item.ExtendedProperty.put('ChartType','Bar');
            }
            else if (item.Name == 'New Research') {
                chartSeries.Labels = new list<string>{'Jan','Feb','Mar','Apr','May','Jun','Jul'};
                dataSet.Label = 'Internal Users';
                dataSet.FillColor = 'rgba(220,220,220,0.2)';
                dataSet.StrokeColor = 'rgba(220,220,220,1)';
                dataSet.PointColor = 'rgba(220,220,220,1)';
                dataSet.PointStrokeColor = '#fff';
                dataSet.PointHighlightFill = '#fff';
                dataSet.PointHighlightStroke = 'rgba(220,220,220,1)';
                dataSet.PointValue = new list<integer>{65, 59, 80, 81, 56, 55, 40};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'External Users';
                dataSet.FillColor = 'rgba(151,187,205,0.2)';
                dataSet.StrokeColor = 'rgba(151,187,205,1)';
                dataSet.PointColor = 'rgba(151,187,205,1)';
                dataSet.PointStrokeColor = '#fff';
                dataSet.PointHighlightFill = '#fff';
                dataSet.PointHighlightStroke = 'rgba(151,187,205,1)';
                dataSet.PointValue = new list<integer>{28, 48, 40, 19, 86, 27, 90};
                    
                chartSeries.Dataset.add(dataSet);            
                item.ExtendedProperty.put('ChartType','Radar');
            }
            else if (item.Name == 'New Tools') {
                chartSeries.Labels = new list<string>{'Sales Tools','Service Tools','Marketing Tools'};
                dataSet.Label = 'Sales Tools';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#76d9de';
                dataSet.HighlightColor = '#76d9de';
                dataSet.PointValue = new list<integer>{10};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'Service Tools';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#165c32';
                dataSet.HighlightColor = '#165c32';
                dataSet.PointValue = new list<integer>{15};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'Marketing Tools';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#00e0a1';
                dataSet.HighlightColor = '#00e0a1';
                dataSet.PointValue = new list<integer>{18};
                    
                chartSeries.Dataset.add(dataSet);
                item.ExtendedProperty.put('ChartType','Polar Area');
            }
            else if (item.Name == 'My Cases') {
                chartSeries.Labels = new list<string>{'In Progress','Closed','Not Started'};
                dataSet.Label = 'In Progress';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#FDB45C';
                dataSet.HighlightColor = '#FDB45C';
                dataSet.PointValue = new list<integer>{2};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'Completed';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#46BFBD';
                dataSet.HighlightColor = '#16325c';
                dataSet.PointValue = new list<integer>{5};
                    
                chartSeries.Dataset.add(dataSet);
                
                dataSet = new ACN_ChartLibrary.ChartDataSet();
                dataSet.Label = 'Not Started';
                chartSeries.Labels.add(dataSet.Label);
                dataSet.FillColor = '#F7464A';
                dataSet.HighlightColor = '#F7464A';
                dataSet.PointValue = new list<integer>{1};
                    
                chartSeries.Dataset.add(dataSet);
                item.ExtendedProperty.put('ChartType','Pie');
            }
                        
            item.ExtendedProperty.put('ShowChart','true');
            item.ExtendedProperty.put('ShowChartTitle','false');
            item.ExtendedProperty.put('ShowChartLegend','true');
            item.ExtendedProperty.put('ShowSeriesBubble','false');
            item.ExtendedProperty.put('XAxisFontSize','10');
            item.ExtendedProperty.put('YAxisFontSize','5');

            item.ExtendedProperty.put('ChartDataProvider','ACN_ChartDataStaticProviderPie');
            item.ExtendedProperty.put('ChartSeries',JSON.serialize(chartSeries));
            //item.ExtendedProperty.put('ChartSeries','');
            item.ExtendedProperty.put('ChartTitle',item.Name);
            item.ExtendedProperty.put('ChartId',item.Id);

            navList.items.add(item);
        }

        return navList;
    }

    global ACN_NavigationLibrary.NavigationList GoUp (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        return null;
    }
    
    global ACN_NavigationLibrary.NavigationList GoPrevious (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        return null;
    }
    
    global ACN_NavigationLibrary.NavigationList GoNext (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        return null;
    }
    
    global ACN_NavigationLibrary.NavigationList GoLast (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        return null;
    }

    global ACN_NavigationLibrary.NavigationList SavePreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        return null;
    }
 
    global ACN_NavigationLibrary.NavigationList LoadPreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
        return null;
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
                whereConditions.add( '( ParentNavigationItemId__r.ContextIdentifier__c = :processedIds OR IsRecommendation__c = true ) ');
            }
            else {
                whereConditions.add( 'ParentNavigationItemId__r.ContextIdentifier__c = :processedIds ');
            }
        }

        // Always filter out inactive topics
        whereConditions.add('IsActive__c = true ');

        if(!navSettings.CanViewUnpublishedItems__c) {
            whereConditions.add('IsPublished__c = true ');
        }

        String whereClause = '';

        if (whereConditions != null && whereConditions.size()>0) {
            whereClause += 'WHERE ' + String.join ( whereConditions, ' AND ' ) + ' ';
        }

        if ( request.ShowGroups ) {
            orderClause += 'GroupName__c, Order__c, Name';
        }
        else {
            orderClause += 'Order__c, Name';
        }
        
        limitClause += navSettings.NavigationItemsLimit__c == null ? 50 : Integer.valueOf(navSettings.NavigationItemsLimit__c);
        
        String queryString = selectClause + fromClause + whereClause + orderClause + limitClause;
        //System.debug ('$$$$$$  getNavigationItems dynamic query: ' + queryString);

        List<ACN_NavigationItem__c> navigationItemsList = Database.query(queryString);

        //system.debug('$$$$$$ navigationItemsList: ' + navigationItemsList);

        return navigationItemsList;
    }

    private Static List<String> getIdsForKeyWords (String keyWord) {
        List<String> ids = new List<String>();    
        return ids;
    }*/
}