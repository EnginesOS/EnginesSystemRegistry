module Orphans
  def orphaned_services_registry_tree
    if check_system_registry_tree
      orphans = system_registry_tree['OphanedServices']
      system_registry_tree << Tree::TreeNode.new('OphanedServices', 'Persistant Services left after Engine Deinstall') if !orphans.is_a?(Tree::TreeNode)
      system_registry_tree['OphanedServices']
    else
      false
    end
  end
  
  def orphan_lost_services
    @services_registry.get_matched_leafs(services_registry_tree, :persistent, true).each do |service_hash| 
      begin
        STDERR.puts(' Check for Orphan' + service_hash.to_s)
        find_engine_service_hash(service_hash)
        STDERR.puts(' Not Orphan' + service_hash.to_s)
      rescue
        STDERR.puts(' Found Orphan' + service_hash.to_s)
        next
      end
  end
    
  end
  # @params [Hash] Loads the varaibles from the matching orphan
  # does not save bnut just populates the content/service variables in the hash
  # return boolean
  def reparent_orphan(params)
    take_snap_shot
    if @orphan_server_registry.reparent_orphan(params)
      save_tree
    else
      unlock_tree
    end
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

  # @params [Hash] of orphan matching the params
  # return boolean
  def retrieve_orphan(params)
    @orphan_server_registry.retrieve_orphan(params)
  end

  def release_orphan(params)
    take_snap_shot
    if @orphan_server_registry.release_orphan(params)
      save_tree
    else
      unlock_tree
    end
  rescue StandardError => e
    roll_back
    raise e
    unlock_tree
  end

  def rollback_orphaned_service(params)
    take_snap_shot
    STDERR.puts(' ROLL BACK ' + params.to_s)
    orphan = @orphan_server_registry.retrieve_orphan_node(params)
    STDERR.puts(' Found ' + orphan.to_s)
    save_tree if @services_registry.remove_from_services_registry(orphan)
    unlock_tree
  rescue StandardError => e
    roll_back
    raise e
  end

  def get_orphaned_services(params)
    @orphan_server_registry.get_orphaned_services(params)
  end

end