public with sharing class POST_Example {
    
    public void sendPostReq() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('/AccountDML/');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        String acctToPass = JSON.serialize (wrapAccount(generateAccount()));
        System.debug('This is the account JSON::' + acctToPass);
        req.setBody(acctToPass);
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }

    private Account generateAccount(){
        Account acct= new Account();
        acct.Name = 'Hi';
        acct.Phone = '9282737382';
        return acct;
    }

    private AccountWrapper wrapAccount(Account acct){
        AccountWrapper wrapper = new AccountWrapper();
        wrapper.acct = acct;
        return wrapper;
    }
}