public with sharing class InfoFormComponentController {
    public class FormResult {
        @AuraEnabled public String oppName; 
        @AuraEnabled public Decimal oppAmount; 
    }
    
    @AuraEnabled(cacheable=true)
    public static List<FormResult> infoFormComponentController(String recordId) {
        List<FormResult> result = new List<FormResult>();

        List<Opportunity> oppList = [SELECT Name, Amount FROM Opportunity WHERE Id = :recordId LIMIT 1];

        System.debug('+++info de la opp: ' + oppList);

        if (!oppList.isEmpty()) {
            Opportunity opp = oppList[0];
            FormResult res = new FormResult(); 
            res.oppName = opp.Name; 
            res.oppAmount = opp.Amount; 
            result.add(res); 
        }

        return result; 
    } 

    @AuraEnabled
    public static Boolean updateOppInfo (String recordId, String oppName, Decimal oppAmount){
        Opportunity oppToUpdate = new Opportunity(Id = recordId, Name = oppName, Amount = oppAmount, Flag_Bacheable__c = true);
        
        Boolean checkData = false;
        
        try{
            update oppToUpdate;
            checkData = true; 
            System.debug('+++ Oportunidad actualizada con éxito en la base de datos. Nuevos valores de campos: ' + oppName + '; ' + oppAmount );
            return checkData;

        } catch(Exception e){
            System.debug('Fallo al actualizar la oportunidad: ' + e.getMessage());
            throw new AuraHandledException('Error al procesar: ' + e.getMessage());
        }
    }
}
    
