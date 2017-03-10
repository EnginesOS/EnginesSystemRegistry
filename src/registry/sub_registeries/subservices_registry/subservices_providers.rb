module SubservicesProviders
  # required[:publisher_namespace,:type_path ] optional [:engine_name,:service_handle]
  def find_subservice_providers(params)
    all_registered_to(provider_node(params), params)
  end

  # required[:publisher_namespace,:type_path ]  optional [:engine_name,:service_handle,:sub_hand]
  def is_provider_registered?(params)
    is_registered?(provider_node(params), params)
  end

  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def add_to_providers_registry(params)
    add_to_subservices(provider_node(params), params)
  end

  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def update_attached_providers(params)
    update_attached(provider_node(params), params)
  end

  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def remove_from_providers_registry(params)
    remove_from_registry(provider_node(params), params)
  end

  # required[:publisher_namespace,:type_path ] optional [:engine_name,:service_handle]
  def all_subservices_registered_to(params)
    match_node_keys(provider_node(params), params)
  end

  private
  def provider_node(params)
    get_type_path_node(subservices_providers, params)
  end
  
  def subservices_providers
    @providers ||=  create_providers_node
  end

  def create_providers_node
    if @registry[:providers].nil? @providers = Tree::TreeNode.new("Providers")
      @registry << @providers
    end
    @providers
  end
end