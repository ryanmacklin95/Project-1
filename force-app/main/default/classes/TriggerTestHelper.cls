@isTest
public class TriggerTestHelper {
    /*public static List<Account> InsertAccounts(Integer numAcc){
        List<Account> toInsert = new List<Account>();
        
        for(Integer i = 0; i < numAcc; i++){
            toInsert.add(new Account(name = 'Customer Test Account ' + i,
                                     RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Account').getRecordTypeId(),
                                     email__c = 'default@email.com',
                                     RewardPoints__c = 0));
            toInsert.add(new Account(name = 'Supplier Test Account ' + i,
                                     RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Supplier_Account').getRecordTypeId(),
                                     email__c = 'default@email.com'));
        }
        
        Insert toInsert;
        return toInsert;
    }
    
    public static List<Account> CreateCustomerAccounts(Integer numAcc){
        List<Account> toInsert = new List<Account>();
        
        for(Integer i = 0; i < numAcc; i++){
            toInsert.add(new Account(name = 'Customer Test Account ' + i,
                                     RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Account').getRecordTypeId(),
                                     email__c = 'default@email.com',
                                     RewardPoints__c = 0));
        }
        return toInsert;
    }
    
    public static List<Account> CreateSupplierAccounts(Integer numAcc){
        List<Account> toInsert = new List<Account>();
        
        for(Integer i = 0; i < numAcc; i++){
            toInsert.add(new Account(name = 'Supplier Test Account ' + i,
                                     RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Supplier_Account').getRecordTypeId(),
                                     email__c = 'default@email.com',
                                     RewardPoints__c = 0));
        }
        return toInsert;
    }
    
    public static List<Order> CreateCustomerOrders(List<Account> orderAcc, Pricebook2 testPB){
        List<Order> toReturn = new List<Order>();
        
        for(Integer i = 0; i < orderAcc.size(); i++) {
            if(orderAcc[i].recordtypeid == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Account').getRecordTypeId()){
                toReturn.add(new Order(name = 'Customer Order #' + i,
                                        AccountID = orderAcc[i].ID,
                                        RecordTypeID = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Customer_Order').getRecordTypeId(),
                                        Status='Draft',
                                        EffectiveDate = Date.today(),
                                        Pricebook2Id = testPB.Id));
            }
        }
        return toReturn;
    }
    
    public static List<Order> InsertCustomerOrders(List<Account> orderAcc, Pricebook2 testPB){
        List<Order> toInsert = new List<Order>();
        
        for(Integer i = 0; i < orderAcc.size(); i++) {
            if(orderAcc[i].recordtypeid == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Account').getRecordTypeId()){
                toInsert.add(new Order(name = 'Customer Order #' + i,
                                        AccountID = orderAcc[i].ID,
                                        RecordTypeID = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Customer_Order').getRecordTypeId(),
                                        Status='Draft',
                                        EffectiveDate = Date.today(),
                                        Pricebook2Id = testPB.Id));
            }
        }
        
        Insert toInsert;
        return toInsert;
    }
    
    public static List<Order> InsertSupplyOrders(List<Account> orderAcc, Pricebook2 testPB){
        List<Order> toInsert = new List<Order>();
        
        for(Integer i = 0; i < orderAcc.size(); i++) {
            toInsert.add(new Order(name = 'Supply Order #' + i,
                                   	AccountID = orderAcc[i].id,
                                   	RecordTypeID = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Supply_Order').getRecordTypeId(),
                                  	Status='Draft',
                                    EffectiveDate = Date.today(),
                                    Pricebook2Id = testPB.Id));
        }
        
        Insert toInsert;
        return toInsert;
    }
    
    public static List<Order> CreateSupplyOrders(List<Account> orderAcc, Pricebook2 testPB){
        List<Order> toReturn = new List<Order>();
        
        for(Integer i = 0; i < orderAcc.size(); i++) {
            toReturn.add(new Order(name = 'Supply Order #' + i,
                                   	AccountID = orderAcc[i].id,
                                   	RecordTypeID = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Supply_Order').getRecordTypeId(),
                                  	Status='Draft',
                                    EffectiveDate = Date.today(),
                                    Pricebook2Id = testPB.Id));
        }
        return toReturn;
    }
    
    public static Pricebook2 ReturnPriceBook(List<Product2> productsToAdd){
        Id pricebookID = Test.getStandardPricebookId();
        
        List<PricebookEntry> entriesToAdd = new List<PricebookEntry>();
        List<PricebookEntry> standardEntriesToAdd = new List<PricebookEntry>();
        
        for (Integer i = 0; i < productsToAdd.size(); i++){
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookID,
                                                    Product2Id = productsToAdd[i].Id,
                                                    UnitPrice = 100,
                                                    IsActive = true);
            standardEntriesToAdd.add(pbe);
        }        
        Insert standardEntriesToAdd;
        
        Pricebook2 TestPricebook = new Pricebook2(name = 'testPriceBook', IsActive = true);
        Insert TestPricebook;
        
        for (Integer i = 0; i < productsToAdd.size(); i++){
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id = TestPricebook.Id,
                                                    Product2Id = productsToAdd[i].Id,
                                                    UnitPrice = i,
                                                    IsActive = true);
            entriesToAdd.add(pbe);
        } 
        
        Insert entriesToAdd;
        
        PriceBookEntry[] pbe2 = [SELECT unitprice FROM PriceBookEntry];
        return TestPricebook;
    }
    
    public static List<Product2> InsertProducts(Integer numProd){
        List<Product2> toReturn = new List<Product2>();
        
        for(Integer i = 0; i < numProd; i++){
            toReturn.add(new Product2(name = 'Product #' + i,
                                      ProductCost__c = i));
        }
        
        Insert toReturn;
        return toReturn;
    }
*/}