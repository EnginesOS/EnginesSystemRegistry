module Shares
  
  
 
   def add_to_shares_registry(service_hash)
     take_snap_shot
     return save_tree if test_services_registry_result(@shares_registry.add_to_shares_registry(service_hash))
     roll_back
     return false
   end
 
 
  
end