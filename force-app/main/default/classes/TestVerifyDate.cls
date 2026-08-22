@isTest

private with sharing class TestVerifyDate {
	@isTest
    static void testVerifyDateWithin30Days(){
        Date primerDia = Date.today();
        Date segundoDia = Date.today().addDays(10);
        
        Date resultado = VerifyDate.CheckDates (primerDia, segundoDia);
        
        Assert.areEqual (segundoDia, resultado);
    }
    
    @isTest
    static void testVerifySetEndOfMonthDate(){
        Date primerDia = Date.today();
        Date segundoDia = Date.today().addDays(40);
        
        Date resultado = VerifyDate.CheckDates(primerDia, segundoDia);
        
        Integer totalDiasMes = Date.daysInMonth(primerDia.year(), primerDia.month());
        Date ultimoDiaDelMes = Date.newInstance(primerDia.year(), primerDia.month(), totalDiasMes);
        
        Assert.areEqual (ultimoDiaDelMes, resultado);
    }
    @isTest
    static void testVerifyPastDate(){
        Date primerDia = Date.today(); 
        Date segundoDia = Date.today().addDays(-5);
        
        Date resultado = VerifyDate.CheckDates(primerDia, segundoDia);
        
        Integer totalDiasMes = Date.daysInMonth(primerDia.year(), primerDia.month());
        Date ultimoDiaDelMes = Date.newInstance(primerDia.year(), primerDia.month(), totalDiasMes);
        
        Assert.areEqual (ultimoDiaDelMes, resultado);
    }
}