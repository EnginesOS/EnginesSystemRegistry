get '/v0/system_registry/services/orphans/tree' do
  process_result(RegistryUtils.as_hash(system_registry.orphaned_services_registry_tree))
end

post '/v0/system_registry/services/orphans/add/:parent_engine/:service_handle/:publisher_namespace/*' do
  splats = params['splat']
  params[:type_path] =   splats[0] 
  p_params = post_params(request)
  params.merge(p_params)
STDERR.puts('New ORPHAN ' +  p_params.to_s + ' _ ' + params.to_s)
  cparams =  RegistryUtils::Params.assemble_params(cparams, [:parent_engine,:service_handle,:publisher_namespace,:type_path])
  #cparams.merge(params)

  process_result(system_registry.orphanate_service(cparams ))
end

post '/v0/system_registry/services/orphans/return/:parent_engine/:service_handle/:publisher_namespace/*' do
  p_params = post_params(request)
  p_params = params['splat']
  p_params.merge(params)
  p_params[:type_path] =   splats[0]
  cparams =  RegistryUtils::Params.assemble_params(p_params, [:parent_engine,:service_handle,:publisher_namespace,:type_path],  :all)
  process_result(system_registry.rollback_orphaned_service(RegistryUtils.symbolize_keys(cparams)))

end

delete '/v0/system_registry/services/orphans/del/:service_handle/:parent_engine/:publisher_namespace/*' do
  splats = params['splat']

  params[:type_path] =   splats[0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:parent_engine,:service_handle,:type_path,:publisher_namespace])
  process_result(system_registry.release_orphan(cparams))
end

get '/v0/system_registry/services/orphans/:publisher_namespace/*' do
  splats = params['splat']
  params[:type_path] =   splats[0]
STDERR.puts('GET ORPHANS ' +   params.to_s)
  cparams =  RegistryUtils::Params.assemble_params(params, [:type_path,:publisher_namespace])
  process_result(system_registry.get_orphaned_services(cparams))
end

get '/v0/system_registry/services/orphan/:parent_engine/:service_handle/:publisher_namespace/*' do
  splats = params['splat']
  params[:type_path] =   splats[0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:parent_engine,:service_handle,:type_path,:publisher_namespace])
  STDERR.puts( 'ORPHAN get params ' + cparams.to_s)
  process_result(system_registry.retrieve_orphan(cparams))
end
#reparent_orphan

#rebirth_orphan

