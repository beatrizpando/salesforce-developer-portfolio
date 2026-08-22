@RestResource(urlMapping='/Oportunidades/*')
global  with sharing class REST_Opp {
    @HttpGet
    global static void getChangedOpportunity(){
        
        /*Http http = new http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');*/
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
                   
        List<Opportunity> listOppConFlagTrue = [SELECT Id, Name, StageName FROM Opportunity WHERE Flag__c = true]; 
        System.debug('+++listaSize' + listOppConFlagTrue.size());
        List<Id> idsParaResetear = new List<Id>();
        //2. Declaro lista de opps donde se van aguardar las opps en el formato a enviar    
        List<OppWrapper> listOppWrapper = new List<OppWrapper>();
          
        for (Opportunity oppFlagTrue : listOppConFlagTrue){
            //
            idsParaResetear.add(oppFlagTrue.Id);
            //2.1 Instanciar objeto wrapper
            OppWrapper oppW= new OppWrapper();
            //2.2. Iterar las oportunidades de la listOppConFlagTrue para añadir los datos que quiero a los campos del objeto OppWrapper
            OppW.Id = oppFlagTrue.Id;
            OppW.Name = oppFlagTrue.Name;
            OppW.StageName = oppFlagTrue.StageName;  
        
            //3. una vez pasan por el bucle, se añaden a la lista
            listOppWrapper.add(oppW);
        }
        res.responseBody = Blob.valueOf(JSON.serialize(listOppWrapper));
        /*request.setBody(JSON.serialize(listOppWrapper));
        HttpResponse response = http.send(request);*/
        System.debug('+++ respuesta enviada' + JSON.serialize(listOppWrapper));
    
        if(!idsParaResetear.isEmpty()) {
            resetFlag(idsParaResetear);
        }
    }

    

    //1. clasewrapper con tipo de variable declarada
    public class OppWrapper {
        public String Id;
        public String Name;
        public String StageName;
    }
    
    private static void resetFlag(List<Id> oppIds){

        if(oppIds == null || oppIds.isEmpty()){
            System.debug('+++LISTA VACIA');
        }

        try{
            List<Opportunity> oppParaResetear = [SELECT Id, Flag__c FROM Opportunity WHERE Id  IN :oppIds];
                        
            for(Opportunity opp: oppParaResetear){
                opp.Flag__c= false;
            }
            System.debug('+++ oppsParaResetear ' + oppParaResetear.size() + ' oportunidades.');
            update oppParaResetear;
            

        } catch(Exception e){
        System.debug('Ocurrio un error ' + e.getMessage());
        }
    }
        
}
