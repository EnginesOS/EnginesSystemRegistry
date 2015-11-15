module Services
  
  def find_service_consumers(service_query_hash)
     clear_error
     test_services_registry_result(@services_registry.find_service_consumers(service_query_hash))
   end
 
  def get_service_entry(service_query_hash)
     clear_error
     tree_node = find_service_consumers(service_query_hash)
     return false  if !tree_node.is_a?(Tree::TreeNode)
     return tree_node.content
   end
   
 
   def add_to_services_registry(service_hash)
     take_snap_shot
     return save_tree if test_services_registry_result(@services_registry.add_to_services_registry(service_hash))
     roll_back
     return false
   end
 
   def remove_from_services_registry(service_hash)
     take_snap_shot
     return save_tree if test_services_registry_result(@services_registry.remove_from_services_registry(service_hash))
     roll_back
     return false
   end
 
   # @return an [Array] of service_hashes regsitered against the Service params[:publisher_namespace] params[:type_path]
   def get_registered_against_service(params)
     clear_error
     test_services_registry_result(@services_registry.get_registered_against_service(params))
   end
 
   def list_providers_in_use
     clear_error
     test_services_registry_result(@services_registry.list_providers_in_use)
   end
 
   def service_is_registered?(service_hash)
     clear_error
     test_services_registry_result(@services_registry.service_is_registered?(service_hash))
   end

  
end