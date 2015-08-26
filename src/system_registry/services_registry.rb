class ServicesRegistry < SubRegistry
  # Wrapper for Gui to
  # @return [TreeNode] managed_service_tree[publisher]
  def service_provider_tree(publisher)
    if @registry.is_a?(Tree::TreeNode)
      return @registry[publisher]
    end
    return false
  end

  # @Boolean returns true | false if servcice hash is registered in service tree
  def service_is_registered?(service_hash)
    provider_node = service_provider_tree(service_hash[:publisher_namespace]) # managed_service_tree[service_hash[:publisher_namespace] ]
    if provider_node.is_a?(Tree::TreeNode) == false
      p :nil_provider_node
      return false
    end
    service_type_node = create_type_path_node(provider_node, service_hash[:type_path])
    if service_type_node.is_a?(Tree::TreeNode) == false
      p :nil_service_type_node
      return false
    end
    engine_node = service_type_node[service_hash[:parent_engine]]
    if engine_node.is_a?(Tree::TreeNode) == false
      p :nil_engine_node
      return false
    end
    service_node = engine_node[service_hash[:service_handle]]
    if service_node.nil?
      p :nil_service_handle
      return false
    end
    p :service_hash_is_registered
    return true
  end

  # Add The service_hash to the services registry branch
  # creates the branch path as required
  # @service_hash :publisher_namespace . :type_path . :parent_engine
  # Wover writes
  def add_to_services_registry(service_hash)
    provider_node = service_provider_tree(service_hash[:publisher_namespace]) # managed_service_tree[service_hash[:publisher_namespace] ]
    if provider_node.is_a?(Tree::TreeNode) == false
      provider_node = Tree::TreeNode.new(service_hash[:publisher_namespace], ' Provider:' + service_hash[:publisher_namespace] + ':' + service_hash[:type_path])
      @registry << provider_node
    end
    service_type_node = create_type_path_node(provider_node, service_hash[:type_path])
    if service_type_node.is_a?(Tree::TreeNode) == false
      log_error_mesg('failed to create TreeNode for', service_hash)
      return false
    end
    engine_node = service_type_node[service_hash[:parent_engine]]
    if engine_node.is_a?(Tree::TreeNode) == false
      engine_node = Tree::TreeNode.new(service_hash[:parent_engine], service_hash[:parent_engine])
      service_type_node << engine_node
    end
    service_node = engine_node[service_hash[:service_handle]]
    if service_node.is_a?(Tree::TreeNode) == false
      SystemUtils.debug_output(:create_new_service_regstry_entry, service_hash)
      service_node = Tree::TreeNode.new(service_hash[:service_handle], service_hash)
      engine_node << service_node
    elsif is_persistant?(service_hash) == false
      SystemUtils.debug_output(:reattachexistsing_service_persistant_false, service_hash)
      service_node.content = service_hash
    else
      p :failed
      log_error_mesg('Service Node existed', service_hash[:service_handle])
      log_error_mesg('Cannot over write persistant service' + service_node.content.to_s + ' with ', service_hash)
      # service_node = Tree::TreeNode.new(service_hash[:parent_engine],service_hash)
      # service_type_node << service_node
    end
    # FIXME: need to handle updating service
    return true
  rescue StandardError => e
    puts e.message
    log_exception(e)
    return false
  end


  # @service_query_hash :publisher_namespace , :type_path , :service_handle
  def get_service_entry(service_query_hash)
    tree_node = find_service_consumers(service_query_hash)
    return tree_node.content if tree_node.is_a?(Tree::TreeNode) 
    log_error_mesg("get service_ entry failed ",service_query_hash)
  end

  # @returns a [TreeNode] to the depth of the search
  # @service_query_hash :publisher_namespace
  # @service_query_hash :publisher_namespace , :type_path
  # @service_query_hash :publisher_namespace , :type_path , :service_handle
  def find_service_consumers(service_query_hash)
    return log_error_mesg('no_publisher_namespace', service_query_hash) if service_query_hash[:publisher_namespace].nil? ||  service_query_hash.key?(:publisher_namespace) == false
    provider_tree = service_provider_tree(service_query_hash[:publisher_namespace])
    if service_query_hash[:type_path].nil? || service_query_hash.key?(:type_path) == false 
      log_error_mesg('find_service_consumers_no_type_path', service_query_hash)
      return provider_tree
    end
    return log_error_mesg('no Provider tree', service_query_hash) if provider_tree.is_a?(Tree::TreeNode) == false
    service_path_tree = get_type_path_node(provider_tree, service_query_hash[:type_path])
    return log_error_mesg('Failed to find matching service path', service_query_hash) if service_path_tree.is_a?(Tree::TreeNode) == false
    return service_path_tree if service_query_hash[:parent_engine].nil? || service_query_hash.key?(:parent_engine) == false
    services = service_path_tree[service_query_hash[:parent_engine]]
    return log_error_mesg('Failed to find matching parent_engine', service_query_hash) if services.is_a?(Tree::TreeNode) == false
    return log_error_mesg('find_service_consumers_no_service_handle', service_query_hash) if service_query_hash[:service_handle].nil? ||service_query_hash.key?(:service_handle) == false 
    SystemUtils.debug_output(:find_service_consumers_, service_query_hash[:service_handle])
    service = services[service_query_hash[:service_handle]]
    return log_error_mesg('failed to find match in services tree', service_query_hash)if service.nil?
    return service
  end

  def list_providers_in_use
    providers = @registry.children
    retval = []
    if providers.nil?
      log_error_mesg('No providers', '')
      return retval
    end
    providers.each do |provider|
      retval.push(provider.name)
    end
    return retval
  end

  # @return an [Array] of service_hashes regsitered against the Service params[:publisher_namespace] params[:type_path]
  def get_registered_against_service(params)
    hashes = []
    service_tree = find_service_consumers(params)
    hashes = get_all_leafs_service_hashes(service_tree) if service_tree.is_a?(Tree::TreeNode)
    return hashes
  end

  # remove the service matching the service_hash from the tree
  # @service_hash :publisher_namespace :type_path :service_handle
  def remove_from_services_registry(service_hash)
    if @registry.is_a?(Tree::TreeNode)
      service_node = find_service_consumers(service_hash)
      return remove_tree_entry(service_node) if service_node.is_a?(Tree::TreeNode)
       log_error_mesg('Fail to find service for removal' + service_hash.to_s, service_node)
    end
    log_error_mesg('Fail to remove service', service_hash)
  end

  # @return an [Array] of service_hashs of Active persistant services match @params [Hash]
  # :path_type :publisher_namespace
  def get_active_persistant_services(params)
    leafs = []
    services = find_service_consumers(params)
    leafs = get_matched_leafs(services, :persistant, true) if services.nil? == false && services != false
    return leafs
  end
end
