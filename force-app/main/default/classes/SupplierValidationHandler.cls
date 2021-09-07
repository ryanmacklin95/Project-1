public class SupplierValidationHandler {
	
    public static Integer correctOrders(List<Order> newOrders){
        set<ID> orderIDs = new SET<ID>();
        set<ID> shipIDs = new SET<ID>();
        Integer added = 0;
            
        for(Order o : newOrders){
            if(o.RecordTypeId == '0125e0000007mvs'){
                o.Type = 'Supply';
            }else{
				o.Type = 'Customer';                
            }
            System.debug(o.Type);
            if(!(o.Shipment__c == NULL)){
                if(o.RecordTypeId == '0125e0000007mvs'){
                    added++;
                    continue;
                }else{
                    o.addError('This order is not a supply order.');
                }
            }
        }
        
        return added;
    }
}