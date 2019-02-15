get '/v0/system_registry/sub_services/tree' do
  begin
    process_result(registry_as_hash(system_registry.subservices_registry_tree))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/sub_service/consumers/is_registered/:service_name/:engine_name/:service_handle/:sub_handle' do
  begin
    cparams = assemble_params(params, [:service_name, :engine_name, :service_handle, :sub_handle])
    process_result(system_registry.subservice_is_registered?(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/sub_service/consumers/:service_name/:engine_name/:service_handle/:sub_handle' do
  begin
    cparams = assemble_params(params, [:service_name, :engine_name, :service_handle, :sub_handle])
    process_result(system_registry.get_subservice_entry(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

post '/v0/system_registry/sub_service/consumers/:service_name/:engine_name/:service_handle/:sub_handle]' do
  begin
    params.merge!(post_params(request))
    cparams = assemble_params(params, [:service_name, :engine_name, :service_handle, :sub_handle], nil, :all)
    process_result(system_registry.update_attached_subservice(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/sub_services/consumers/:service_name/:engine_name/:service_handle' do
  begin
    cparams = assemble_params(params, [:service_name],nil,[:engine_name, :service_handle])
    process_result(system_registry.all_subservices_registered_to(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

delete '/v0/system_registry/sub_services/consumers/:service_name/:engine_name/:service_handle/:sub_handle' do
  begin
    cparams = assemble_params(params, [:service_name, :engine_name, :service_handle, :sub_handle])
    process_result(system_registry.remove_from_subservices_registry(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

post '/v0/system_registry/sub_services/consumers/:service_name/:engine_name/:service_handle/:sub_handle' do
  begin
    params.merge!(post_params(request))
    cparams = assemble_params(params, [:service_name, :engine_name, :service_handle, :sub_handle], nil, :all)
    process_result(system_registry.add_to_subservices_registry(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/sub_service/providers/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:publisher_namespace, :type_path, :service_handle])
    process_result(system_registry.find_subservice_provider(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/sub_services/providers/:publish_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:publisher_namespace, :type_path])
    process_result(system_registry.find_subservice_providers(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

