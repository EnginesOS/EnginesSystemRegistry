get '/v0/system_registry/subservices/tree' do
  # process_result(RegistryUtils.as_hash(system_registry.subservices_registry_tree))
  process_result($system_registry.registry_as_hash(system_registry.subservices_registry_tree))
end

## sub services list  belonging to this service (container_name)
#get '/v0/system_registry/subservices/registered/:service_name' do
#  cparams = RegistryUtils::Params.assemble_params(params, [:service_name], nil,[:engine_name,:service_handle,:sub_hand])
#  process_result(system_registry.all_subservices_registered_to(cparams))
#end

# sub services by ns and path
get '/v0/system_registry/subservices/consumers/:publisher_namespace/*' do
  params[:type_path] = params['splat'][0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:publisher_namespace,:type_path])
  process_result(system_registry.find_subservice_consumers(cparams))
end

## sub services addtached to service (container_name) service_name
#get '/v0/system_registry/subservice/registered/:service_name/:publisher_namespace/*' do
#  cparams = RegistryUtils::Params.assemble_params(params, [:service_name], nil,[:engine_name,:service_handle,:sub_hand])
#  process_result(system_registry.all_subservices_registered_to(cparams))
#end

get '/v0/system_registry/subservice/is_registered/:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  cparams = RegistryUtils::Params.assemble_params(params, [:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path])
  params[:type_path] =    params['splat'][0]
  process_result(system_registry.subservice_is_registered?(params))
end

post '/v0/system_registry/subservices/add/engine/:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  params.merge!(post_params(request))
  params[:type_path] =    params['splat'][0]
  cparams = RegistryUtils::Params.assemble_params(params, [:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path],:all)
  process_result(system_registry.add_to_subservices_registry(cparams))
end

post '/v0/system_registry/subservice/update:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  params.merge!(post_params(request))
  cparams = RegistryUtils::Params.assemble_params(params, [:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path],:all)
  process_result(system_registry.update_attached_subservice(cparams))
end

delete '/v0/system_registry/subservices/del/:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  cparams = RegistryUtils::Params.assemble_params(params, [:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path])
  process_result(system_registry.remove_from_subservices_registry(params))
end

get '/v0/system_registry/subservices/:engine_name/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  cparams = RegistryUtils::Params.assemble_params(params, [:engine_name,:publisher_namespace,:type_path])
  process_result(system_registry.find_subservice_consumers(params))
end

get '/v0/system_registry/subservice/:engine_name/:service_handle/:sub_hand/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  cparams = RegistryUtils::Params.assemble_params(params, [:engine_name,:service_handle,:sub_hand,:publisher_namespace,:type_path])
  process_result(system_registry.find_subservice_consumers(params))
end

