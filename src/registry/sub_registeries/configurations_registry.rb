class ConfigurationsRegistry < SubRegistry
  require_relative '../../errors/engines_exception.rb'
  def get_service_configurations_hashes(service_name)
    st = match_node_keys(@registry, {service_name: service_name}, [:service_name])
    unless st.is_a?(Tree::TreeNode)
      false
    else
      get_all_leafs_service_hashes(st)
    end
  end

  # add the service configuration in the [Hash] service_configuration_hash
  # required keys are :service_name :configurator_name :publisher_namespace :type_path :variables
  def add_service_configuration(config_hash)
    #  STDERR.puts('add_service_configuration ' + config_hash.to_s + ' ' + config_hash[:configurator_name].to_s  + ':' + [:service_name].to_s)
    add_to_tree_path(@registry, config_hash, [:service_name], config_hash[:configurator_name])
  end

  # Remove service configuration matching the [Hash] service_configuration_hash
  # required keys are :service_name :configurator_name
  # @return boolean indicating failure
  #
  def rm_service_configuration(config_hash)
    st = match_node_keys(@registry, config_hash, full_address)
    remove_tree_entry(st) if st.is_a?(Tree::TreeNode)
  end

  def update_service_configuration(config_hash)
    st = match_node_keys(@registry, config_hash, full_address)
    unless st.is_a?(Tree::TreeNode)
      add_service_configuration(config_hash)
    else
      st.content = config_hash     
    end
  end

  # @return a service_configuration_hash addressed by :service_name :configuration_name
  def get_service_configuration(config_hash)
    st = match_node_keys(@registry, config_hash, full_address)
    unless st.is_a?(Tree::TreeNode)
      {}
    else
      st.content
    end
  end

  private

  def full_address
    @full_address ||= [:service_name, :configurator_name]
  end

end
