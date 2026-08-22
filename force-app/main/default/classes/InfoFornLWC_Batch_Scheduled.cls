public with sharing class InfoFornLWC_Batch_Scheduled implements Schedulable{
    public void execute(SchedulableContext SC){

        Database.executeBatch(new InfoFormLWC_Batch(), 150);

    }
}