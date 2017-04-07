module Services
  def find_service_consumers(service_query_hash)
    @services_registry.find_service_consumers(service_query_hash)

  end

  def clear_service_from_registry(p)
    #params[:parent_engine]  params :container_type] == 'service'
    #find  this services non persistent
    case p[:persistence]
    when 'non_persistent'
      services = get_engine_nonpersistent_services(p)
    when 'persistent'
      services = get_engine_persistent_services(p)
    when 'both'
      services = get_engine_services(p)
    end
    return true if services.nil?
    return services if services.is_a?(EnginesError)
    services.each do |service|
      remove_from_managed_engines_registry(service)
    end
  rescue StandardError => e
    handle_exception(e)
  end

  def get_service_entry(service_query_hash)
    tree_node = find_service_consumers(service_query_hash)
    return false  if !tree_node.is_a?(Tree::TreeNode)
    tree_node.content
  rescue StandardError => e
    handle_exception(e)
  end

  def add_to_services_registry(service_hash)
    take_snap_shot
    return save_tree if @services_registry.add_to_services_registry(service_hash)
    roll_back
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

  def remove_from_services_registry(service_hash)
    take_snap_shot
    return save_tree if @services_registry.remove_from_services_registry(service_hash)
    roll_back
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

  # @return an [Array] of service_hashes regsitered against the Service params[:publisher_namespace] params[:type_path]
  def get_registered_against_service(params)
    @services_registry.get_registered_against_service(params)
  rescue StandardError => e
    handle_exception(e)
  end

  def list_providers_in_use
    @services_registry.list_providers_in_use
  rescue StandardError => e
    handle_exception(e)
  end

  def service_is_registered?(service_hash)
    @services_registry.service_is_registered?(service_hash)
  rescue StandardError => e
    handle_exception(e)
  end

end