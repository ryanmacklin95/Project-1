@isTest
public class TriggerTest {/*
	
    @testSetup
    public static void SetupTests(){
        //Create and insert test accounts
        List<Account> accountsToInsert = new List<Account>();
        for(Integer i = 0; i < 151; i++){
            accountsToInsert.add(new Account(name = 'Default Customer Account ' + i,
                                            RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Account').getRecordTypeId(),
                                            email__c = 'default@email.com'));
            accountsToInsert.add(new Account(name = 'Default Supplier Account ' + i,
                                            RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Supplier_Account').getRecordTypeId(),
                                            email__c = 'default@email.com'));
        }
        Insert accountsToInsert; 
        
        //Create and insert test pricebook
        Pricebook2 testPriceBook = TriggerTestHelper.ReturnPriceBook(TriggerTestHelper.InsertProducts(5));
    } 
    
    @isTest
    public static void Test_RewardPoints(){
        Test.startTest();
        Pricebook2 testPriceBook = [SELECT name FROM Pricebook2 WHERE name = 'testPriceBook' LIMIT 1];
        
        /*---------------------
           Test Single User
          ---------------------*\/
       
        //Create a list of size 2, where [0] is a customer account and [1] is a supplier account
        List<Account> testAccounts = TriggerTestHelper.InsertAccounts(1);
        
        //Create customer orders for the 2 accounts
        List<Order> testCustomerOrders = TriggerTestHelper.InsertCustomerOrders(testAccounts, testPriceBook);
        
        List<Orderitem> testOrderItems = new List<Orderitem>();
        
        //Query for the $2 pricebook entry
        PriceBookEntry pbe2 = [SELECT Product2.Id, Product2.Name, unitprice FROM PriceBookEntry WHERE PriceBookEntry.unitprice = 2];

        //Update orders to include $2 item
        for(Order o : testCustomerOrders){
            OrderItem oitem = new OrderItem();
            oitem.OrderId = o.id;
            oitem.PriceBookEntryID = pbe2.Id; 
            oitem.UnitPrice = pbe2.unitprice;
            oitem.Quantity = 1;
            testOrderItems.add(oitem);
            o.StatusCode = 'Activated';
            o.Status = 'Activated';
        }
        Insert testOrderItems;
        
        
        //Update orders with order items and 'Activated' status. Triggers rewardpoints trigger on order update and updates relevant accounts
        Update testCustomerOrders;
        
        
                /*---------------------
                Test Positive Single User
                  ---------------------*\/
        
        //Test to make sure the account with the $2 order has 2 reward points
        Account resultAcc = [Select name, rewardPoints__c FROM Account WHERE name = 'Customer Test Account 0'];
        Integer result = Integer.valueOf(resultAcc.RewardPoints__c);
        
        System.assertEquals(2, result);
        
                /*---------------------
                Test Negative Single User
                  ---------------------*\/
        
        //Test to make sure the supplier account did not get any reward points
        resultAcc = [Select name, rewardPoints__c FROM Account WHERE name = 'Supplier Test Account 0'];
        result = Integer.valueOf(resultAcc.RewardPoints__c);
        
        System.assertEquals(0, result);
        
        /*---------------------
           Test Multiple Users
          ---------------------*\/
        
        //Create list of 151 customer accounts from testSetup and orders for those accounts
        List<Account> multipleUsers = [Select name, RecordTypeID, rewardpoints__c FROM Account WHERE name LIKE 'Default Customer Account%'];
        List<Order> testMultipleOrders = TriggerTestHelper.InsertCustomerOrders(multipleUsers, testPriceBook);
        
        //Create the order items used to update the orders
        List<Orderitem> testMultipleItems = new List<Orderitem>();

        //Query for $1 and $3 items
        PriceBookEntry pbe1 = [SELECT Product2.Id, Product2.Name, unitprice FROM PriceBookEntry WHERE PriceBookEntry.unitprice = 1];
        PriceBookEntry pbe3 = [SELECT Product2.Id, Product2.Name, unitprice FROM PriceBookEntry WHERE PriceBookEntry.unitprice = 3];
        
        //Update orders to include $1 and $3 item at multiple quantities that should add up to $17 total
        for(Order o : testMultipleOrders){
            OrderItem oitem1 = new OrderItem();
            oitem1.OrderId = o.id;
            oitem1.PriceBookEntryID = pbe1.Id; 
            oitem1.UnitPrice = pbe1.unitprice;
            oitem1.Quantity = 2;
            OrderItem oitem3 = new OrderItem();
            oitem3.OrderId = o.id;
            oitem3.PriceBookEntryID = pbe3.Id; 
            oitem3.UnitPrice = pbe3.unitprice;
            oitem3.Quantity = 5;
            testMultipleItems.add(oitem1);
            testMultipleItems.add(oitem3);
            o.StatusCode = 'Activated';
            o.Status = 'Activated';
        }
        Insert testMultipleItems;
        
        //Update the orders with the new items and update the rewardpoints fields for related accounts
        Update testMultipleOrders;
        
                /*---------------------
               Test Positive Multiple Users
                  ---------------------*\/
        
        //Update multipleUsers list with updated query results
        multipleUsers = [Select name, RecordTypeID, rewardpoints__c FROM Account WHERE name LIKE 'Default Customer %'];
        
        //make sure all customer accounts properly updated with the 17 reward points based on order's total amount of $17
        integer fails = 0;
        for(Account acc : multipleUsers){
            if(!(Integer.valueOf(acc.RewardPoints__c) == 17)){
                fails++;
            }
        }

        System.assertEquals(0, fails);
        
                /*---------------------
               Test Negative Multiple Users
                  ---------------------*\/
        
        //Requery to get the supplier accounts
        multipleUsers = [Select name, RecordTypeID, rewardpoints__c FROM Account WHERE name LIKE 'Default Supplier %'];
        
        //Check to make sure rewards hasn't updated any supplier accounts as it should only handle customer accounts
        integer fails2 = 0;
        for(Account acc : multipleUsers){
            if(!(Integer.valueOf(acc.RewardPoints__c) == 0)){
                fails2++;
            }
        }
        
        System.assertEquals(0, fails2);
        
        Test.stopTest();
    }
    
    @isTest
    public static void Test_SupplierValidation(){
        Test.startTest();
        
        /*---------------------
           Test Single User
          ---------------------*\/
        //Create test restaurant
        Restaurant__c testRestaurant = new Restaurant__c(Restaurant_State__c = 'VA',
                                                  		 Restaurant_Address__c = '123 Fake St');
        Insert testRestaurant;
        
        //Create a supplier account
        List<Account> supplierOrderAccs = new List<Account>();
        Account testAccount = TriggerTestHelper.InsertAccounts(1)[1];
        supplierOrderAccs.add(testAccount);
        
        
        //Create test shipment
        Shipment__c testShipment = new Shipment__c(Account__c = testAccount.Id, 
                                                   Restaurant__c = testRestaurant.Id);
        Insert testShipment;
        
        //Query pricebook to create order
        Pricebook2 testPriceBook = [SELECT name FROM Pricebook2 WHERE name = 'testPriceBook' LIMIT 1];
        
                /*---------------------
                Test Positive Single User
                  ---------------------*\/
        //Create test supply order linked to a shipment which should have no problem inserting
        Order testOrder = TriggerTestHelper.CreateSupplyOrders(supplierOrderAccs, testPriceBook)[0];
        testOrder.Shipment__c = testShipment.Id;
        
        //Counter that should = 1 after adding the order to the shipment successfully
        Integer added = 0;
        
        //Try catch block to catch a failed insert and will fail if an error is thrown
        try{
            Insert testOrder;
            added++;
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('This order is not a supply order.') ? true : false;
			System.AssertEquals(expectedExceptionThrown, false);
        }
        
        //Test that will pass if the order was added successfully
        System.assertEquals(1, added);
        
                /*---------------------
                Test Negative Single User
                  ---------------------*\/
        supplierOrderAccs = new List<Account>();
        testAccount = TriggerTestHelper.InsertAccounts(1)[0];
        supplierOrderAccs.add(testAccount);
    
        //Resetting testOrder to be set as a customer order that should fail when trying to insert it while linked to the shipment
        testOrder = TriggerTestHelper.CreateCustomerOrders(supplierOrderAccs, testPriceBook)[0];
        testOrder.Shipment__c = testShipment.Id;
        
        //Reset the orders inserted counter
        added = 0;
        
        //Try catch block to catch a failed insert and will pass if an error is properly thrown for trying to add a customer order to a shipment
        try{
            Insert testOrder;
            added++;
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('This order is not a supply order.') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
        }
        
        //Test to make sure no account was inserted
        System.assertEquals(0, added);
        
        /*---------------------
          Test Multiple Users
          ---------------------*\/
        
                /*---------------------
               Test Positive Multiple Users
                  ---------------------*\/
        supplierOrderAccs = TriggerTestHelper.CreateSupplierAccounts(151);
        Insert supplierOrderAccs;
        //Resetting testOrder to be set as a customer order that should fail when trying to insert it while linked to the shipment
        List<Order> testOrders = TriggerTestHelper.CreateSupplyOrders(supplierOrderAccs, testPriceBook);
        for(Order t : testOrders){
            t.Shipment__c = testShipment.Id;
        }
        
        //Reset the orders inserted counter
        added = 0;
        
        //Try catch block to catch a failed insert and will pass if all orders get added without error
        try{
            added = SupplierValidationHandler.correctOrders(testOrders);
        }catch(Exception e){
            Boolean expectedExceptionThrown = e.getMessage().contains('This order is not a supply order.') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
        }
        
        //Test to make sure all 151 accounts were inserted
        System.assertEquals(151, added);
        
                /*---------------------
               Test Negative Multiple Users
                  ---------------------*\/
        List<Account> customerOrderAccs = TriggerTestHelper.CreateCustomerAccounts(151);
        Insert customerOrderAccs;
        //Resetting testOrder to be set as a customer order that should fail when trying to insert it while linked to the shipment
        testOrders = TriggerTestHelper.CreateCustomerOrders(customerOrderAccs, testPriceBook);
        for(Order t : testOrders){
            t.Shipment__c = testShipment.Id;
        }
        
        //Reset the orders inserted counter
        added = 0;
        
        //Try catch block to catch a failed insert and will pass if an exception is thrown
        try{
            added = SupplierValidationHandler.correctOrders(testOrders);
        }catch(Exception e){
            Boolean expectedExceptionThrown = e.getMessage().contains('This order is not a supply order.') ? true : false;
        }
        
        //Check and makes sure no accounts were added
        System.assertEquals(0, added);
        
        Test.stopTest();
    }
    
    @isTest
    public static void Test_AccountCreated(){
        Test.startTest();
        List<Account> testAccs = new List<Account>();
        
        /*---------------------
            Test Single User
          ---------------------*\/
        
                /*---------------------
                Test Positive Single User
                  ---------------------*\/
        Account testAcc = TriggerTestHelper.CreateCustomerAccounts(1)[0];
        testAccs.add(testAcc);
		
        //Get email invocations value before inserting the account
        Integer invocations = Limits.getEmailInvocations();
        
        Database.insert(testAccs, false);
        
        //Compare the invocation value obtained before sending email with the actual invocation value after sending the email
        //If the email actually sent, there should be one more or 'invocations+1'
		system.assertEquals(invocations+1, Limits.getEmailInvocations());
        
                /*---------------------
                Test Negative Single User
                  ---------------------*\/
        testAccs = new List<Account>();
        testAcc = TriggerTestHelper.CreateSupplierAccounts(1)[0];
        testAccs.add(testAcc);
        
        //Get email invocations value before adding supplier account
        invocations = Limits.getEmailInvocations();
        Database.insert(testAccs, false);
        
        //Since supplier accounts being created does not trigger an email being sent, the value should still be the same as when we obtained the value
        //before adding the supplier account
		system.assertEquals(invocations, Limits.getEmailInvocations());
        
        /*---------------------
           Test Multiple Users
          ---------------------*\/
        
                /*---------------------
               Test Positive Multiple Users
                  ---------------------*\/
        testAccs = TriggerTestHelper.CreateCustomerAccounts(151);
		
        invocations = Limits.getEmailInvocations();
        Database.insert(testAccs, false);

        //Comparing the value of invocations before inserting the 151 accounts with the actual value after inserting the 151 accounts
        //The Messaging.sendEmail() method only calls once so it should still just be 'invocations+1'
		system.assertEquals(invocations, Limits.getEmailInvocations());
        
                /*---------------------
               Test Negative Multiple Users
                  ---------------------*\/
        testAccs = TriggerTestHelper.CreateSupplierAccounts(151);
		
        invocations = Limits.getEmailInvocations();
        Database.insert(testAccs, false);

        //Comparing the value of invocations before inserting the 151 accounts with the actual value after inserting the 151 accounts
		system.assertEquals(invocations, Limits.getEmailInvocations());    
        
        Test.stopTest();
    }
*/}