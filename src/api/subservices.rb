get '/v0/system_registry/subservices/tree' do
  # process_result(RegistryUtils.as_hash(system_registry.subservices_registry_tree))
  process_result($system_registry.registry_as_hash(system_registry.subservices_registry_tree))
end

# sub services list to serices belonging to this engine
get '/v0/system_registry/subservices/registered/:service_name' do
  cparams =  RegistryUtils::Params.assemble_params(params, [:service_name])
  process_result(system_registry.all_subservices_registered_to(cparams))
end

# sub services by ns and path
get '/v0/system_registry/subservice/consumers/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:publisher_namespace,:type_path])
  process_result(system_registry.find_subservice_consumers(cparams))
end

# sub services addtached to service (container_name) service_name
get '/v0/system_registry/subservice/registered/:service_name' do
  cparams =  RegistryUtils::Params.assemble_params(params, [:service_name], nil,[:engine_name,:service_handle,:publisher_namespace,:type_path])
  process_result(system_registry.get_subservices_registered_against_service(cparams))
end

get '/v0/system_registry/subservice/is_registered/:service_name/:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:service_name,:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path])
  process_result(system_registry.subservice_is_registered?(params))
end

post '/v0/system_registry/subservices/add/:service_name/:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  params.merge!(post_params(request))
  cparams =  RegistryUtils::Params.assemble_params(params, [:service_name,:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path],:all)
  process_result(system_registry.add_to_subservices_registry(cparams))
end

post '/v0/system_registry/subservice/update/:service_name/:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  params.merge!(post_params(request))
  cparams =  RegistryUtils::Params.assemble_params(params, [:service_name,:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path],:all)
  process_result(system_registry.update_attached_subservice(cparams))
end

delete '/v0/system_registry/subservices/del/:service_name/:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:service_name,:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path])
  process_result(system_registry.remove_from_subservices_registry(params))
end

get '/v0/system_registry/subservice/:service_name/:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:service_name,:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path])
  process_result(system_registry.get_subservice_entry(params))
end

