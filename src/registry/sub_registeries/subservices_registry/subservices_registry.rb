class SubservicesRegistry < SubRegistry

  require_relative 'subservices_providers.rb'
  include SubservicesProviders

  require_relative 'subservices_consumers.rb'
  include SubservicesConsumers

  private
  def match_node_path(st, params, keys = [:engine_name,:service_handle,:sub_hand], optional = nil)
    match_nstp_path_node_keys(st, params, keys, optional)
  end

#  # stn is already the branch publisher_ns,type_
#  # will not resolve a type path
#  def match_node(stn, params, keys = [:engine_name,:service_handle,:sub_hand])
#    match_node_keys(stn, params, keys)
#  end

  def is_registered?(st, params)
    st = match_node_path(st, params)
    return false unless st.is_a?(Tree::TreeNode)
    true
  rescue StandardError => e
    log_exception(e, params)
  end

  # required[:publisher_namespace,:type_path ] optional 
  def all_registered_to(stp, params)
    st = match_node_path(st, params,nil,[:engine_name, :service_handle])
    return unless st.is_a?(Tree::TreeNode)
    get_all_leafs_service_hashes(st)
  rescue StandardError => e
    log_exception(e, params)
  end
  
#  def add_to_tree(tree_node, params, address_keys, unique = nil)
#    add_to_tree_nstp_path(spt, params, address_keys, unique)
#  end
  
  def add_to_subservices(spt,params)
  
    add_to_tree_nstp_path(spt, params, [:engine_name,:service_handle], :sub_hand)
#    ste = spt[:engine_name]
#    unless ste.is_a?(Tree::TreeNode)
#      ste = Tree::TreeNode.new( service_hash[:type_path] + ':' + service_hash[:engine_name])
#      spt << ste
#    end
#    stes = ste[:service_handle]
#    unless stes.is_a?(Tree::TreeNode)
#      stes = Tree::TreeNode.new(service_hash[:engine_name]+ ':' + service_hash[:service_handle])
#      ste << stes
#    end
#    stess = stes[:sub_hand]
#    if stess.is_a?(Tree::TreeNode)
#      return log_error('Sub Service already exists ', params)
#    end
#    stess = Tree::TreeNode.new(service_hash[:service_handle]+ ':' + service_hash[:sub_hand])
#    stes << stess
#    return log_error('Sub Service node branch found',params) if stn.has_children?
#    stess.content = params
#    true
  rescue StandardError => e
    log_exception(e, params)
  end

  # required[:service_name:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def remove_from_registry(stn,params)
    stn = match_node_path(stn, params)
    return log_error('Sub Service not found!',params) unless stn.is_a?(Tree::TreeNode)
    return log_error('Sub Service node has children!',params) if stn.has_children?
    remove_tree_entry(stn)
  rescue StandardError => e
    log_exception(e, params)
  end

  def update_attached(stn,params)
    stn = match_node_path(stn, params)
    return log_error('Sub Service not found',params) unless stn.is_a?(Tree::TreeNode)
    stn.content = params
    true
  rescue StandardError => e
    log_exception(e, params)
  end

end
