class ManagedEnginesRegistry < SubRegistry
  # @return all service_hashs for :engine_name
  def find_engine_services_hashes(params)
    pe = managed_engines_type_registry(params)[params[:parent_engine]]

    raise EnginesException.new("Failed to find node #{arams[:parent_engine]}", :warning, params)  unless pe.is_a?(Tree::TreeNode)
    if params.key?(:type_path)
      pe =  get_type_path_node(pe, params[:type_path])
      if params.key?(:service_handle)
        engine_node = match_node_keys(pe, params, [:service_handle])
        raise EnginesException.new('Registry Entry Invalid', :error, params, engine_node.content) unless engine_node.content.is_a?(Hash)
        #return engine_node.content
      end
      unless params.key?(:persistent)
        order_hashes_in_priotity(get_all_leafs_service_hashes(pe))
      else
        order_hashes_in_priotity(get_matched_leafs(pe, :persistent, params[:persistent]))
      end
    else
      pe
    end
  end

  def find_engine_service_node(params)
    st = managed_engines_type_registry(params)
    pe = match_node_keys(st, params, [:parent_engine])
    raise EnginesException.new('Registry Entry Not found', :warning, params) if pe.nil?
    engine_node = match_tp_path_node_keys(pe, params, [:service_handle])
    raise EnginesException.new('Registry Entry Not found', :warning, params) if engine_node.nil?
    raise EnginesException.new('Registry Entry Invalid', :error, params) unless engine_node.content.is_a?(Hash)
    engine_node
  end

  def find_engine_service_hash(params)
    st = managed_engines_type_registry(params)
    pe = match_node_keys(st, params, [:parent_engine])
    raise EnginesException.new('Registry Entry Not found', :warning, params) if pe.nil?
    engine_node = match_tp_path_node_keys(pe, params, [:service_handle])
    raise EnginesException.new('Registry Entry Not found', :warning, params) if engine_node.nil?
    raise EnginesException.new('Registry Entry Invalid', :error, params) unless engine_node.content.is_a?(Hash)
    engine_node.content
  end

  # @return [Array] of all service_hashs marked persistence [boolean] for :engine_name
  def get_engine_persistence_services(params, persistence) # params is :engine_name
    params[:parent_engine] = params[:engine_name] unless params.key?(:parent_engine)
    services = find_engine_services(params)
    #raise EnginesException.new('Failed to find engine in persistent service', :warning, params)  unless services.is_a?(Tree::TreeNode)

    leafs = []
    if services.is_a?(Tree::TreeNode)
      services.children.each do |service|
        matches = get_matched_leafs(service, :persistent, persistence)
        leafs = leafs.concat(matches)
      end
      order_hashes_in_priotity(leafs)
    else
      leafs
    end
  end

  # Register the service_hash with the engine
  # return true if successful
  # returns false on error or duplicate
  # Needs overwrite flag
  # requires :parent_engine :type_path
  # @return boolean
  # overwrites
  def add_to_managed_engines_registry(params)
    tn = managed_engines_type_registry(params)
    tb = match_node_keys(tn, params, [:parent_engine])#, params[:parent_engine])
    unless tb.is_a?(Tree::TreeNode)
      tb = Tree::TreeNode.new(params[:parent_engine], params[:parent_engine])
      tn << tb
    end
    tn = tb
    add_to_tp_tree_path(tn, params, params[:type_path], params[:service_handle])
  end

  # Remove Service from engine service registry matching :parent_engine :type_path :service_handle
  # @return boolean
  def remove_from_engine_registry(service_hash)
    service_node = find_engine_service_node(service_hash)
    if service_node.is_a?(Tree::TreeNode)
      remove_tree_entry(service_node)
    else
      false # failure to find ok
    end
  end

  def all_engines_registered_to(service_path)
    get_matched_leafs(@registry, :type_path, service_path)
  end

  def update_engine_service(params)
    pe = managed_engines_type_registry(params)[params[:parent_engine]]
    raise EnginesException.new("Failed to find node #{params[:parent_engine]}",:error, params)  unless pe.is_a?(Tree::TreeNode)
    pe = get_type_path_node(pe, params[:type_path])
    engine_node = match_node_keys(pe, params, [:service_handle])
    raise EnginesException.new('Registry Entry Invalid', :error, params) unless engine_node.content.is_a?(Hash)
    engine_node.content[:variables] = params[:variables]
    true
  end
  private

  # @return the appropriate tree under managedservices trees either engine or service
  def managed_engines_type_registry(site_hash)
    if @registry.is_a?(Tree::TreeNode)
      raise EnginesException.new('managed_engines_type_registry', :error, site_hash) unless site_hash.is_a?(Hash)
      raise EnginesException.new('Site hash missing :container_type', :error, site_hash) unless site_hash.key?(:container_type)
      if site_hash[:container_type] == 'service'
        @registry << Tree::TreeNode.new('Service', 'Managed Services register') if @registry['Service'].nil?
        @registry['Service']
      elsif site_hash[:container_type] == 'system'
        @registry << Tree::TreeNode.new('System', 'System Services register') if @registry['System'].nil?
        @registry['System']
      else
        @registry << Tree::TreeNode.new('Application', 'Managed Application register') if @registry['Application'].nil?
        @registry['Application']
      end
    else
      false
    end
  end

  def find_engine_services(params)
    raise EnginesException.new('find_engine_services Invalid params ',:error, params) unless params.is_a?(Hash)
    st = managed_engines_type_registry(params)
    pe = match_node_keys(st, params, [:parent_engine])
    unless params.key(:type_path)
      pe
    else
      pe = get_type_path_node(st, params[:type_path])
      unless params.key(:service_handle)
        pe
      else
        match_node_keys(pe, params, [:service_handle])
      end
    end
  end

end
