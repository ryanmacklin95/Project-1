public class RestaurantController {
	private final List<Restaurant__c> restaurant;

    public RestaurantController() {
        restaurant = [SELECT Id, Name, Restaurant_Address__c, Restaurant_City__c, Restaurant_State__c FROM Restaurant__c];
    }

    public List<Restaurant__c> getRestaurant() {
        return restaurant;
    }
}