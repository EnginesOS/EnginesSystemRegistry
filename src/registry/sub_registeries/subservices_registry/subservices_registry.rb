class SubservicesRegistry < SubRegistry

  require_relative 'subservices_providers.rb'
  include SubservicesProviders

  require_relative 'subservices_consumers.rb'
  include SubservicesConsumers

  private
  def match_node_path(st, params, keys = full_path, optional = nil)
    match_node_keys(st, params, keys, optional)
  end
  def full_path
    @full_path ||= [:engine_name,:service_handle,:sub_handle]
  end

  def initialize(registry)
    super(registry)
    
  end
  #  # stn is already the branch publisher_ns,type_
  #  # will not resolve a type path
  #  def match_node(stn, params, keys = [:engine_name,:service_handle,:sub_handle])
  #    match_node_keys(stn, params, keys)
  #  end

  def is_registered?(st, params)
    is_node_registered?(st, params, full_path)
#    st = match_node_path(st, params)
#    return false unless st.is_a?(Tree::TreeNode)
#    true
  end

  # required[:publisher_namespace,:type_path ] optional
  def all_registered_to(stp, params)
    st = match_node_path(st, params,nil,[:engine_name, :service_handle,:sub_handle])
    get_all_leafs_service_hashes(st) if st.is_a?(Tree::TreeNode)
  end
  
  def add_to_subservices_registry(params)
    add_to_subservices_consumers(params)
    add_to_providers_registry(params)
  end



  # required[:service_name:publisher_namespace,:type_path :engine_name,:service_handle,:sub_handle]
  def remove_from_registry(stn,params)
    stn = match_node_path(stn, params)
    raise EnginesException.new('Sub Service not found!', :error, params) unless stn.is_a?(Tree::TreeNode)
    raise EnginesException.new('Sub Service node has children!', :error, params) if stn.has_children?
    remove_tree_entry(stn)
  end

  def update_attached(stn,params)
    stn = match_node_path(stn, params)
    raise EnginesException.new('Sub Service not found', :error, :params) unless stn.is_a?(Tree::TreeNode)
    stn.content = params
    true
  end

end
