public with sharing class CartController {
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getInventory(String pricebookId) {
        List<PricebookEntry> lst = [SELECT Id, UnitPrice, Product2.Id, Product2.Name, Product2.ProductCode 
                FROM PricebookEntry 
                WHERE Pricebook2Id = :pricebookId AND IsActive = true AND Product2.IsActive = true];

        System.debug('+++PricebookEntry list size: ' + lst.size());

        return lst;
    }
}