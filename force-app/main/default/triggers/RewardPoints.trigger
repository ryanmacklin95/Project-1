trigger RewardPoints on Order (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	switch on trigger.operationType {
        when BEFORE_UPDATE { 
            
        }
        when BEFORE_DELETE { 
            
        }
        when AFTER_INSERT { 
            
        }
        when AFTER_UPDATE { 
            RewardPointsHandler.updatePoints(trigger.new);
        }
        when AFTER_DELETE { 
            
        }
        when AFTER_UNDELETE {
            
        }
        when BEFORE_INSERT { 
            SupplierValidationHandler.correctOrders(trigger.new);
        }
    }
}