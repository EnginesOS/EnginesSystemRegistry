class SharesRegistry < SubRegistry

 
  def service_provider_tree(publisher)
      return @registry[publisher] if @registry.is_a?(Tree::TreeNode)
    end
  
  def add_to_shares_registry(service_hash)
 
       provider_node = service_provider_tree(service_hash[:publisher_namespace]) # managed_service_tree[service_hash[:publisher_namespace] ]
       if provider_node.is_a?(Tree::TreeNode) == false
         provider_node = Tree::TreeNode.new(service_hash[:publisher_namespace], 'Publisher:' + service_hash[:publisher_namespace] + ':' + service_hash[:type_path])
         @registry << provider_node
       end
       service_type_node = create_type_path_node(provider_node, service_hash[:type_path])
        return log_error_mesg('failed to create TreeNode for share', service_hash) if service_type_node.is_a?(Tree::TreeNode) == false
       engine_node = service_type_node[service_hash[:service_owner]]
       if engine_node.is_a?(Tree::TreeNode) == false
         engine_node = Tree::TreeNode.new(service_hash[:service_owner], service_hash[:service_owner])
         service_type_node << engine_node
       end
       service_node = engine_node[service_hash[:service_handle]]
       if service_node.is_a?(Tree::TreeNode) == false
         SystemUtils.debug_output(:create_new_share_regstry_entry, service_hash)
         service_node = Tree::TreeNode.new(service_hash[:service_handle], service_hash)
         engine_node << service_node
       elsif is_persistent?(service_hash) == false
         SystemUtils.debug_output(:reattach_share_service_persistent_false, service_hash)
         service_node.content = service_hash
       else
         p :failed
         log_error_mesg('Service share Node existed', service_hash[:service_handle])
         log_error_mesg('Cannot over write persistent Share service in services tree' + service_node.content.to_s + ' with ', service_hash)
         # service_node = Tree::TreeNode.new(service_hash[:parent_engine],service_hash)
         # service_type_node << service_node
       end
       # FIXME: need to handle updating service
       return true
     rescue StandardError => e
       puts e.message
       log_exception(e)
     end


  
 
  
end
