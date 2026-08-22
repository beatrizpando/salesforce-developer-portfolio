public with sharing class OpportunityTriggerHandler {
    public OpportunityTriggerHandler() {}

public void createFollowUpTask(List<Opportunity> oppWithTask){
        
        List<Opportunity> filterOpps = new List<Opportunity>();
        List<Task> tareasExistentes = new List<Task>();
        List<Id> tasksToSearchFrom = new List<Id>();
        List<Task> taskToInsert = new List<Task>();

        for (Opportunity oppQueEstoyRecorriendo : oppWithTask){
            if(oppQueEstoyRecorriendo.StageName == 'Closed Won'){
                filterOpps.add(oppQueEstoyRecorriendo);
            } 
        }
        
        tareasExistentes = [SELECT Id, WhatId FROM Task WHERE WhatId IN: filterOpps];

        for(Task task : tareasExistentes){
            tasksToSearchFrom.add(task.WhatId);
        }
        System.debug('+++Esta tarea, '+ task.Subject + 'pertenece a opp '+ task.OwnerId +' de la lista de oppfiltradas de tamaño: '+ filterOpps.size());

        for (Opportunity oppSinTarea :filterOpps){
            if(!tasksToSearchFrom.contains(oppSinTarea.Id)){
                System.debug('La opp no tiene tareas');
                Task taskToCreate = new Task();
                
                taskToCreate.WhatId = oppSinTarea.Id;
                taskToCreate.OwnerId = oppSinTarea.OwnerId;
                taskToCreate.Status = 'Not Started';
                taskToCreate.Subject = 'Pendiente definir';

                taskToInsert.add(taskToCreate);
                System.debug('Se ha creado tarea nueva con Id: '+ taskToCreate.WhatId + '. Y nombre: '+ taskToCreate.Subject);
            }
        }

        if(!taskToInsert.isEmpty()){
            insert taskToInsert;
        }
    }
    
    public void addNewOppAmount (List<Opportunity> newTotalOppValue){

        Map<Id, Set<Opportunity>> accAmountperOpp = new Map<Id, Set<Opportunity>>();

        Set<Id> accAfectadas = new Set<Id>();

        for(Opportunity newOpp : newTotalOppValue){
            if(newOpp.AccountId != null){
                accAfectadas.add(newOpp.AccountId);
            }
        }

        List<Opportunity> primerFiltroOpps = [SELECT AccountId, Amount FROM Opportunity WHERE StageName ='Closed Won' AND AccountId IN:accAfectadas];
        System.debug('Oportunidades ganadas, obtenidas del primer filtro: '+ primerFiltroOpps.size());

        for (Opportunity opp : primerFiltroOpps){
            if(!accAmountperOpp.containsKey(opp.AccountId)){
                accAmountperOpp.put(opp.AccountId, new Set<Opportunity>());
            }
            accAmountperOpp.get(opp.AccountId).add(opp); 
        }
        
        //opp que ya estaban cerradas
        List<Opportunity> oldOppsClosedWon = [SELECT AccountId, Amount FROM Opportunity WHERE StageName = 'Closed Won' AND AccountId IN : accAmountperOpp.keySet()];
        System.debug('Oportunidades cerradas y ganadas '+ oldOppsClosedWon.size());

        //comprobar que no hay oportunidades duplicadas debido a la cuenta  a la que estan asociadas
        for (Opportunity oppVieja : oldOppsClosedWon){
            //
            Set<Opportunity> setMatcheo = accAmountperOpp.get(oppVieja.AccountId);
        
            Boolean canAddOppMacheada= true;
            //si encontramos una oportunidad con el mismo ID, salimos.
            for (Opportunity oppMatcheada : setMatcheo){
                if(oppMatcheada.Id == oppVieja.Id){
                    canAddOppMacheada = false;
                    System.debug('La opp ya existia');
                    break;
                    
                }
            }

            if(canAddOppMacheada == true){
                accAmountperOpp.get(oppVieja.AccountId).add(oppVieja);
                System.debug('La opp se añadió');
            }
          
        }   
        
        List<Account> cuentasAActualizar = new List<Account>();

        for (Id IdAccRecorrida : accAfectadas){
            
            Account acc = new Account();
            acc.Id = IdAccRecorrida;
            
            Decimal totalDinero = 0;

            Set<Opportunity> oppSet = accAmountperOpp.get(IdAccRecorrida);

            System.debug('+++ IdAccRecorrida ' + IdAccRecorrida);
            System.debug('+++ oppSet: ' + oppSet);
            //System.debug('+++ tamaño oppSet: ' + oppSet.size());

            //recorrer el mapa para sacar las cantidades
            if (accAmountperOpp.containsKey(IdAccRecorrida)) {
                for (Opportunity oppAmount : oppSet) {
                    if (oppAmount.Amount != null) {
                    totalDinero += oppAmount.Amount;
                    }
                }
            }
            //Si ninguna Opp es ClosedWon, el valor del campo es cero
            acc.Account_Lifetime_Revenue__c = totalDinero;
        
            cuentasAActualizar.add(acc);

            System.debug('Para la cuenta con ID ' + IdAccRecorrida + ', el valor total de las oportunidades ganadas es de ' + totalDinero);
        
        }   
        if (!cuentasAActualizar.isEmpty()) {
            update cuentasAActualizar;
        }        
        
    } 

    public void checkOppStageName (List<Opportunity> oppsToCheck, Map<Id, Opportunity> oldOppsToCheckMap, Map<Id, Opportunity> newOppsToCheckMap){
        
        for (Opportunity opp: oppsToCheck){
            System.debug('oldOppsToCheckMap' + oldOppsToCheckMap);
                        
            if (oldOppsToCheckMap ==null || (oldOppsToCheckMap.get(opp.Id).StageName != newOppsToCheckMap.get(opp.Id).StageName)) {
                
                opp.Flag__c = true;

            }          
        }  
    }
}