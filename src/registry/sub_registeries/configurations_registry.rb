class ConfigurationsRegistry < SubRegistry
  require_relative '../../errors/engines_exception.rb'
  def get_service_configurations_hashes(service_name)
    st = match_node_keys(@registry, {service_name: service_name}, [:service_name])
    return false unless st.is_a?(Tree::TreeNode)
    get_all_leafs_service_hashes(st)
  end

  # add the service configuration in the [Hash] service_configuration_hash
  # required keys are :service_name :configurator_name :publisher_namespace :type_path :variables
  def add_service_configuration(config_hash)
    add_to_tree_path(@registry, config_hash, [:service_name], config_hash[:configurator_name])
  end

  # Remove service configuration matching the [Hash] service_configuration_hash
  # required keys are :service_name :configurator_name
  # @return boolean indicating failure
  #
  def rm_service_configuration(service_configuration_hash)
    st = match_node_keys(@registry, service_configuration_hash, full_address)
    return remove_tree_entry(st) if st.is_a?(Tree::TreeNode)
  end

  def update_service_configuration(service_configuration_hash)
    st = match_node_keys(@registry, service_configuration_hash, full_address)
    return add_service_configuration(service_configuration_hash) unless st.is_a?(Tree::TreeNode)
    st.content = service_configuration_hash
    true
  end

  # @return a service_configuration_hash addressed by :service_name :configuration_name
  def get_service_configuration(service_configuration_hash)
    st = match_node_keys(@registry, service_configuration_hash, full_address)
    return false unless st.is_a?(Tree::TreeNode)
    st.content
  end

  private

  def full_address
    @full_address |= [:service_name, :configurator_name]
  end

end
