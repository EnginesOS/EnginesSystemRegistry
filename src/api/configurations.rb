get '/v0/system_registry/services/configurations/tree' do
  process_result(registry_as_hash(system_registry.service_configurations_registry_tree))
end

get '/v0/system_registry/service/configurations/:service_name' do
  #STDERR.puts("get service cofngi params " + params.to_s)
  cparams =  assemble_params(params, [:service_name])
  process_result(system_registry.get_service_configurations_hashes(cparams[:service_name]))
end

get '/v0/system_registry/service/configuration/:service_name/:configurator_name' do
  cparams =  assemble_params(params, [:configurator_name,:service_name])
  process_result(system_registry.get_service_configuration(cparams))
end

post '/v0/system_registry/service/configurations/add/:service_name/:configurator_name' do
  params.merge!(post_params(request))
  STDERR.puts( ' add to configuration ' + params.to_s )
  cparams = assemble_params(params, [:service_name,:configurator_name],  nil, :all)
  cparams[:no_save] = false unless cparams.key?(:no_save) 
   STDERR.puts( ' add to configuration ' + cparams.to_s )
  process_result(system_registry.add_service_configuration(cparams))
end

post '/v0/system_registry/service/configuration/update/:service_name/:configurator_name' do
  params.merge!(post_params(request))
  STDERR.puts( 'update to configuration ' + params.to_s )
  cparams =  assemble_params(params, [:service_name,:configurator_name],  nil,:all)
   STDERR.puts( ' update to configuration ' + cparams.to_s )
  process_result(system_registry.update_service_configuration(cparams))
end

delete '/v0/system_registry/service/configurations/del/:service_name/:configurator_name' do
  cparams =  assemble_params(params, [:configurator_name,:service_name])
  process_result(system_registry.rm_service_configuration(cparams))
end
