public with sharing class AccountTriggerHandler {


    public void validateAccoundtDeletionbyOppStage(List<Account> accsToCheck){
        
        Map<Id,List<Opportunity>> oppsByAccount = new Map<Id,List<Opportunity>>(); 
        List<Account> accsToDelete = new List<Account>();

        List<Opportunity> opps = [SELECT AccountId, StageName FROM Opportunity WHERE  AccountId  IN :accsToCheck];
        System.debug('+++ Oportunidades vinculadas a la lista que recibe el metodo: ' + opps.size() + '. Son:' + opps);
        

        for (Opportunity opp : opps){
            if(!oppsByAccount.containsKey(opp.AccountId)){
                oppsByAccount.put(opp.AccountId, new List<Opportunity>());
            }
            oppsByAccount.get(opp.AccountId).add(opp); 
        }

        for (Id acc : oppsByAccount.keySet()){
            Boolean canDelete = true;
            for(Opportunity o : oppsByAccount.get(acc)){
                if(!(o.StageName == 'Closed Won' || o.StageName == 'Closed Lost')){
                    canDelete = false;
                    break;

                }
            }
            if(canDelete == true){
                Account accToErase = new Account(Id = acc);
                accsToDelete.add(accToErase);
                System.debug('Borrado');
                System.debug('+++Accounts que se pueden borrar porque el oppStageName no es CW o CL: ' + accsToDelete.size() + '. Son: ' + accsToDelete);
            }else{
                System.debug('Error');
            }
        }
/*
        if(!accsToDelete.isEmpty()){
            delete accsToDelete;
        }
*/            
    }

    
    public void addAccRecord(List<Account> lstAccToCheckOpp){
        Map<Id, List<Opportunity>> oppsByAcc = new Map<Id, List<Opportunity>>();
        List<Opportunity> lstOppRecord = [SELECT AccountId, Id, Name FROM Opportunity Where AccountId IN: lstAccToCheckOpp];
        System.debug('+++Esta lista ha de contener la misma cantidad que lstOppWithAcc: '+ lstOppRecord.size());
        List<Opportunity> oppList = new List<Opportunity>();
        
        System.debug('+++Lista de acc a comprobar en handler: ' + lstAccToCheckOpp.size() + '. Son: ' + lstAccToCheckOpp);

        for(Opportunity o: lstOppRecord){
            if(!oppsByAcc.containsKey(o.AccountId)){
                oppsByAcc.put(o.AccountId, new List<Opportunity>());
            }
            oppsByAcc.get(o.AccountId).add(o);
        }
        System.debug('+++Lista de oportunidades registradas en handler: ' + lstOppRecord);
        for(Account a :lstAccToCheckOpp){
            System.debug('+++datos de cuenta a ' + a.name);
            if (!oppsByAcc.containsKey(a.Id)) {
                oppList.add(new Opportunity(Name=a.name + ' Opportunity', StageName = 'Prospecting', CloseDate = System.today().addMonths(1),AccountId=a.Id));

            }
            
        }
        
        if (!oppList.isEmpty()){
            insert oppList;
        }
    }
    
}