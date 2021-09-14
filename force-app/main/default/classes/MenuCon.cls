public class MenuCon {
    public ApexPages.StandardSetController ssCon
    {
        get
        {
            if(ssCon==null)
            {
                ssCon=new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name,Description,ProductCost__c FROM Product2]));
                //ssCon.setPageSize();
            }
             return ssCon;
        }
       set;
    }
    public list <Product2> getProducts()
    {
        return(list<Product2>)ssCon.getRecords();
    }
}