class SubservicesRegistry < SubRegistry
  def match_node(params, stn)
    if params.key(:engine_name)
      stn = stn[params[:engine_name]]
      return unless stn.is_a?(Tree::TreeNode)
    end
    if params.key(:service_handle)
      stn = stn[params[:service_handle]]
      return unless stn.is_a?(Tree::TreeNode)
    end
    if params.key(:sub_hand)
      stn = stn[params[:sub_hand]]
      return unless stn.is_a?(Tree::TreeNode)
    end
    stn
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

  def subservices_consumers
    @consumers ||=  create_consumers_node
  end

  def create_consumers_node
    if @registry[:consumers].nil? @consumers = Tree::TreeNode.new("Consumers")
      @registry << @consumers
    end
    @consumers
  end

  def find_subservice_consumers(params)
    all_registered_to(subservices_consumers, params)
  end
  #  # required[:publisher_namespace,:type_path]
  #  def find_subservice_consumers(params)
  #    stn = get_consumer_type_path_node(subservices_consumers, params)
  #    return false unless stn.is_a?(Tree::TreeNode)
  #    stn = match_node(params, stn)
  #    return false unless stn.is_a?(Tree::TreeNode)
  #    get_all_leafs_service_hashes(stn)
  #  end

  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def add_to_subservices_consumers(params)
    params = retrive_consumer_params(params)
    add_to_subservices(subservices_consumers,params)
  end

  def update_attached_consumers(params)
    params = retrive_consumer_params(params)
    update_attached(subservices_consumers,params)
  end

  def retrive_consumer_params(params)
    params
  end

  def remove_from_subservices_consumers(params)
    params = retrive_consumer_params(params)
    stn = get_type_path_node(subservices_consumers, params)
  end

  def all_subservices_registered_to(params)
    all_registered_to(subservices_providers, params)
  end

  # required[:publisher_namespace,:type_path ] optional [:engine_name,:service_handle,:sub_hand]
  def all_registered_to(stp,params)
    st = get_type_path_node(stp, params)
    return [] unless st.is_a?(Tree::TreeNode)
    st = match_node(params, st)
    return [] unless st.is_a?(Tree::TreeNode)
    get_all_leafs_service_hashes(st)
  end

  #  def get_subservices_registered_against_service(params)
  #  end

  #use find_subservice_consumers(params) instead
  #  def get_subservice_entry(params)
  #
  #  end

  # required[:service_name:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def subservice_is_registered?(params)
    st = get_type_path_node(subservices_providers, params)
    return false unless st.is_a?(Tree::TreeNode)
    st = match_node(params, st)
    return false unless st.is_a?(Tree::TreeNode)
    true
  end

  def add_to_subservices_registry(params)
    add_to_subservices(subservices_providers,params)
  end

  # required[:service_name:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def add_to_subservices(spt,params)
    spt = create_type_path_node(spt, params)
    ste = spt[:engine_name]
    unless ste.is_a?(Tree::TreeNode)
      ste = Tree::TreeNode.new( service_hash[:type_path] + ':' + service_hash[:engine_name])
      spt << ste
    end
    stes = ste[:service_handle]
    unless stes.is_a?(Tree::TreeNode)
      stes = Tree::TreeNode.new(service_hash[:engine_name]+ ':' + service_hash[:service_handle])
      ste << stes
    end
    stess = stes[:sub_hand]
    if stess.is_a?(Tree::TreeNode)
      return log_error('Sub Service already exists ', params)
    end
    stess = Tree::TreeNode.new(service_hash[:service_handle]+ ':' + service_hash[:sub_hand])
    stes << stess
    return log_error('Sub Service node branch found',params) if stn.has_children?
    stess.content = params
    true
  end

  # required[:service_name:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def update_attached_subservice(params)
    update_attached(subservices_providers,params)
  end

  def update_attached(stn,params)
    stn = get_type_path_node(stn, params)
    return  log_error('Sub Service not found',params) unless stn.is_a?(Tree::TreeNode)
    stn.content = params
    true
  end

  # required[:service_name:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def remove_from_subservices_registry(params)
    stn = get_type_path_node(subservices_providers, params)
  end

  # required[:service_name:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def remove_from_registry(stn,params)
    stn = get_type_path_node(stn, params)
    return log_error('Sub Service not found',params) unless stn.is_a?(Tree::TreeNode)
    return log_error('Sub Service node branch found',params) if stn.has_children?
    remove_tree_entry(stn)
  end
end
