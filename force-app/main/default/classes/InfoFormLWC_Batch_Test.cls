@IsTest
public with sharing class InfoFormLWC_Batch_Test {
    
    @TestSetup
    static void makeData(){
        Profile perfilEstandar = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User usuarioTest = new User(
            FirstName = 'name',
            LastName = 'lastname',
            Email =  'correo@salesforce.com',
            Username = 'testuser' + DateTime.now().getTime()  + '@miempresatest.com',
            Alias = 'utest', 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = perfilEstandar.Id
        );

        insert usuarioTest;

        Account accTest = new Account(
            Name = 'acc'
        );

        insert accTest;

        Opportunity oppTest = new Opportunity(
            Name = 'opp',
            OwnerId = usuarioTest.Id,
            StageName = 'Prospecting',
            Amount = 1000,
            CloseDate = Date.today().addDays(-30),    
            Flag_Bacheable__c = false 

        );

        insert oppTest;

        oppTest.Flag_Bacheable__c = true;

        update oppTest;

        Opportunity oppTestActualizada = [SELECT Name, LastModifiedDate FROM Opportunity WHERE Id = :oppTest.Id];

        System.debug('OppName: '+ oppTestActualizada.Name +'. Fecha modificacion de la opp: ' + oppTestActualizada.LastModifiedDate);
              
    }

    @IsTest
    static void testbatch(){


        Test.startTest();

        InfoFormLWC_Batch batch = new InfoFormLWC_Batch();
        Database.executeBatch(batch, 5);

        Test.stopTest();

        
    }
}