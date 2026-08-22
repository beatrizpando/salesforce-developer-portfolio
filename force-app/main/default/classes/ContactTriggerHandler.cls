public with sharing class ContactTriggerHandler {

    public ContactTriggerHandler() {}

    public void copyAccOwn(List<Contact> contactToChangeOwnerIds){

        Map<Id, Account> padreAccs = new Map<Id, Account>();
        //Coleccion de acc.OwnerId que tengo que usar
        Set<Id> accountIdsAsociadas = new Set<Id>();

        //Aqui nos aseguramos de que los contactos tengan una cuenta asignada de donde poder extraer el acc.OwnerId despues
        for(Contact con : contactToChangeOwnerIds){
            if (con.AccountId != null) {
                accountIdsAsociadas.add(con.AccountId);                
            }
        }

        System.debug('Contacto revisado');

        //Mapeo de acc con sus respectivos acc.OwnerId
        List<Account> listaCuentas = [SELECT Id, OwnerId FROM Account WHERE Id IN :accountIdsAsociadas];

        for (Account acc : listaCuentas) {
            padreAccs.put(acc.Id, acc);
        }

        for(Contact con : contactToChangeOwnerIds){
            if(con.AccountId != null && padreAccs.containsKey(con.AccountId)){
                con.OwnerId = padreAccs.get(con.AccountId).OwnerId;
            System.debug('ownerid assigments '+ con.OwnerId + '. Nombre del contacto: ' +con.LastName );
            }

        }
        


        //contemplar que hacer en caso de una cuenta que cambia de nombre: ¿el contact owner tiene que actualizarse?



    }
}