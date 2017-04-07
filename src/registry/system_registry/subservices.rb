module Subservices
  def subservices_registry_tree
    return false if !check_system_registry_tree
    orphans = system_registry_tree['SubServices']
    system_registry_tree << Tree::TreeNode.new('SubServices', 'Services attached to Services') if !orphans.is_a?(Tree::TreeNode)
    system_registry_tree['SubServices']
  rescue StandardError => e
    log_exception(e)
     nil
  end

  def all_subservices_registered_to(params)
    @subservices_registry.all_subservices_registered_to(params)
    rescue StandardError => e
      handle_exception(e)
  end

  def find_subservice_providers(params)
    @subservices_registry.find_subservice_providers(params)
    rescue StandardError => e
      handle_exception(e)
  end

  def find_subservice_provider(params)
    @subservices_registry.get_subservices_registered_against_service(params)
    rescue StandardError => e
      handle_exception(e)
  end

  def get_subservice_entry(params)
    @subservices_registry.get_subservice_entry(params)
    rescue StandardError => e
      handle_exception(e)
  end

  def subservice_is_registered?(params)
    @subservices_registry.subservice_is_registered(params)
    rescue StandardError => e
      handle_exception(e)
  end

  def add_to_subservices_registry(params)
    take_snap_shot
    return save_tree if @subservices_registry.add_to_subservices_registry(params)
    roll_back
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

  def update_attached_subservice(params)
    take_snap_shot
    return save_tree if @subservices_registry.update_attached_subservice(params)
    roll_back
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

  def remove_from_subservices_registry()
    take_snap_shot
    return save_tree if @subservices_registry.remove_from_subservices_registry(params)
    roll_back
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

end