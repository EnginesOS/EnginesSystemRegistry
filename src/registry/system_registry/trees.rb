module Trees
  # @return the ManagedServices Tree [TreeNode] Branch
   #  creates if does not exist
   def services_registry_tree
     clear_error
     return false if !check_system_registry_tree
     system_registry_tree << Tree::TreeNode.new('Services', 'Service register') unless system_registry_tree['Services'].is_a?(Tree::TreeNode)
     return system_registry_tree['Services']
   rescue StandardError => e
     log_exception(e)
     return false
   end
 
 
 
   # @return the ManagedEngine Tree Branch
   # creates if does not exist
   def managed_engines_registry_tree
     clear_error
     return false if !check_system_registry_tree
     system_registry_tree << Tree::TreeNode.new('ManagedEngine', 'ManagedEngine Service register') if !system_registry_tree['ManagedEngine'].is_a?(Tree::TreeNode)
     system_registry_tree['ManagedEngine']
   rescue StandardError => e
     log_exception(e)
   end

end