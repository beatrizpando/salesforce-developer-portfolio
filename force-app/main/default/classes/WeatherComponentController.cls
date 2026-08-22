public with sharing class WeatherComponentController {
    public class WeatherResult {
        @InvocableVariable public Account accountData;
        @InvocableVariable public String mensajeClima;
    }

    public class WeatherResultLwc {
        @AuraEnabled public Account accountDataLwc; 
        @AuraEnabled public String mensajeClimaLwc; 
    }
    
    @InvocableMethod(
            label = 'Weather Account Data'
            description = 'Recibe datos desde el screen flow'
            callout = true
            category='Account'
        )

    public static List<WeatherResult> processAccountInfo(List<Account> accounts) {
        List<WeatherResult> results = new List<WeatherResult>();

        Account acc = accounts[0];
        
        REST_Account rest = new REST_Account();
        rest.getWeatherData(acc.Billing_Latitude__c, acc.Billing_Longitude__c);
        String timezoneResult = rest.getWeatherData(acc.Billing_Latitude__c, acc.Billing_Longitude__c);

        WeatherResult res = new WeatherResult();
        res.accountData = acc;
        res.mensajeClima = 'Clima en '+ timezoneResult + ': '; 
        results.add(res);

        return results;

    }

    @AuraEnabled(cacheable=true)
    public static List<WeatherResultLwc> processAccountInfoLwc(String recordId) {
        List<WeatherResultLwc> results = new List<WeatherResultLwc>();

        Account acc = [SELECT Id,  Billing_Latitude__c, Billing_Longitude__c, BillingCity FROM Account WHERE Id = :recordId LIMIT 1];
        
        REST_Account rest = new REST_Account();
        rest.getWeatherData(acc.Billing_Latitude__c, acc.Billing_Longitude__c);
        String timezoneResult = rest.getWeatherData(acc.Billing_Latitude__c, acc.Billing_Longitude__c);

        WeatherResultLwc res = new WeatherResultLwc();
        res.accountDataLwc = acc;
        res.mensajeClimaLwc = 'Clima en '+ timezoneResult + ': '; 
        results.add(res);

        System.debug('+++results' + results);

        return results;
        
    }
    @AuraEnabled(cacheable=true)
    public static void capturarRegion(String region){
        System.debug('Region capturada: ' + region);

    }
      
}
