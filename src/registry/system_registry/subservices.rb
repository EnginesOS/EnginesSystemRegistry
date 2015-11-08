module Subservices
  
  
  def subservices_registry_tree
    clear_error
       return false if !check_system_registry_tree
       orphans = system_registry_tree['SubServices']
       system_registry_tree << Tree::TreeNode.new('SubServices', 'Services attached to Services') if !orphans.is_a?(Tree::TreeNode)
       system_registry_tree['SubServices']
     rescue StandardError => e
       log_exception(e)
       return nil
  end
   
  def all_subservices_registered_to(service_type)
    test_subservices_registry_result(@subservices_registry.all_subservices_registered_to(service_hash))
  end
  
  def find_subservice_consumers(params)
    test_subservices_registry_result(@subservices_registry.find_subservice_consumers(service_hash))
  end
  
  def get_subservices_registered_against_service(params)
    test_subservices_registry_result(@subservices_registry.get_subservices_registered_against_service(service_hash))
  end
  
  def get_subservice_entry(params)
    test_subservices_registry_result(@subservices_registry.get_subservice_entry(service_hash))
  end
  
  def subservice_is_registered?(params)
    test_subservices_registry_result(@subservices_registry.subservice_is_registered(service_hash))
  end
  
  def add_to_subservices_registry(params)
    take_snap_shot
         return save_tree if test_subservices_registry_result(@subservices_registry.add_to_subservices_registry(service_hash))
         roll_back
         return false
  end
  
  def update_attached_subservice(params)
    take_snap_shot
         return save_tree if test_subservices_registry_result(@subservices_registry.update_attached_subservice(service_hash))
         roll_back
         return false
  end
  
  def remove_from_subservices_registry()
    take_snap_shot
         return save_tree if test_subservices_registry_result(@subservices_registry.remove_from_subservices_registry(service_hash))
         roll_back
         return false
  end

end