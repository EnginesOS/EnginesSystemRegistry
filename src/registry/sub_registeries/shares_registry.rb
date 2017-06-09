class SharesRegistry < SubRegistry
  #  def service_provider_tree(publisher)
  #    return @registry[publisher] if @registry.is_a?(Tree::TreeNode)
  #  end
  def add_to_shares_registry(params)
    owner_node = @registry[params[:service_owner]] # managed_service_tree[service_hash[:publisher_namespace] ]
    if owner_node.is_a?(Tree::TreeNode) == false
      owner_node = Tree::TreeNode.new(params[:service_owner], 'Owner:' + params[:service_owner])
      @registry << owner_node
    end
    service_type_node = add_to_ns_tp_tree_path(owner_node, params, [:parent_engine], params[:service_handle])

    # FIXME: need to handle updating service
    #   return true

  end

  def remove_from_shares_registry(params)
    on = @registry[params[:service_owner]]
    on =  match_nstp_path_node_keys(on, params, [:parent_engine, :service_handle])
    remove_tree_entry(on)
  end
end
