public class AnimalLocator {

    Public static string getAnimalNameById(Integer Id){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + Id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        string strResp ='';
        system.debug('********response ' + response.getStatusCode());
        system.debug('********response ' + response.getBody());
        if (response.getStatusCode()==200)
        {
            Map<String, object> results = (Map<String, object>) JSON.deserializeUntyped(response.getBody());
            Map<String, object> animals = (Map<String, object>) results.get('animal');
            system.debug('REceived the following animals:' + animals);
            strResp = string.valueOf(animals.get('name'));
            system.debug('strResp>' +strResp);
        }
        
        return strResp;
        
    }
    
    
}