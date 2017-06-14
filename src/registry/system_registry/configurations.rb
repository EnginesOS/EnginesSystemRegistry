module Configurations
  def service_configurations_registry_tree
    return false if !check_system_registry_tree
    system_registry_tree << Tree::TreeNode.new('Configurations', 'Service Configurations') if system_registry_tree['Configurations'].nil?
    system_registry_tree['Configurations']
  rescue StandardError => e
    handle_exception(e)
  end

  def get_service_configurations_hashes(service_hash)
    @configuration_registry.get_service_configurations_hashes(service_hash)
  rescue StandardError => e
    handle_exception(e)
  end

  def add_service_configuration(service_hash)
    take_snap_shot
    return save_tree if @configuration_registry.add_service_configuration(service_hash)
    unlock_tree
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

  def rm_service_configuration(service_hash)
    take_snap_shot
    save_tree if @configuration_registry.rm_service_configuration(service_hash)
    unlock_tree
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

  def get_service_configuration(service_hash)
    @configuration_registry.get_service_configuration(service_hash)
  rescue StandardError => e
    handle_exception(e)
  end

  def update_service_configuration(config_hash)
    take_snap_shot
    return save_tree if @configuration_registry.update_service_configuration(config_hash)
    unlock_tree
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

end