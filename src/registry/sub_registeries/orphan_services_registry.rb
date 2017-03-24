class OrphanServicesRegistry < SubRegistry
  # @Methods for handling orphaned persistent services
  # module OrphanedServices
  # @ remove from both the service registry and orphan registery
  # @param params { :type_path , :service_handle}
  def release_orphan(params)
    orphan = retrieve_orphan_node(params)
    return true if remove_tree_entry(orphan)
    log_error_mesg('failed to remove tree entry for ', orphan)
  end

  def rollback_orphaned_service(params)
    clear_error
    @orphan_server_registry.rollback_orphaned_service(params)
  end

  # Saves the service_hash in the orphaned service registry
  # @return result
  def orphanate_service(params)
    add_to_ns_tp_tree_path(@registry, params, [:parent_engine], params[:service_handle])
  end

  def retrieve_orphan(params)
    return params unless params.is_a?(Hash)
    orphan = retrieve_orphan_node(params)
    return orphan.content if orphan.is_a?(Tree::TreeNode)
    orphan
  end

  # @return  orphaned_services_tree
  # @wrapper for the gui
  def orphaned_services_registry
    @registry
  end

  # @ Assign a new parent to an orphan
  # @return new service_hash
  # does not modfiey the tree
  def reparent_orphan(params)
    return params unless params.is_a?(Hash)
    orphan = retrieve_orphan_node(params)
    content = orphan.content
    content[:variables][:parent_engine] = params[:parent_engine]
    content[:parent_engine] = params[:parent_engine]
    content
  end

  # @return an [Array] of service_hashs of Orphaned persistent services match @params [Hash]
  # :path_type :publisher_namespace
  def get_orphaned_services(params)
    services = match_nstp_path_node_keys(@registry, params, [], [:parent_engine, :service_handle])
    return get_all_leafs_service_hashes(services) if services.is_a?(Tree::TreeNode)
    services
  end

  private

  def retrieve_orphan_node(params)
    match_nstp_path_node_keys(@registry, params, [], [:parent_engine, :service_handle])
  end
end
