class Protocol
  
  #requests
  #
  #general Getters
  #
  
  # find_engine_services(params)
  # find_engine_services_hashes
  # get_engine_nonpersistant_services(params)
  # get_engine_persistant_services(params)
  # remove_from_managed_engines_registry(service_hash)
  # add_to_managed_engines_registry(service_hash)
  #
  # save_as_orphan(params)
  # release_orphan(params)
  # reparent_orphan(params)
  # retrieve_orphan(params)
  # get_orphaned_services(params)
  # find_orphan_consumers(params)
  # orphan_service(service_hash)
  #
  # find_service_consumers(service_query_hash)
  # update_attached_service(service_hash)
  # add_to_services_registry(service_hash)
  # remove_from_services_registry
  # service_is_registered?(service_hash)
  # get_registered_against_service(params)
  # 
  # get_service_configurations_hashes(service_hash)
  # update_service_configuration(config_hash)
  # list_providers_in_use
  #
  # system_registry_tree
  # service_configurations_registry
  # orphaned_services_registry
  # services_registry
  # managed_engines_registry 
end