trigger AccountCreated on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	switch on trigger.operationType {
        when BEFORE_INSERT { 
            
        }
        when BEFORE_UPDATE { 
            
        }
        when BEFORE_DELETE { 
            
        }
        when AFTER_UPDATE { 
            
        }
        when AFTER_DELETE { 
            
        }
        when AFTER_UNDELETE {
            
        }
        when AFTER_INSERT { 
            AccountCreatedHandler.sendEmail(trigger.new);
        }
    }
}