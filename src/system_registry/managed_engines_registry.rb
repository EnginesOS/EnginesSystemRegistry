class ManagedEnginesRegistry < SubRegistry
  def find_engine_services(params)
    return log_error_mesg('find_engine_services passed nil params', params) if params.nil? == true
    engines_type_tree = managed_engines_type_registry(params)
    return log_error_mesg('fail to find engine type tree', params) if engines_type_tree.is_a?(Tree::TreeNode) == false
    engine_node = engines_type_tree[params[:parent_engine]]
   return log_error_mesg('fail to find engine in type tree', params)  if engine_node.is_a?(Tree::TreeNode) == false
    SystemUtils.debug_output(:find_engine_services_with_params, params)
    if params.key?(:type_path) && params[:type_path].nil? == false
      services = get_type_path_node(engine_node, params[:type_path]) # engine_node[params[:type_path]]
      if services.is_a?(Tree::TreeNode) == true && params.key?(:service_handle) && params[:service_handle].nil? == false
        service = services[params[:service_handle]]
        return service
      else
        return services
      end
    else
      return engine_node
    end
  end

  # @return all service_hashs for :engine_name
  def find_engine_services_hashes(params)
    SystemUtils.debug_output('find_engine_services_hashes', params)
    params[:parent_engine] = params[:engine_name] if params.key?(:engine_name)
    engine_node = managed_engines_type_registry(params)[params[:parent_engine]]
    return log_error_mesg('Failed to find in managed service tree', params) if engine_node.is_a?(Tree::TreeNode) == false
    engine_node = get_type_path_node(engine_node, params[:type_path]) if params.key?(:type_path)
    return log_error_mesg('Failed to find type_path ' + params[:type_path] + 'in managed service tree', params) if engine_node.is_a?(Tree::TreeNode) == false
    if params.key?(:service_handle) && params[:service_handle].nil? == false
      engine_node = engine_node[params[:service_handle]]
      return log_error_mesg('Failed to find service_handle ' + params[:service_handle] + 'in managed service tree', params) if engine_node.is_a?(Tree::TreeNode) == false
    end
      return order_hashes_in_priotity(get_all_leafs_service_hashes(engine_node)) if params.key?(:persistant) == false
      return order_hashes_in_priotity(get_matched_leafs(engine_node, :persistant, params[:persistant]))
  end

  def find_engine_service_hash(params)    
      return log_error_mesg('missing parrameterss parent_engine', params) if params.key?(:parent_engine) == false
      return log_error_mesg('missing parrameterss type_path', params) if params.key?(:type_path) == false
      return log_error_mesg('missing parrameterss service_handle', params) if params.key?(:service_handle) == false
      return log_error_mesg('missing parrameterss container_type', params) if params.key?(:container_type) == false
      return log_error_mesg('missing parrameterss service_container_name', params) if params.key?(:service_container_name) == false
    SystemUtils.debug_output('find_engine_services_hash', params)
    engine_node = managed_engines_type_registry(params)[params[:parent_engine]]
   return log_error_mesg('Failed to find parent engine in managed service tree', params) if engine_node.is_a?(Tree::TreeNode) == false
    engine_node = get_type_path_node(engine_node, params[:type_path])
   return log_error_mesg('Failed to find type_path ' + params[:type_path] + 'in managed service tree', params) if engine_node.is_a?(Tree::TreeNode) == false
    engine_node = engine_node[params[:service_handle]]
    return log_error_mesg('Failed to find service_handle ' + params[:service_handle] + 'in managed service tree', params) if engine_node.is_a?(Tree::TreeNode) == false
    return engine_node.content
  end

  # @return [Array] of all service_hashs marked persistance [boolean] for :engine_name
  def get_engine_persistance_services(params, persistance) # params is :engine_name
    leafs = []
    params[:parent_engine] = params[:engine_name] if params.key?(:parent_engine) == false
    services = find_engine_services(params)
    if services.is_a?(Tree::TreeNode) == false
      log_error_mesg('Failed to find engine in persistant service', params)
      return leafs
    end
    services.children.each do |service|
      SystemUtils.debug_output(:finding_match_for, service.content)
      matches = get_matched_leafs(service, :persistant, persistance)
      SystemUtils.debug_output('matches', matches)
      leafs =  leafs.concat(matches)
    end
    return order_hashes_in_priotity(leafs)
  end

  # Register the service_hash with the engine
  # return true if successful
  # returns false on error or duplicate
  # Needs overwrite flag
  # requires :parent_engine :type_path
  # @return boolean
  # overwrites
  def add_to_managed_engines_registry(service_hash)
    p :add_to_managed_engines_registry
    p service_hash.to_s
    return log_error_mesg('no_parent_engine_key', service_hash) if service_hash[:parent_engine].nil? || service_hash.key?(:parent_engine) == false 
    engines_type_tree = managed_engines_type_registry(service_hash)
   return log_error_mesg('no_type tree ',service_hash) if engines_type_tree.is_a?(Tree::TreeNode) == false
    if engines_type_tree[service_hash[:parent_engine]].nil? == false
      engine_node = engines_type_tree[service_hash[:parent_engine]]
    else
      engine_node = Tree::TreeNode.new(service_hash[:parent_engine], service_hash[:parent_engine] + ' Engine Service Tree')
      managed_engines_type_registry(service_hash) << engine_node
    end
    service_type_node = create_type_path_node(engine_node, service_hash[:type_path])
    service_handle = get_service_handle(service_hash)
    # service_handle = service_hash[:service_handle]
    return log_error_mesg('no service type node', service_hash) if service_type_node.is_a?(Tree::TreeNode) == false
    return log_error_mesg('Service hash has nil handle', service_hash) if service_handle.nil? == true
    service_node = service_type_node[service_handle]
    if service_node.nil? == true
      service_node = Tree::TreeNode.new(service_handle, service_hash)
      service_type_node << service_node
      service_node.content = service_hash
    elsif is_persistant?(service_hash) == false
      service_node.content = service_hash
    else
      log_error_mesg('Engine Node existed', service_handle)
      log_error_mesg('Cannot over write persistant service' + service_node.content.to_s + ' with ', service_hash)
    end
    return true
  rescue StandardError => e
    log_exception(e)
  end

  # @return the service_handle from the service_hash
  # for backward compat (to be changed)
  def get_service_handle(params)
    return params[:service_handle] if params.key?(:service_handle) && params[:service_handle].nil? == false
      log_error_mesg('no :service_handle', params)
      return nil
  end

  # @return the appropriate tree under managedservices trees either engine or service
  def managed_engines_type_registry(site_hash)
    return false if @registry.is_a?(Tree::TreeNode) == false
    return log_error_mesg('Site hash missing :container_type', site_hash) if site_hash.key?(:container_type) == false
    if site_hash[:container_type] == 'service'
      @registry << Tree::TreeNode.new('Service', 'Managed Services register') if @registry['Service'].nil?     
      return @registry['Service']
    elsif site_hash[:container_type] == 'system'
      @registry << Tree::TreeNode.new('System', 'System Services register') if @registry['System'].nil?
      return @registry['System']
    else
      @registry << Tree::TreeNode.new('Application', 'Managed Application register') if @registry['Application'].nil? 
      return @registry['Application']
    end
  end

  # Remove Service from engine service registry matching :parent_engine :type_path :service_handle
  # @return boolean
  def remove_from_engine_registry(service_hash)
    service_node = find_engine_services(service_hash)
    return remove_tree_entry(service_node) if service_node.is_a?(Tree::TreeNode)
    log_error_mesg('Failed to find service node to remove service from engine registry ', service_hash)
  end
end
