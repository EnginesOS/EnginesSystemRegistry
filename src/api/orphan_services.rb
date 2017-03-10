get '/v0/system_registry/services/orphans/tree' do
  # process_result(RegistryUtils.as_hash(system_registry.orphaned_services_registry_tree))
  process_result($system_registry.registry_as_hash(system_registry.orphaned_services_registry_tree))
end

post '/v0/system_registry/services/orphans/add/:parent_engine/:service_handle/:publisher_namespace/*' do
  # splats = params['splat']
  params[:type_path] = params['splat'][0]
  params.merge!(post_params(request))
  params = assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path],  :all,:all)
  process_result(system_registry.orphanate_service(params ))
end

post '/v0/system_registry/services/orphans/return/:parent_engine/:service_handle/:publisher_namespace/*' do
  #  splats = params['splat']
  params[:type_path] =  params['splat'][0]
  params.merge!(post_params(request))
  params =  assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path],  :all,:all)
  process_result(system_registry.rollback_orphaned_service(params))
end

delete '/v0/system_registry/services/orphans/del/:service_handle/:parent_engine/:publisher_namespace/*' do
  # splats = params['splat']

  params[:type_path] =    params['splat'][0]
  params = assemble_params(params, [:parent_engine,:service_handle,:type_path,:publisher_namespace])
  process_result(system_registry.release_orphan(params))
end

get '/v0/system_registry/services/orphans/:publisher_namespace/*' do
  # splats = params['splat']
  params[:type_path] =  params['splat'][0]
  #  STDERR.puts('GET ORPHANS ' +   params.to_s)
  params = assemble_params(params, [:type_path,:publisher_namespace])
  process_result(system_registry.get_orphaned_services(params))
end

get '/v0/system_registry/services/orphan/:parent_engine/:service_handle/:publisher_namespace/*' do
  # splats = params['splat']
  params[:type_path] =  params['splat'][0]
  params = assemble_params(params, [:parent_engine,:service_handle,:type_path,:publisher_namespace])
  # STDERR.puts( 'ORPHAN get params ' + cparams.to_s)
  process_result(system_registry.retrieve_orphan(params))
end
#reparent_orphan

#rebirth_orphan

