module Engines
  # ENGINE STUFF
  def find_engine_services_hashes(params)
    @managed_engines_registry.find_engine_services_hashes(params)
#  rescue StandardError => e
#    handle_exception(e)
  end

  def find_engine_service_hash(params)
    @managed_engines_registry.find_engine_service_hash(params)
#  rescue StandardError => e
#    handle_exception(e)
  end

  def get_engine_nonpersistent_services(params)
    @managed_engines_registry.get_engine_persistence_services(params, false)
#  rescue StandardError => e
#    handle_exception(e)
  end

  def get_engine_persistent_services(params)
    @managed_engines_registry.get_engine_persistence_services(params, true)
#  rescue StandardError => e
#    handle_exception(e)
  end

  def remove_from_managed_engines_registry(service_hash)
    take_snap_shot
    if @managed_engines_registry.remove_from_engine_registry(service_hash)
      save_tree
    else
      unlock_tree
    end
  rescue StandardError => e
    roll_back
    raise e
  end

  def all_engines_registered_to(service_path)
    if service_path.is_a?(Hash)
      service_path = service_path[:service_type]
    end
    @managed_engines_registry.all_engines_registered_to(service_path)
#  rescue StandardError => e
#    handle_exception(e)
  end

  #  def update_engine_service(service_hash)
  #    take_snap_shot
  #    return save_tree if @managed_engines_registry.update_engine_service(service_hash)
  #    roll_back
  #  rescue StandardError => e
  #    roll_back
  #    handle_exception(e)
  #  end

  def add_to_managed_engines_registry(service_hash)
    take_snap_shot
    if @managed_engines_registry.add_to_managed_engines_registry(service_hash)
      save_tree
    else
      unlock_tree
    end
  rescue StandardError => e
    roll_back
    raise e
  end

end