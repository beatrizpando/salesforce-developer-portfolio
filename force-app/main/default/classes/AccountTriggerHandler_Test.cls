@IsTest
public with sharing class AccountTriggerHandler_Test {
    
    @TestSetup
    static void makeData(){
        //LISTA DE CUENTAS CON OPORTUNIDADES VINCULADAS EN ESTADO CLOSED WON O CLOSED LOST
        //hacer lista de oportunidades que se pueden borrar cuando campo canDelete =true
        //crear cuentas VINCULADAS a oportunidades
        Account accTest = new Account(
            Name = 'acc a borrar'
        );
        
        Account accTestNoBorrar = new Account(
            Name = 'acc a no borrar'
        );
        
        Account accSinOpp = new Account(
            Name = 'acc sin opp'
        );
        
        
        List<Account> listAcc = new List<Account>();
        listAcc.add(accTest);
        listAcc.add(accTestNoBorrar);
        listAcc.add(accSinOpp);

        
        Opportunity oppClosedWonTest = new Opportunity(
            Name = 'oppClosedWon',
            AccountId = accTest.Id,
            StageName = 'Closed Won',
            Amount = 1000,
            CloseDate = Date.today().addDays(-30)
        );

        Opportunity oppClosedLostTest = new Opportunity(
            Name = 'oppClosedLost',
            AccountId = accTest.Id,
            StageName = 'Closed Lost',
            Amount = 1000,
            CloseDate = Date.today().addDays(-30)
        );

        Opportunity oppProspectingTest = new Opportunity(
            Name = 'oppPerception Analysis',
            AccountId = accTestNoBorrar.Id,
            StageName = 'Perception Analysis',
            Amount = 1000,
            CloseDate = Date.today().addDays(-30)
        );
    
        List<Opportunity> listOpp = new List<Opportunity>();
        listOpp.add(oppClosedWonTest);
        listOpp.add(oppClosedLostTest);
        listOpp.add(oppProspectingTest);

        insert listOpp;
        System.debug('+++lista de oportunidades de test: '+ listOpp.size() + '. Son: '+listOpp);
        insert listAcc;
    }

    @IsTest
    static void validateAccoundtDeletionbyOppStageTest(){

        List<Account> accListToCheck = [SELECT Id, Name FROM Account];
        System.debug('+++Lista de acc en test: ' + accListToCheck);

        List<Opportunity> oppListTest = [SELECT AccountId, Name, StageName FROM Opportunity WHERE AccountId IN: accListToCheck AND (StageName = 'Closed Lost' OR StageName = 'Closed Won')];
        System.debug('+++oportunidades asignadas a acc: ' + oppListTest.size());
        System.debug('+++oportunidades asignadas a acc: ' + oppListTest);

        AccountTriggerHandler handler = new AccountTriggerHandler();

        Test.startTest();
        handler.validateAccoundtDeletionbyOppStage(accListToCheck);
        Test.stopTest();

        List<Account> cuentasSinBorrar = [SELECT Id, Name FROM Account WHERE Id IN: accListToCheck];
        System.debug('+++Cuentas despues de hacer el primer metodo del test: '+ cuentasSinBorrar.size());
        Assert.areEqual(3, cuentasSinBorrar.size(), 'Como se ha borrado 1 me quedan 2.');
        
    }
    
    @IsTest
    static void addAccRecordtest(){

        List<Account> lstAccToCheckOpptest = [SELECT Id, Name FROM Account];
        List<Opportunity> lstOppWithAcc = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN: lstAccToCheckOpptest];
        System.debug('+++metodo 2 test. Lista de cuentas para revisar: '+lstAccToCheckOpptest.size() + '. Y lista de opp vinculadas a cuentas: '+lstOppWithAcc.size());
        AccountTriggerHandler handler = new AccountTriggerHandler();

        Test.startTest();
        handler.addAccRecord(lstAccToCheckOpptest);
        Test.stopTest();
    }
}