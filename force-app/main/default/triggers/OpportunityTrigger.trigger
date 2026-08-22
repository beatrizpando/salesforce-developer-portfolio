trigger OpportunityTrigger on Opportunity (after update, before update, before insert, after insert) {
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    
    Map<Id, Opportunity> oldOppMap = Trigger.oldMap;
    Map<Id, Opportunity> newOppMap = Trigger.newMap;

    List<Opportunity> lstOldOpp = Trigger.old;
    List<Opportunity> lstNewOpp = Trigger.new;

    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            handler.checkOppStageName(lstNewOpp, oldOppMap, newOppMap);
        }
        if(Trigger.isInsert){
            handler.checkOppStageName(lstNewOpp, oldOppMap, newOppMap);
        }
    }

    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            handler.createFollowUpTask(lstNewOpp);
            System.debug('Sale de createFollowUpTask');
            handler.addNewOppAmount(lstNewOpp);
            System.debug('Sale de addNewOppAmount lstNew');
        }
        if (Trigger.isInsert){
            handler.addNewOppAmount(lstNewOpp);
            System.debug('_____________');
        }
    }
    
}
    /*OpportunityTrigger: execution of AfterUpdate caused by: System.FinalException: Record is read-only 
    Class.OpportunityTriggerHandler.checkOppStageName: line 122, column 1 Trigger.OpportunityTrigger: line 14, column 1*/