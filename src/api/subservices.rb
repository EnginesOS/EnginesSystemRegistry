get '/v0/system_registry/sub_services/tree' do
  # process_result(RegistryUtils.as_hash(system_registry.subservices_registry_tree))
  process_result(registry_as_hash(system_registry.subservices_registry_tree))
end

get '/v0/system_registry/sub_service/consumers/is_registered/:service_name/:engine_name/:service_handle/:sub_handle' do
  cparams = assemble_params(params,  [:service_name, :engine_name, :service_handle, :sub_handle])
  return params if params.is_a?(EnginesError)
  process_result(system_registry.subservice_is_registered?(params))
end

get '/v0/system_registry/sub_service/consumers/:service_name/:engine_name/:service_handle/:sub_handle' do
  cparams = assemble_params(params,  [:service_name, :engine_name, :service_handle, :sub_handle])
  return params if params.is_a?(EnginesError)
  process_result(system_registry.get_subservice_entry(params))
end

post '/v0/system_registry/sub_service/consumers/:service_name/:engine_name/:service_handle/:sub_handle]' do
  cparams = assemble_params(params, [:service_name, :engine_name, :service_handle, :sub_handle], nil ,:all)
  return params if params.is_a?(EnginesError)
  process_result(system_registry.update_attached_subservice(params))
end

get '/v0/system_registry/sub_services/consumers/:service_name/:engine_name/:service_handle' do
  cparams = assemble_params(params, [:service_name],nil,[:engine_name, :service_handle])
  return params if params.is_a?(EnginesError)
  process_result(system_registry.all_subservices_registered_to(params))
end

delete '/v0/system_registry/sub_services/consumers/:service_name/:engine_name/:service_handle/:sub_handle' do
  cparams = assemble_params(params,  [:service_name, :engine_name, :service_handle, :sub_handle])
  return params if params.is_a?(EnginesError)
  process_result(system_registry.remove_from_subservices_registry(params))
end

post '/v0/system_registry/sub_services/consumers/:service_name/:engine_name/:service_handle/:sub_handle' do
  cparams = assemble_params(params,  [:service_name, :engine_name, :service_handle, :sub_handle], nil ,:all)
  return params if params.is_a?(EnginesError)
  process_result(system_registry.add_to_subservices_registry(params))
end

get '/v0/system_registry/sub_service/providers/:service_handle/:publisher_namespace/*' do
  params[:type_path] = params['splat'][0]
  cparams = assemble_params(params, [:publisher_namespace,:type_path,:service_handle])
  process_result(system_registry.find_subservice_provider(params))
end

get '/v0/system_registry/sub_services/providers/:publish_namespace/*' do
  params[:type_path] = params['splat'][0]
  cparams = assemble_params(params, [:publisher_namespace,:type_path])
  process_result(system_registry.find_subservice_providers(params))
end

