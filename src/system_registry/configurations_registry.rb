class ConfigurationsRegistry < SubRegistry
  # @return an [Array] of Service Configuration [Hash]es of all the service configurations for [String] service_name
  def get_service_configurations(service_name)
    return false if !@registry.is_a?(Tree::TreeNode)
    service_configurations = @registry[service_name]
  return service_configurations if service_configurations.is_a?(Tree::TreeNode)
    return false
  end

  def get_service_configurations_hashes(service_name)
    configurations = get_service_configurations(service_name)
    return [] if !configurations.is_a?(Tree::TreeNode)
    leafs = get_all_leafs_service_hashes(configurations)
  end

  # @return a service_configuration_hash addressed by :service_name :configuration_name
  def get_service_configuration(service_configuration_hash)
    service_configurations = get_service_configurations(service_configuration_hash[:service_name])
    return false if !service_configurations.is_a?(Tree::TreeNode)
    return get_all_leafs_service_hashes(service_configurations) if !service_configuration_hash.key?(:configurator_name)
    service_configuration = service_configurations[service_configuration_hash[:configurator_name]]
    return service_configuration.content if service_configuration.is_a?(Tree::TreeNode)
    return false
  end

  def add_service_configuration(service_configuration_hash)
    configurations = get_service_configurations(service_configuration_hash[:service_name])
    if !configurations.is_a?(Tree::TreeNode)
      configurations = Tree::TreeNode.new(service_configuration_hash[:service_name], ' Configurations for :' + service_configuration_hash[:service_name])
      @registry << configurations
    elsif configurations[service_configuration_hash[:configurator_name]]
      return false 
    end
    configuration = Tree::TreeNode.new(service_configuration_hash[:configurator_name], service_configuration_hash)
    configurations << configuration
    return true
  end

  def rm_service_configuration(service_configuration_hash)
    service_configurations = get_service_configurations(service_configuration_hash[:service_name])
    return false if !service_configurations.is_a?(Tree::TreeNode)
    return false if !service_configuration_hash.key?(:configurator_name)    
    service_configuration = service_configurations[service_configuration_hash[:configurator_name]]
    return remove_tree_entry(service_configuration) if service_configuration.is_a?(Tree::TreeNode) 
  end

  def update_service_configuration(service_configuration_hash)
    service_configurations = get_service_configurations(service_configuration_hash[:service_name])
    return add_service_configuration(service_configuration_hash) if !service_configurations.is_a?(Tree::TreeNode)
    return false if !service_configuration_hash.key?(:configurator_name)
    service_configuration = service_configurations[service_configuration_hash[:configurator_name]]
    if service_configuration.is_a?(Tree::TreeNode)
      service_configuration.content = service_configuration_hash
      return true
    else
      return add_service_configuration(service_configuration_hash)
    end
  end
end
