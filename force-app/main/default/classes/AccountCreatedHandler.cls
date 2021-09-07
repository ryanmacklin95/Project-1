public class AccountCreatedHandler {
	
    public static void sendEmail(List<Account> newAccs){
        try{
            List<String> emailAddresses = new List<String>();
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            for (Account a : newAccs){
                if(a.RecordTypeId == '0125e0000007mwb'){
                    emailAddresses.add(a.email__c);
                    message.toaddresses = emailAddresses;
                    message.subject = 'Account created successfully!';
                    message.plaintextbody = 'Your MaDonal account has been created! Your username is ' + a.name;
                    messages.add(message);
                }
            }
            if(messages.size() > 0){
            	Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);            
            }
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}