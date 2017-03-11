module Engines
  # ENGINE STUFF
  def find_engine_services_hashes(params)
    clear_error
    @managed_engines_registry.find_engine_services_hashes(params)
  rescue StandardError => e
    handle_exception(e)
    # STDERR.puts("FIND_engine_services_hashes " + r.to_s)
    # test_engines_registry_result(r)
  end

  def find_engine_service_hash(params)
    clear_error
    @managed_engines_registry.find_engine_service_hash(params)
  rescue StandardError => e
    handle_exception(e)
  end

  def get_engine_nonpersistent_services(params)
    clear_error
    @managed_engines_registry.get_engine_persistence_services(params, false)
  rescue StandardError => e
    handle_exception(e)
  end

  def get_engine_persistent_services(params)
    clear_error
    @managed_engines_registry.get_engine_persistence_services(params, true)
  rescue StandardError => e
    handle_exception(e)
  end

  def remove_from_managed_engines_registry(service_hash)
    take_snap_shot
    return save_tree if @managed_engines_registry.remove_from_engine_registry(service_hash)
    roll_back
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

  def all_engines_registered_to(service_path)
    clear_error
    @managed_engines_registry.all_engines_registered_to(service_path)
  rescue StandardError => e
    handle_exception(e)
  end

  def add_to_managed_engines_registry(service_hash)
    take_snap_shot
    return save_tree if @managed_engines_registry.add_to_managed_engines_registry(service_hash)
    roll_back
  rescue StandardError => e
    roll_back
    handle_exception(e)

  end

end