class ConfigurationsRegistry < SubRegistry
  # @return [Array] of configurations registered against service_name
  # return empty [Array] if none
  def get_service_configurations_hashes(service_name)
    st = match_node_keys(@registry, {service_name: service_name}, [:service_name])
  return false unless st.is_a?(Tree::TreeNode)
      get_all_leafs_service_hashes(st)
  # configs_node = get_service_configurations(service_name)
  # return false unless configs_node.is_a?(Tree::TreeNode)
  #  get_all_leafs_service_hashes(configs_node)
  end

  # add the service configuration in the [Hash] service_configuration_hash
  # required keys are :service_name :configurator_name :publisher_namespace :type_path :variables
  def add_service_configuration(config_hash)
    
    add_to_tree_path(@registry, config_hash, [:service_name], :configurator_name)
    
#    configs_node = get_service_configurations(config_hash[:service_name])
#    if !configs_node.is_a?(Tree::TreeNode)
#      configs_node = Tree::TreeNode.new(config_hash[:service_name], ' Configurations for:' + config_hash[:service_name])
#      @registry << configs_node
#    elsif configs_node[config_hash[:configurator_name]]
#      return log_error('Sub Service already exists ', params)
#    end
#    config_node = Tree::TreeNode.new(config_hash[:configurator_name], config_hash)
#    configs_node << config_node
#    true
  end

  # Remove service configuration matching the [Hash] service_configuration_hash
  # required keys are :service_name :configurator_name
  # @return boolean indicating failure
  #
  def rm_service_configuration(service_configuration_hash)
  #  service_configurations = get_service_configurations(service_configuration_hash[:service_name])
   # return false unless service_configurations.is_a?(Tree::TreeNode)
  #  return false unless service_configuration_hash.key?( :configurator_name )
  #  service_configuration = service_configurations[service_configuration_hash[:configurator_name]]
  st = match_node_keys(@registry, service_configuration_hash, [:service_name, :configurator_name])
    return remove_tree_entry(st) if st.is_a?(Tree::TreeNode)
  end

  def update_service_configuration(service_configuration_hash)
#    service_configurations = get_service_configurations(service_configuration_hash[:service_name])
#    return add_service_configuration(service_configuration_hash) unless service_configurations.is_a?(Tree::TreeNode)
#    return false unless service_configuration_hash.key?(:configurator_name)
#    service_configuration = service_configurations[service_configuration_hash[:configurator_name]]
#    if service_configuration.is_a?(Tree::TreeNode)
#      service_configuration.content = service_configuration_hash
#      return true
#    else
#      return add_service_configuration(service_configuration_hash)
#    end
#    false
    st = match_node_keys(@registry, service_configuration_hash, [:service_name, :configurator_name])
    st.content = service_configuration_hash
    true
  end

  # @return a service_configuration_hash addressed by :service_name :configuration_name
  def get_service_configuration(service_configuration_hash)
#    service_configurations = get_service_configurations(service_configuration_hash[:service_name])
#    return false unless service_configurations.is_a?(Tree::TreeNode)
#    return get_all_leafs_service_hashes(service_configurations) if !service_configuration_hash.key?(:configurator_name)
#    service_configuration = service_configurations[service_configuration_hash[:configurator_name]]
#    return service_configuration.content if service_configuration.is_a?(Tree::TreeNode)
#    false
    st = match_node_keys(@registry, service_configuration_hash, [:service_name, :configurator_name])
    return false unless st.is_a?(Tree::TreeNode)
    st.content
  end

  private

#  # @return an [Array] of Service Configuration [Hash]es of all the service configurations for [String] service_name
#  def get_service_configurations(service_name)
#    return false unless @registry.is_a?(Tree::TreeNode)
#    service_configurations = @registry[service_name]
#    return service_configurations if service_configurations.is_a?(Tree::TreeNode)
#    false
#  end
  
end
