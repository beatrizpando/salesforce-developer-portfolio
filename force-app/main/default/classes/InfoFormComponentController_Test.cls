@IsTest
public with sharing class InfoFormComponentController_Test {
    @TestSetup
    static void makeData(){
                
        Opportunity testOpp = new Opportunity(
                Name = 'Test Opp',
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(-1),
                Amount = 5000.00,
                Flag_Bacheable__c = false
            );
        insert testOpp;
        
        
    }

    @IsTest
    static void infoFormComponentController_oppConId(){ //test probando opp con id

        Opportunity testOpp = [SELECT Id, Name, Amount FROM Opportunity WHERE Name = 'Test Opp'];

        Test.startTest();
        
        List<InfoFormComponentController.FormResult> result = InfoFormComponentController.infoFormComponentController(testOpp.Id);
        
        Test.stopTest();      
        //assert(esperado, real)
        //variable de la clase FormResul
        Assert.areEqual(testOpp.Name, result[0].oppName, 'El nuevo nombre no coincide.');
        Assert.areEqual(testOpp.Amount, result[0].oppAmount, 'La nueva cantidad no coincide.'); 
        
    }

    @IsTest
    static void updateOppInfo(){
        
        Opportunity testOpp = [SELECT Id, Name, Amount FROM Opportunity WHERE Name = 'Test Opp'];

        Test.startTest();
        
        Boolean result = InfoFormComponentController.updateOppInfo(testOpp.Id, 'Test Opp Modi', 100);

        Test.stopTest();

        Opportunity testOppModificada = [SELECT Id, Name, Amount FROM Opportunity WHERE Id = :testOpp.Id];

        Assert.areEqual(true, result, 'Oportunidad modificada');
        Assert.areNotEqual(testOppModificada.Name, testOpp.Name, 'Nombres de oportunidad diferentes');
        Assert.areNotEqual(testOppModificada.Amount, testOpp.Amount, 'Cantidades de oportunidad diferentes');
        
    }

}