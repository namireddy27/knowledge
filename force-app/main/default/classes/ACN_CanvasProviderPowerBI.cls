global class ACN_CanvasProviderPowerBI implements ACN_CanvasProviderService {
    global ACN_CanvasLibrary.CanvasResponse GetCanvasResponse (ACN_CanvasLibrary.CanvasRequest request) {
        ACN_CanvasLibrary.CanvasResponse response = new ACN_CanvasLibrary.CanvasResponse();
        response.Id = request.Id;
        response.ContainerId = request.ContainerId;
        response.ReferenceId = request.ReferenceId;
        response.Title = request.Title;
        response.DeveloperName = request.DeveloperName;
        response.Border = request.Border;
        response.Width = request.Width;
        response.MaxWidth = request.MaxWidth;
        response.Height = request.Height;
        response.MaxHeight = request.MaxHeight;
        response.Scrolling = request.Scrolling;
        response.DisplayLocation = request.DisplayLocation;
        response.DisplaySubLocation = request.DisplaySubLocation;
        response.Watermark = request.Watermark;
        response.DataProviderName = request.DataProviderName;
        response.IsCacheEnabled = request.IsCacheEnabled;
        response.IsDataLoadAsynchronous = request.IsDataLoadAsynchronous;
        
        List<ACN_CanvasLibrary.KeyValuePair> reportsList = new List<ACN_CanvasLibrary.KeyValuePair>();
        
        if (request.Parameter.containsKey('reportId') && request.Parameter.containsKey('reportName')) {
            ACN_CanvasLibrary.KeyValuePair report = new ACN_CanvasLibrary.KeyValuePair();
            report.key = request.Parameter.get('reportId');
            report.value = request.Parameter.get('reportName');
            reportsList.add(report);
        }
        
        response.Parameter.put('Reports', JSON.serialize(reportsList));
        response.Parameter.put('Username',UserInfo.getUserName());
        if (request.Parameter != null && request.Parameter.size() > 0) {
            for (String parameterName : request.Parameter.keySet()) {
                response.Parameter.put(parameterName, request.Parameter.get(parameterName));
            }
        }

        /*
        response.Parameter.put('reportId', '51d6cc84-4ac2-4a01-b864-6bca77c2a07e');
        response.Parameter.put('groupId', 'c686f4a3-ffa5-4333-b46d-d8f8f87b98bc');
        response.Parameter.put('datasetId', '3e55e13e-4d1b-4afd-8b4a-38b7f1932c9c');
        response.Parameter.put('reportName', 'LASH Program Portfolio POC');
        response.Parameter.put('username', 'bhuvaneswari.paladugu@lashgroup.com.coherussubscription');
        response.Parameter.put('userRole', 'User');
        response.Parameter.put('debug', 'false');
        response.Parameter.put('clientName', 'Coherus');
        response.Parameter.put('brandName', 'All');
        response.Parameter.put('programName', 'All');
        //response.Parameter.put('reportHeight', '800px');
        response.Parameter.put('reportHeight', '50vh');
        */
        
        response.SerializedParameters = JSON.serialize(response.Parameter);
        
        return response;
    }
}