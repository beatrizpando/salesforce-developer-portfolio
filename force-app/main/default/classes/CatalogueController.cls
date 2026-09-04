public with sharing class CatalogueController {
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getProductos() {
        return [SELECT Id, UnitPrice, Product2.Id, Product2.Name, Product2.Description
            FROM PricebookEntry
            WHERE IsActive = true AND Pricebook2.IsStandard = true AND Product2.IsActive = true
            WITH SECURITY_ENFORCED
            ORDER BY Product2.Name ASC
            LIMIT 200
            ];
    }
}