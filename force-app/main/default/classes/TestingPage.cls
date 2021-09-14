@isTest
public class TestingPage {
    /*public static void TP_ExtensionSetUp(){
Account testAccount = new Account(name = 'Sample Account', email__c = 'e@e.com');
insert testAccount;

Test.setCurrentPage(page.Project1);
Apexpages.currentPage().getParameters().put('id', testAccount.id);
ApexPages.StandardController sController = new Apexpages.StandardController(testAccount);

Extension extension = new Extension(sController);
System.AssertEquals(extension.myAccount[0].id, testAccount.id);
}*/
    
    
    public static testMethod void testRunAs() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='ee@ee.com', 
                          EmailEncodingKey='UTF-8', LastName='Joestar', FirstName = 'Joseph', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='james@king.com');
        
        System.runAs(u) {
            // The following code runs as user 'u' 
            //System.debug('Current User: ' + UserInfo.getUserName());
            //System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
    }
    @isTest
    /*public static void TP_page(){
Account testAccount = new Account(name = 'Dummy Account');


Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
User testUser = new User(Alias = 'standt', Email='ee@ee.com', 
EmailEncodingKey='UTF-8', LastName='Joestar', FirstName = 'Joseph', LanguageLocaleKey='en_US', 
LocaleSidKey='en_US', ProfileId = p.Id, 
TimeZoneSidKey='America/Los_Angeles', UserName='james@king.com');


List<Account> AccResult;
System.runAs(testUser){
Test.setCurrentPage(page.project1);

ApexPages.StandardController sController = new Apexpages.StandardController(testAccount);

Extension ProjectExtension = new Extension(sController);

Contact ConResult = ProjectExtension.getContact();
AccResult = ProjectExtension.GetAccount();
List<Order> OrResult = ProjectExtension.getOrder();
List<String> StrResult = ProjectExtension.getProductList();

}*/
    public static void TP_Controller(){
        Test.setCurrentPage(Page.Project1);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt', Email='ee@ee.com', 
                                 EmailEncodingKey='UTF-8', LastName='Joestar', FirstName = 'Joseph', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='james@king.com');
        Pricebook2 standardPB = new Pricebook2(id = Test.getStandardPricebookId(), isActive = True);
        Update standardPB;
        
        Product2 testProduct = new Product2(Name = 'Test Product', productcost__c = 100);
        Insert testProduct;
        
        PricebookEntry entry = new PricebookEntry(Pricebook2ID = standardPB.id, product2Id = testProduct.id,
                                                  unitPrice = 100, isActive = true);
        Insert Entry;
        
        Account testAccount = new Account(name = 'Test Account');
        Insert TestAccount;
        
        Order testOrder = new Order(accountid = testAccount.id, EffectiveDate = system.today(), status = 'Draft', pricebook2id = standardpb.id
                                   );
        Insert testOrder;
        
        OrderItem TestItem = new OrderItem(OrderId = testOrder.id, Quantity = 1, Product2Id = testproduct.id, pricebookEntryId = entry.id
                                           , unitPrice = entry.UnitPrice);
        Insert testItem;
        
        Contact testContact = new Contact(firstName = 'Joseph', lastName = 'Joestar', Accountid = testAccount.id, birthdate = system.today()
                                          , Phone = '(000) 000-0000', mobilephone = '(000) 000-0000', otherPhone = '(000) 000-0000');
        Insert testcontact; 
        
        List<Account> AccResult;
        System.runAs(testUser){
            Test.setCurrentPage(page.project1);
            
            PageController pcon = new PageController();
            
            Contact ConResult = pcon.getContact();
            AccResult = pcon.GetAccount();
            List<Order> OrResult = pcon.getOrder();
            List<String> StrResult = pcon.getProductList();
            List<String> rewardResult = pcon.getReward();
            
        }
        System.assertEquals(1, AccResult.size());
        
        
    }
    
}