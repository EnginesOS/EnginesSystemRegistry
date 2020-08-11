class ServicesRegistry < SubRegistry
  # @Boolean returns true | false if servcice hash is registered in service tree
  def service_is_registered?(query_params)
    #  STDERR.puts(' QUERY PARAS ' + query_params.to_s + ' for keys  ' + [:parent_engine, :service_handle].to_s)
    is_ns_tp_node_registered?(@registry, query_params, [:parent_engine, :service_handle] )
  end

  # Add The service_hash to the services registry branch
  # creates the branch path as required
  # @params :publisher_namespace . :type_path . :parent_engine
  # Wover writes
  def add_to_services_registry(params)
    #overwrite if :persistent
    unless params[:persistent]
      add_to_ns_tp_tree_path(@registry, params, [:parent_engine], params[:service_handle], false)
    else
      add_to_ns_tp_tree_path(@registry, params, [:parent_engine], params[:service_handle])
    end
  end

  def list_providers_in_use
    providers = @registry.children
    retval = []
    if providers.nil?
      raise EnginesException.new('No providers', :warning, '')
    else
      providers.each do |provider|
        retval.push(provider.name)
      end
    end
    retval
  end

  # @return an [Array] of service_hashes regsitered against the Service params[:publisher_namespace] params[:type_path]
  def get_registered_against_service(params)
    services = find_service_consumers(params)
    if services.is_a?(Tree::TreeNode)
      get_all_leafs_service_hashes(services)
    else
      services
    end
  end

  # remove the service matching the service_hash from the tree
  # @params :publisher_namespace :type_path :service_handle
  def remove_from_services_registry(params)
    service_node = find_service_consumers(params)
    raise EnginesException.new("Fail to find service for removal #{params}", :error, params) unless service_node.is_a?(Tree::TreeNode)
    remove_tree_entry(service_node)
  end

  # @return an [Array] of service_hashs of Active persistent services match @params [Hash]
  # :path_type :publisher_namespace
  def get_active_persistent_services(params)
    services = find_service_consumers(params)
    get_matched_leafs(services, :persistent, true) if services.nil? == false && services != false
  end

  # @returns a [TreeNode] to the depth of the search
  # @query_params :publisher_namespace
  # @query_params :publisher_namespace , :type_path
  # @query_params :publisher_namespace , :type_path , :service_handle
  def find_service_consumers(query_params)
    match_nstp_path_node_keys(@registry, query_params, [], [:parent_engine, :service_handle])
  end

  def update_service(params)
    tree_node = find_service_consumers(params)
    raise EnginesException.new('Registry Entry Not found', :error, params) unless tree_node.is_a?(Tree::TreeNode)
    raise EnginesException.new('Registry Entry Hash missing', :error, params) unless tree_node.content.is_a?(Hash)
    tree_node.content[:variables] = params[:variables]
  end

  ## SystemUtils.debug_output(:find_service_consumers_, service_query_hash[:service_handle])
  #    service = services[service_query_hash[:service_handle]]
  #    return log_error_mesg('failed to find match in services tree', service_query_hash) if service.nil?
  #    return service
  #  end
  private

  # @query_params :publisher_namespace , :type_path , :service_handle
  def get_service_entry(query_params)
    tree_node = find_service_consumers(query_params)
    raise EnginesException.new('Registry Entry Not found', :warning, query_params) unless tree_node.is_a?(Tree::TreeNode)
    raise EnginesException.new('Registry Entry Hash missing', :warning, query_params) unless tree_node.content.is_a?(Hash)
    tree_node.content
  end

end
