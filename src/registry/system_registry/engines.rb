module Engines
  
  # ENGINE STUFF
 
   def find_engine_services_hashes(params)
     clear_error
     test_engines_registry_result(@managed_engines_registry.find_engine_services_hashes(params))
   end
   # Returns Treenodes
   #  def find_engine_services(params)
   #    clear_error
   #    test_engines_registry_result(@managed_engines_registry.find_engine_services(params))
   #  end
 
   def find_engine_service_hash(params)
     clear_error
     test_engines_registry_result(@managed_engines_registry.find_engine_service_hash(params))
   end
 
 #  def  get_active_persistant_services(params)
 #    clear_error
 #    test_engines_registry_result(@managed_engines_registry.get_active_persistant_services(params, false))
 #  end
   
   def get_engine_nonpersistant_services(params)
     clear_error
     p :get_engine_nonpersistant_services
     p params
     test_engines_registry_result(@managed_engines_registry.get_engine_persistance_services(params, false))
   end
 
   def get_engine_persistant_services(params)
     clear_error
     test_engines_registry_result(@managed_engines_registry.get_engine_persistance_services(params, true))
   end
 
   def remove_from_managed_engines_registry(service_hash)
     take_snap_shot
     return save_tree if test_engines_registry_result(@managed_engines_registry.remove_from_engine_registry(service_hash))
     roll_back
     return false
   end
 
   def all_engines_registered_to(service_path)
     clear_error
     test_engines_registry_result(@managed_engines_registry.all_engines_registered_to(service_path))
   end
 
   def add_to_managed_engines_registry(service_hash)
     take_snap_shot
     return save_tree if test_engines_registry_result(@managed_engines_registry.add_to_managed_engines_registry(service_hash))
     roll_back
     return false
   end
   
end