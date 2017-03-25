module Orphans
  def orphaned_services_registry_tree
    clear_error
    return false if !check_system_registry_tree
    orphans = system_registry_tree['OphanedServices']
    system_registry_tree << Tree::TreeNode.new('OphanedServices', 'Persistant Services left after Engine Deinstall') if !orphans.is_a?(Tree::TreeNode)
    system_registry_tree['OphanedServices']
  end

  # @params [Hash] Loads the varaibles from the matching orphan
  # does not save bnut just populates the content/service variables in the hash
  # return boolean
  def reparent_orphan(params)
    clear_error
    @orphan_server_registry.reparent_orphan(params)
  end

  # @params [Hash] of orphan matching the params
  # return boolean
  def retrieve_orphan(params)
    clear_error
    @orphan_server_registry.retrieve_orphan(params)
  end

  def release_orphan(params)
    take_snap_shot
    begin
      @orphan_server_registry.release_orphan(params)
    rescue StandardError => e
      roll_back
      raise e
    end
  end

  def rollback_orphaned_service(params)
    clear_error
    @orphan_server_registry.rollback_orphaned_service(params)
  end

  def get_orphaned_services(params)
    clear_error
    @orphan_server_registry.get_orphaned_services(params)
  end

end