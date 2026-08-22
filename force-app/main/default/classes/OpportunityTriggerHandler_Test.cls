@Istest
public with sharing class OpportunityTriggerHandler_Test {
    @TestSetup
    static void makeData(){
        Account accTest1 = new Account(
            Name = 'accTest1'
        );
        Account accTest2 = new Account(
            Name = 'accTest2'
        );

        List<Account> accList = new List<Account>();
        accList.add(accTest1);
        accList.add(accTest2);

        insert accList;

        accTest1 = [SELECT Id, OwnerId, Account_Lifetime_Revenue__c FROM Account WHERE Id = :accTest1.Id];

        //opp con tarea
        //opp con stagename ClosedWOn-->LISTA DE OPP FILTRADAS A PARTIR DE LA LISTA INICIAL
        Opportunity oppClosedWonTest1 = new Opportunity(
            Name = 'oppClosedWon1',
            AccountId = accTest1.Id,
            StageName = 'Closed Won',
            Amount = 1000,
            CloseDate = Date.today().addDays(-30)
        );
        
        Opportunity oppClosedWonTest1bis = new Opportunity(
            Name = 'oppClosedWon1bis',
            AccountId = accTest1.Id,
            StageName = 'Closed Won',
            Amount = 500,
            CloseDate = Date.today().addDays(-30)
        );
        //opp con stagename closedwon SIN tarea--> a esta se le tendra que crear una tarea
        Opportunity oppClosedWonTest2 = new Opportunity(
            Name = 'oppClosedWon2',
            AccountId = accTest2.Id,
            StageName = 'Closed Won',
            Amount = 1000,
            CloseDate = Date.today().addDays(-30)
        );

        
        //esta tarea no va a pasar el primer filtro
        Opportunity oppClosedLostTest = new Opportunity(
            Name = 'oppClosedLost',
            AccountId = accTest1.Id,
            StageName = 'Closed Lost',
            Amount = 1000,
            CloseDate = Date.today().addDays(-30)
        );

        List<Opportunity> oppListMD = new List<Opportunity>();
        oppListMD.add(oppClosedWonTest1);
        oppListMD.add(oppClosedWonTest1bis);
        oppListMD.add(oppClosedWonTest2);
        oppListMD.add(oppClosedLostTest);
        
        insert oppListMD;
        oppClosedWonTest2 = [SELECT Id, OwnerId, Amount FROM Opportunity WHERE Id = :oppClosedWonTest2.Id];
        
        
        Opportunity nuevaOppGanada = new Opportunity(
            Name = 'oppTriggerInsertGanada',
            AccountId = accTest1.Id,
            StageName = 'Closed Won',
            Amount = 2000,
            CloseDate = Date.today().addDays(-1)
        );

        
        insert nuevaOppGanada; 

        //RECORRO OPPSINTAREA DE LA LISTA DE OPPFILTRADAS, y si no se encuentran
        //se crea una tarea nueva usando el oppId, oppOwnerId, not started
        //estas tareas nuevas se meten en una lista que será la que se inserte en la BBDD
        Task tareaTest = new Task(
            Subject = 'Tarea de test',
            Status = 'Not Started',
            Priority = 'Normal',
            WhatId = oppClosedWonTest1.Id, 
            OwnerId = accTest1.OwnerId,
            ActivityDate = Date.today().addDays(7)
        );

        insert tareaTest;

        update accList;
        oppClosedWonTest1bis.Amount=200;
        update oppListMD;
    }
    
    @IsTest
    static void createFollowUpTasktest() {
        
        List<Account> accountIdList = [SELECT Id, Name, OwnerId  FROM Account];
        System.debug('+++cuentas a revisar: '+ accountIdList);

        List<Opportunity> listaOppFiltradas = [SELECT Name, OwnerId, AccountId, StageName  FROM Opportunity WHERE AccountId IN :accountIdList AND StageName = 'Closed Won'];
        System.debug('+++oportunidades con tareas: ' + listaOppFiltradas);

        List<Task> tareasExistentesTest = [SELECT Id, WhatId FROM Task WHERE WhatId IN: listaOppFiltradas];

        List<Opportunity> createFollowUpTask = [SELECT Name, OwnerId, AccountId, StageName FROM Opportunity WHERE Id IN :listaOppFiltradas];

        OpportunityTriggerHandler handler = new OpportunityTriggerHandler();

        Test.startTest();
        handler.createFollowUpTask(createFollowUpTask);
        Test.stopTest();
    }

    @IsTest
    static void addNewOppAmounttest() {
        List<Account> accountIdList = [SELECT Id, Name, OwnerId, Account_Lifetime_Revenue__c  FROM Account];
        
        List<Opportunity> newTotalOppValue =[SELECT Id, Amount, AccountId FROM Opportunity WHERE AccountId IN :accountIdList AND StageName = 'Closed Won'];
        
        OpportunityTriggerHandler handler = new OpportunityTriggerHandler();

        Test.startTest();
        handler.addNewOppAmount(newTotalOppValue);
        Test.stopTest();

        Account accTest1 = [SELECT Id, Account_Lifetime_Revenue__c FROM Account WHERE Name = 'accTest1' AND Id IN : accountIdList LIMIT 1];

        Account accActualizada = [SELECT Id, Account_Lifetime_Revenue__c FROM Account WHERE Id = :accTest1.Id];

        // accTest1 ya tenía 1000 (oppClosedWon1) + 200 (oppClosedWon1bis) = 1200 Closed Won del @TestSetup,
        // más los 2000 de la nueva opp insertada = 3200
        System.assertEquals(3200, accActualizada.Account_Lifetime_Revenue__c,
            'Account_Lifetime_Revenue__c debe recalcularse como la suma de TODAS las Closed Won de la cuenta tras el insert');
    }
}
