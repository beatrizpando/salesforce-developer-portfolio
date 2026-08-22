public with sharing class InfoFormLWC_Batch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        /*Date inicioDiaAnterior = date.today().addDays(-1);//00.00
        Date finalDiaAnterior = date.today();//23.59
      
        return Database.getQueryLocator ([SELECT Id, Name, Owner.Name , Owner.Email FROM Opportunity WHERE Flag_Bacheable__c=true AND LastModifiedDate >= :inicioDiaAnterior AND LastModifiedDate <= :finalDiaAnterior]);
        */

        //CONTEXTO PRUEBA
        Date inicioDiaHoy = date.today();//00.00
        Date finalDiaHoy = date.today().addDays(1);//23.59
      
        return Database.getQueryLocator ([SELECT Id, Name, Owner.Name , Owner.Email FROM Opportunity WHERE Flag_Bacheable__c=true AND LastModifiedDate >= :inicioDiaHoy AND LastModifiedDate < :finalDiaHoy]);
        


    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<Opportunity> oppModificada = new List<Opportunity>();

        System.debug('+++Oportunidades modificadas hoy: ' + scope);
        

        for(Opportunity opp: scope){
            if(opp.Owner.Email != null){
                System.debug('+++La oportunidad tiene correo de owner: '+ opp.Owner.Email);

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {opp.Owner.Email});
                email.setPlainTextBody('Hola '+ opp.Owner.Name +'. El nombre y amount de la oportunidad con ID: '+ opp.Id + ' ha sido modificado con éxito.');
                
                emailList.add(email);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }

            //contexto prueba
            //opp.Flag_Bacheable__c = false;
            oppModificada.add(opp);
        }

        System.debug('+++emailList: '+ emailList);

        if (!emailList.isEmpty()) {
            Messaging.sendEmail(emailList);
        }
        
        if (!oppModificada.isEmpty()) {
        update oppModificada;
    }

    }
    public void finish(Database.BatchableContext bc){
        System.debug('+++El batch fue exitoso');
    }
}