class ManagedEnginesRegistry < SubRegistry
  # @return all service_hashs for :engine_name
  def find_engine_services_hashes(params)
    SystemUtils.debug_output('find_engine_services_hashes', params)
    params[:parent_engine] = params[:engine_name] if params.key?(:engine_name)
    engine_node = managed_engines_type_registry(params)
    return log_error_mesg('Failed to find engine type node', params) unless engine_node.is_a?(Tree::TreeNode)
    engine_node = managed_engines_type_registry(params)[params[:parent_engine]]
    return log_error_mesg('Failed to find in managed service tree', params) if !engine_node.is_a?(Tree::TreeNode)
    engine_node = get_type_path_node(engine_node, params[:type_path]) if params.key?(:type_path)
    return log_error_mesg('Failed to find type_path ' + params[:type_path] + 'in managed service tree', params) if !engine_node.is_a?(Tree::TreeNode)
    if params.key?(:service_handle) && !params[:service_handle].nil?
      engine_node = engine_node[params[:service_handle]]
      return log_error_mesg('Failed to find service_handle ' + params[:service_handle] + 'in managed service tree', params) if !engine_node.is_a?(Tree::TreeNode)
    end
    return order_hashes_in_priotity(get_all_leafs_service_hashes(engine_node)) unless params.key?(:persistant)
    return order_hashes_in_priotity(get_matched_leafs(engine_node, :persistant, params[:persistant]))
  end

  def find_engine_service_hash(params)
    return log_error_mesg('missing parrameters parent_engine', params) unless params.key?(:parent_engine)
    return log_error_mesg('missing parrameters type_path', params) unless params.key?(:type_path)
    return log_error_mesg('missing parrameters service_handle', params) unless params.key?(:service_handle)
    return log_error_mesg('missing parrameters container_type', params) unless params.key?(:container_type)
    return log_error_mesg('missing parrameters service_container_name', params) unless params.key?(:service_container_name)
    SystemUtils.debug_output('find_engine_services_hash', params)
    engine_node = managed_engines_type_registry(params)[params[:parent_engine]]
    return log_error_mesg('Failed to find parent engine in managed service tree', params) unless engine_node.is_a?(Tree::TreeNode)
    engine_node = get_type_path_node(engine_node, params[:type_path])
    return log_error_mesg('Failed to find type_path ' + params[:type_path] + 'in managed service tree', params) unless engine_node.is_a?(Tree::TreeNode)
    engine_node = engine_node[params[:service_handle]]
    return log_error_mesg('Failed to find service_handle ' + params[:service_handle] + 'in managed service tree', params) unless engine_node.is_a?(Tree::TreeNode)
    return engine_node.content
  end

  # @return [Array] of all service_hashs marked persistance [boolean] for :engine_name
  def get_engine_persistance_services(params, persistance) # params is :engine_name
    leafs = []
    params[:parent_engine] = params[:engine_name] unless params.key?(:parent_engine)
    services = find_engine_services(params)
    unless services.is_a?(Tree::TreeNode)
      log_error_mesg('Failed to find engine in persistant service', params)
      return leafs
    end
    services.children.each do |service|
      SystemUtils.debug_output(:finding_match_for, service.content)
      matches = get_matched_leafs(service, :persistant, persistance)
      SystemUtils.debug_output('matches', matches)
      leafs = leafs.concat(matches)
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
    return log_error_mesg('no_parent_engine_key', service_hash) if service_hash[:parent_engine].nil? || !service_hash.key?(:parent_engine)
    engines_type_tree = managed_engines_type_registry(service_hash)
    return log_error_mesg('no_type tree ', service_hash) unless engines_type_tree.is_a?(Tree::TreeNode)
    if !engines_type_tree[service_hash[:parent_engine]].nil?
      engine_node = engines_type_tree[service_hash[:parent_engine]]
    else
      engine_node = Tree::TreeNode.new(service_hash[:parent_engine], service_hash[:parent_engine] + ' Engine Service Tree')
      managed_engines_type_registry(service_hash) << engine_node
    end
    service_type_node = create_type_path_node(engine_node, service_hash[:type_path])
    service_handle = get_service_handle(service_hash)
    # service_handle = service_hash[:service_handle]
    return log_error_mesg('no service type node', service_hash) unless service_type_node.is_a?(Tree::TreeNode)
    return log_error_mesg('Service hash has nil handle', service_hash) if service_handle.nil?
    service_node = service_type_node[service_handle]
    if service_node.nil?
      service_node = Tree::TreeNode.new(service_handle, service_hash)
      service_type_node << service_node
      service_node.content = service_hash
    elsif !is_persistant?(service_hash)
      service_node.content = service_hash
    else
      log_error_mesg('Engine Node existed', service_handle)
      log_error_mesg('Cannot over write persistant service' + service_node.content.to_s + ' with ', service_hash)
    end
    return true
  rescue StandardError => e
    log_exception(e)
  end

  # Remove Service from engine service registry matching :parent_engine :type_path :service_handle
  # @return boolean
  def remove_from_engine_registry(service_hash)
    service_node = find_engine_services(service_hash)
    return remove_tree_entry(service_node) if service_node.is_a?(Tree::TreeNode)
    log_error_mesg('Failed to find service node to remove service from engine registry ', service_hash)
    return true # failure to find ok
  end

  def all_engines_registered_to(service_path)
    get_matched_leafs(@registry, :type_path, service_path)
  end

  private

  # @return the service_handle from the service_hash
  # for backward compat (to be changed)
  def get_service_handle(params)
    return params[:service_handle] if params.key?(:service_handle) && !params[:service_handle].nil?
    log_error_mesg('no :service_handle', params)
  end

  # @return the appropriate tree under managedservices trees either engine or service
  def managed_engines_type_registry(site_hash)
    return false unless @registry.is_a?(Tree::TreeNode)
    return log_error_mesg('Site hash missing :container_type', site_hash) unless site_hash.key?(:container_type)
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

  def find_engine_services(params)
    return log_error_mesg('find_engine_services passed nil params', params) if params.nil?
    engines_type_tree = managed_engines_type_registry(params)
    return log_error_mesg('fail to find engine type tree', params) unless engines_type_tree.is_a?(Tree::TreeNode)
    engine_node = engines_type_tree[params[:parent_engine]]
    return log_error_mesg('fail to find engine in type tree', params)  unless engine_node.is_a?(Tree::TreeNode)
    SystemUtils.debug_output(:find_engine_services_with_params, params)
    if params.key?(:type_path) && !params[:type_path].nil?
      services = get_type_path_node(engine_node, params[:type_path]) # engine_node[params[:type_path]]
      if services.is_a?(Tree::TreeNode) && params.key?(:service_handle) && !params[:service_handle].nil?
        service = services[params[:service_handle]]
        return service
      else
        return services
      end
    else
      return engine_node
    end
  end
end
