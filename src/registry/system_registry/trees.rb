module Trees
  # @return the ManagedServices Tree [TreeNode] Branch
  #  creates if does not exist
  def services_registry_tree
    return false if !check_system_registry_tree
    system_registry_tree << Tree::TreeNode.new('Services', 'Service register') unless system_registry_tree['Services'].is_a?(Tree::TreeNode)
     system_registry_tree['Services']
  rescue StandardError => e
    log_exception(e)
    return false
  end

  def  shares_registry_tree
    return false if !check_system_registry_tree
    system_registry_tree << Tree::TreeNode.new('Shares', 'Service Shares') unless system_registry_tree['Shares'].is_a?(Tree::TreeNode)
     system_registry_tree['Shares']
  rescue StandardError => e
    log_exception(e)
    return false
  end

  # @return the ManagedEngine Tree Branch
  # creates if does not exist
  def managed_engines_registry_tree
    return false if !check_system_registry_tree
    system_registry_tree << Tree::TreeNode.new('ManagedEngine', 'ManagedEngine Service register') if !system_registry_tree['ManagedEngine'].is_a?(Tree::TreeNode)
    system_registry_tree['ManagedEngine']
  rescue StandardError => e
    log_exception(e)
  end
  def check_system_registry_tree
    st = system_registry_tree
    return SystemUtils.log_error_mesg('Nil service tree ?', st) if !st.is_a?(Tree::TreeNode)
    return true
  rescue StandardError => e
    log_exception(e)
  end
end