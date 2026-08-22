@IsTest
public with sharing class ContactTriggerHandler_Test {
    @TestSetup
    static void makeData(){
    //CONTACTO CON CUENTA ASOCIADA
    Account acc1 = new Account(
        Name = 'acc1'
    );

    Account acc3 = new Account(
        Name = 'acc3'
    );

    List<Account> accList = new List<Account>();
        accList.add(acc1);
        accList.add(acc3);

    insert accList;

    acc1 = [SELECT Id, OwnerId FROM Account WHERE Id = :acc1.Id];
    
    Contact con1 = new Contact(
        LastName = 'Acc1 Asignada',
        AccountId = acc1.Id,
        OwnerId = acc1.OwnerId
    );

    Contact con2 = new Contact(
        LastName = 'Sin acc Asignada'
    );

    List<Contact> conList = new List<Contact>();
        conList.add(con1);
        conList.add(con2);

    insert conList;

    

    }

    @IsTest
    static void copyAccOwn_Test() {

        
        List<Account> accountIdList = [SELECT Id, Name, OwnerId  FROM Account];
        System.debug('+++cuentas a revisar: '+ accountIdList);

        List<Contact> contactToChangeOwnerIdsTest = [SELECT OwnerId, LastName, AccountId  FROM Contact WHERE AccountId IN :accountIdList];
        System.debug('+++contactos a cambiar el ownerId: ' + contactToChangeOwnerIdsTest);

        ContactTriggerHandler handler = new ContactTriggerHandler();

        Test.startTest();
        handler.copyAccOwn(contactToChangeOwnerIdsTest);
        Test.stopTest();

    }
}