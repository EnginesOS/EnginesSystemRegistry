class OrphanServicesRegistry < SubRegistry
  # @Methods for handling orphaned persistant services
  # module OrphanedServices
  # @ remove from both the service registry and orphan registery
  # @param params { :type_path , :service_handle}
  def release_orphan(params)
    orphan = retrieve_orphan_node(params)
    return log_error_mesg('No Orphan found to release', params) if !orphan.is_a?(Tree::TreeNode)
    return true if remove_tree_entry(orphan)
    log_error_mesg('failed to remove tree entry for ', orphan)
  end

  # Saves the service_hash in the orphaned service registry
  # @return result
  def orphanate_service(service_hash)
    provider_tree = orphaned_services_registry[service_hash[:publisher_namespace]]
    if !provider_tree.is_a?(Tree::TreeNode)
      provider_tree = Tree::TreeNode.new(service_hash[:publisher_namespace], service_hash[:publisher_namespace])
      orphaned_services_registry << provider_tree
    end
    if service_hash.key?(:service_handle) && service_hash.key?(:type_path)
      type_node = create_type_path_node(provider_tree, service_hash[:type_path])
      # INSERT Enginename here
      engine_node = type_node[service_hash[:parent_engine]]
      if  !engine_node.is_a?(Tree::TreeNode)
        engine_node = Tree::TreeNode.new(service_hash[:parent_engine], 'Belonged to ' + service_hash[:parent_engine])
        type_node << engine_node
      end
      engine_node << Tree::TreeNode.new(service_hash[:service_handle], service_hash)
      return true
    end
    return false
  end

  def retrieve_orphan(params)
    orphan = retrieve_orphan_node(params)
    return orphan.content if orphan.is_a?(Tree::TreeNode)
    return orphan
  end

  # @return [TreeNode] of Oprhaned Serivce that matches the supplied params
  # @param params { :type_path , :service_handle}
  # @return nil on no match
  def retrieve_orphan_node(params)
    provider_tree = orphaned_services_registry[params[:publisher_namespace]]
    return log_error_mesg('No Orphan Matching publisher_namespace', params) if !provider_tree.is_a?(Tree::TreeNode) 
    type_path = params[:type_path]
    type = get_type_path_node(provider_tree, type_path)
    return log_error_mesg('No Orphan Matching type_path', params) if !type.is_a?(Tree::TreeNode)   
    types_for_engine = type[params[:parent_engine]]      
    if types_for_engine.is_a?(Array)
      types_for_engine.each do |engine_type|
        if engine_type.nil?
          log_error_mesg(' nil type in ', types_for_engine)
          next
        end
        if !engine_type[params[:service_handle]].nil?
          return type[params[:service_handle]]
        else
          log_error_mesg('params nil service_handle', params)
        end
      end
      log_error_mesg('No Matching Orphan found in search', params)
      return false
    elsif types_for_engine.nil?
      return false
    else
      orphan = types_for_engine[params[:service_handle]]
      if orphan.nil?
        log_error_mesg('No Matching Orphan', params)
        return false
      else
        return orphan
      end
    end
  end

  # @return  orphaned_services_tree
  # @wrapper for the gui
  def orphaned_services_registry
    return @registry
  end

  # @ Assign a new parent to an orphan
  # @return new service_hash
  # does not modfiey the tree
  def reparent_orphan(params)
    orphan = retrieve_orphan_node(params)
    if orphan != false
      content = orphan.content
      content[:variables][:parent_engine] = params[:parent_engine]
      content[:parent_engine] = params[:parent_engine]
      return content
    else
      log_error_mesg('No orphan found to reparent', params)
      return false
    end
  end

  # @return an [Array] of service_hashs of Orphaned persistant services match @params [Hash]
  # :path_type :publisher_namespace
  def get_orphaned_services(params)
    leafs = []
    SystemUtils.debug_output(:looking_for_orphans, params)
    orphans = find_orphan_consumers(params)
    if orphans.is_a?(Tree::TreeNode)
      leafs = get_matched_leafs(orphans, :persistant, true)
    end
    return leafs
  end

  # @returns a [TreeNode] to the depth of the search
  # @service_query_hash :publisher_namespace
  # @service_query_hash :publisher_namespace , :type_path
  # @service_query_hash :publisher_namespace , :type_path , :service_handle
  def find_orphan_consumers(service_query_hash)
    if !service_query_hash.key?(:publisher_namespace) || service_query_hash[:publisher_namespace].nil?
      log_error_mesg('no_publisher_namespace', service_query_hash)
      return false
    end
    provider_tree = orphaned_services_registry[service_query_hash[:publisher_namespace]]
    if !service_query_hash.key?(:type_path) || service_query_hash[:type_path].nil?
      log_error_mesg('find_service_consumers_no_type_path', service_query_hash)
      return provider_tree
    end
    if provider_tree.nil?
      log_error_mesg('found no match for provider in orphans', service_query_hash[:publisher_namespace])
      return false
    end
    service_path_tree = get_type_path_node(provider_tree, service_query_hash[:type_path])
    if !service_path_tree.is_a?(Tree::TreeNode)
      log_error_mesg('Failed to find orphan matching service path', service_query_hash)
      return false
    end
    return service_path_tree
  end
end