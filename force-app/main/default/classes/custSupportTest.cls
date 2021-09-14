@isTest
public class custSupportTest {
    
    @isTest
    public static void TP_custSupport_Controller() {
        Test.setCurrentPage(Page.cust_Support);
        custSupport_Extension controller = new custSupport_Extension();
       
        controller.MyAccount.name = 'Test';
        controller.getTopicOptions();
        controller.Submit();
        
        List<Account> testAccount = [SELECT name, ID FROM Account];
        List<Case> testCase = [SELECT ContactID FROM Case];
        System.AssertEquals(testAccount[0].ID, testCase[0].AccountID);
    }
    public static void TP_Submit() {
        Test.setCurrentPage(Page.cust_Support);
        custSupport_Extension controller = new custSupport_Extension();
        
        Test.setCurrentPageReference(controller.Submit());
        System.assertEquals(Page.support_Success.getUrl(), ApexPages.currentPage().getUrl());
    }
    public static void TP_returnHome() {
        Test.setCurrentPage(Page.support_Success);
        custSupport_Extension controller = new custSupport_Extension();
        
        Test.setCurrentPageReference(controller.returnHome());
        //System.assertEquals(Page.Home.getUrl(), ApexPages.currentPage().getUrl());
    }
}