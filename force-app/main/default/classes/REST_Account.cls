global with sharing class REST_Account {
    
    global String getWeatherData(Decimal latitude, Decimal longitude){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        /*res.addHeader('Content-Type', 'application/json');*/

        System.debug('latitude' + latitude + 'longitude' + longitude);

        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.open-meteo.com/v1/forecast' + '?latitude=' + latitude + '&longitude=' + longitude + '&current=temperature_2m&timezone=auto');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = h.send(request);

        /*response.responseBody = Blob.valueOf(response.getBody()); */
        System.debug('+++res.responseBody' + response.getBody());  
                
        AccWeatherWrapper weatherInfo = (AccWeatherWrapper)JSON.deserialize(response.getBody(), AccWeatherWrapper.class);
        System.debug('+++ timezone' + weatherInfo.timezone);

        return weatherInfo.timezone;

    }
    public class AccWeatherWrapper {
        public String timezone;
    }

}