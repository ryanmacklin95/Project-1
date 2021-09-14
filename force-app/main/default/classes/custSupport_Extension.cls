public class custSupport_Extension {
	
    public Account myAccount {get; set;}
    public Order myOrder {get; set;}
    public Case myCase {get; set;}
    public List<SelectOption> getTopicOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','---Select Topic---'));
        options.add(new SelectOption('Comments','Comments'));
        options.add(new SelectOption('Questions','Questions'));
        options.add(new SelectOption('Concerns/Complaints','Concerns/Complaints'));
        return options; 
    } 
    public String selectedTopic{get; set;}
    public String Message{get; set;}
    
    public custSupport_Extension() {
        myAccount = new Account();
    }
    public PageReference Submit() {
        insert myAccount;
        myOrder = new Order(AccountID= myAccount.ID, EffectiveDate = System.today(), Status = 'Draft');
        myCase = new Case(Status = 'New', Origin = 'Web', AccountID = myAccount.ID, Description = Message, Restaurant__c = MyOrder.Restaurant__c, Subject = selectedTopic);
        insert myOrder;
        insert myCase;
        PageReference p = new PageReference('/apex/support_Success');
        p.setRedirect(True);
        return p;
    }
    public PageReference returnHome () {
        PageReference p = new pageReference('/apex/Home');
        p.setRedirect(True);
        return null;
    }
}