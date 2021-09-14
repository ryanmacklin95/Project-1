public class pageController {
    private List<Schema.PicklistEntry> rewardslist;
    private List<String> rewards;
    public List<Account> myAccount {get; set;}
    private Contact myContact;
    private List<Order> myOrder;
    private List<Product2> myProduct;
    private List<String> ProductList;
    public List<wrap> wrappedData{get; set;}
    
    //query for the contact and pull the account from it 
    //get name 
    //pass in account as a parameter from Home page 
    //custom method = getAccount
    public pageController(){
        List<Schema.PicklistEntry> rewardslist = Schema.SObjectType.Order.fields.choose_Rewards__c.GetPicklistValues();
        rewards = StringList(rewardslist);
        myContact = userInfos();
        
        List<id> myAccountid = new List<id>();
        myAccountid.add(myContact.Accountid);
        myAccount = [SELECT name, email__c, rewardpoints__c FROM Account where id in: myAccountId];
        
        myOrder = [SELECT (SELECT id, orderId, Product2ID FROM OrderItems), effectiveDate, totalAmount, orderNumber FROM Order WHERE Accountid in: myAccountId];
        Map<Order, Set<Product2>> productMap = getProductMap(myOrder); 
        
        List<String> productList = new List<String>();
        
        for (Order currOrder: myOrder){
            String allProducts = '';
            System.debug(productmap.get(currOrder));
            for (Product2 currProduct: productmap.get(currOrder)){
                allProducts += currProduct.name + ', '; 
            }
            productList.add(allProducts.substring(0, allProducts.length()-2));
        }
        
        wrappedData = new List<Wrap>();
        for (Integer i = 0; i < myOrder.size(); i++){
            wrappedData.add(new Wrap(myOrder[i], productList[i]));
        }
        
        
    }
    public Contact getContact(){
        return myContact;
    }
    public List<Order> getOrder(){
        return myOrder;
    }
    public List<Account> getAccount(){
        return myAccount;
    }
    
    public List<String> getProductList(){
        return productList;
    }
    @TestVisible
    private class Wrap{
        public Order orderNumber {get; set;}
        public String totalproducts {get; set;}
        public OrderItem totalPrice {get; set;}
        
        public Wrap(Order OrderN, String TProduct){
            orderNumber = orderN;
            totalProducts = Tproduct;
        }
    }
    @TestVisible
    private Map<Order, Set<Product2>> getProductMap(List<Order> myOrder){
        
        Set<id> productId = new Set<id>();
        for (Order currOrder: myOrder){
            for (Orderitem oi: currOrder.Orderitems){
                productId.add(oi.Product2Id);
            }
        }
        List<Product2> myProduct = [SELECT name FROM Product2 WHERE id IN: productid];
        Map<Order, Set<Product2>> mapProduct = new Map<Order, Set<Product2>>();
        for (Order currOrder: myOrder){
            Set<Product2> setProduct = new Set<Product2>();
            for (OrderItem oi: currOrder.OrderItems){
                for (Product2 p2: myProduct){
                    if (p2.id == oi.product2Id){
                        setProduct.add(p2);
                        break;
                    }
                }
            }
            mapProduct.put(currOrder, setProduct);
            
        }
        return mapProduct;
        
    }
    @TestVisible
    private Contact UserInfos(){
        String firstname = userInfo.getFirstName();
        String lastName = userInfo.getLastName();
        List<Contact> thisContact = new List<Contact>();
        List<String> firstnameString = new List<String>();
        List<String> lastNameString = new List<String>();
        firstnameString.add(firstname);
        lastnameString.add(lastName);
        thisContact = [SELECT firstName, lastName, AccountId, birthDate FROM Contact WHERE firstname in: firstnameString and lastName in: lastNameString];
        return thisContact[0];
    }
    
    public List<String> StringList(List<Schema.PicklistEntry> schemaEntry){
        List<String> rewardtoStr = new List<String>();
        for(Schema.PicklistEntry i: schemaEntry){
            rewardtoStr.add(String.valueOf(i.GetValue()));
        }
        return rewardtoStr;
    }
    public List<String> getReward(){
        return rewards;
    }
}

/*
* First, create a map of Order -> OrderItem
* Then, OrderItem has a Product field
* so Loop through the orderItems of an order, put the products in a list, query for the products and put those in the map
* Order.OrderItems[index].ProductID == Product2.Id
* 
*/