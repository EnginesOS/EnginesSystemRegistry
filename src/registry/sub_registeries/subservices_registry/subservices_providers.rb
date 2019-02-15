module SubservicesProviders
  # required[:publisher_namespace,:type_path ] optional [:engine_name,:service_handle]
  def find_subservice_providers(params)
    all_registered_to(provider_node(params), params)
  end

  # required[:publisher_namespace,:type_path ]  optional [:engine_name,:service_handle,:sub_handle]
  def is_provider_registered?(params)
    is_registered?(provider_node(params), params)
  end

  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_handle]
  def add_to_providers_registry(params)
    pn = provider_node(params)
    STDERR.puts("\n provider node " + pn.to_s)
    add_to_tree_path(pn, params, [:engine_name,:service_handle], params[:sub_handle])
  end

  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_handle]
  def update_attached_providers(params)
    update_attached(provider_node(params), params)
  end

  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_handle]
  def remove_from_providers_registry(params)
    remove_from_registry(provider_node(params), params)
  end

  # required[:publisher_namespace,:type_path ] optional [:engine_name,:service_handle]
  def all_subservices_registered_to(params)
    match_node_keys(provider_node(params), params)
  end

  private

  def provider_node(params)
    STDERR.puts("\n subservices_providers node " + subservices_providers.to_s)
    STDERR.puts("\n params  " + params.to_s)
    get_pns_type_path_node(subservices_providers, params)
  end

  def subservices_providers
    @providers ||=  create_providers_node
  end

  def create_providers_node
    if @registry['Providers'].nil? 
      @providers = Tree::TreeNode.new('Providers')
      @registry << @providers
    end
    @providers = @registry['Providers']
    @providers 
  end
end