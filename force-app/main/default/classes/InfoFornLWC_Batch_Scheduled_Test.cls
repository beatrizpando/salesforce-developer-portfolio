@IsTest
public with sharing class InfoFornLWC_Batch_Scheduled_Test {
    @TestSetup
    static void makeData(){
        Integer scopetest = 10;
        List<Opportunity> oppList = new List<Opportunity>();

        for(Integer i=0;i<scopetest;i++){
            oppList.add(new Opportunity(
                Name = 'Test Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Flag_Bacheable__c = false));
        }

        insert oppList;
        
        Datetime fechaLogHoy = Datetime.now(); 

        for(Opportunity opp :oppList){
            Test.setCreatedDate(opp.Id, fechaLogHoy);
        }

    }

    @IsTest
    static void InfoFornLWC_Batch_Scheduled() {
        
        Test.startTest();
        
        System.schedule('Envio de mails', '0 0 0 * * ?', new InfoFornLWC_Batch_Scheduled());
        
        Test.stopTest();

        List<AsyncApexJob> apexJob = [SELECT Id, Status, JobType FROM AsyncApexJob WHERE ApexClass.Name = 'InfoFornLWC_Batch_Scheduled'];
    
        Assert.areEqual(1, apexJob.size(), 'Debería existir un Apex Job registrado.');
        System.debug('+++apexjobs ' + apexJob.size());
    }   
}