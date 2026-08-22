@RestResource(UrlMapping = '/AccountDML/')

global with sharing class REST_Service {

    @HttpPost
    global static String insertAccount(Account acct) {
        insert acct;
        return acct.Id;
    
    }
}