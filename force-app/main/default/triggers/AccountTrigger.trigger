trigger AccountTrigger on Account (before delete, after update, after insert) {
    AccountTriggerHandler handler = new AccountTriggerHandler();
    
    Map<Id, Account> oldMap = Trigger.oldMap;
    Map<Id, Account> newMap = Trigger.newMap;

    List<Account> lstOldAcc = Trigger.old;
    List<Account> lstNewAcc = Trigger.new;
    
    if(Trigger.isBefore && Trigger.isDelete){
        handler.validateAccoundtDeletionbyOppStage(lstOldAcc);
    }
	if(Trigger.isAfter && Trigger.isInsert){
        handler.addAccRecord(lstNewAcc);
    }
        
}