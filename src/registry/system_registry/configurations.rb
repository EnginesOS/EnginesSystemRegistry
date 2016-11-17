module Configurations
  def service_configurations_registry_tree
    clear_error
    return false if !check_system_registry_tree
    system_registry_tree << Tree::TreeNode.new('Configurations', 'Service Configurations') if system_registry_tree['Configurations'].nil?
    system_registry_tree['Configurations']
  rescue StandardError => e
    log_exception(e)
    return nil
  end

  def get_service_configurations_hashes(service_hash)
    clear_error
    test_configurations_registry_result(@configuration_registry.get_service_configurations_hashes(service_hash))
  end

  def add_service_configuration(service_hash)
    take_snap_shot
    return save_tree if test_configurations_registry_result(@configuration_registry.add_service_configuration(service_hash))
    roll_back
  end

  def rm_service_configuration(service_hash)
    take_snap_shot
    return save_tree if test_configurations_registry_result(@configuration_registry.rm_service_configuration(service_hash))
    roll_back
  end

  def get_service_configuration(service_hash)
    clear_error
    test_configurations_registry_result(@configuration_registry.get_service_configuration(service_hash))
  end

  def update_service_configuration(config_hash)
    take_snap_shot
    return save_tree if test_configurations_registry_result(@configuration_registry.update_service_configuration(config_hash))
    roll_back
    return false
  end

end