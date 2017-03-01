

get '/v0/system_registry/services/configurations/tree' do
  process_result(RegistryUtils.as_hash(system_registry.service_configurations_registry_tree))
end

get '/v0/system_registry/service/configurations/:service_name' do
  # STDERR.puts("get service cofngi params " + params.to_s)
  cparams =  RegistryUtils::Params.assemble_params(params, [:service_name],  :all,nil)
  process_result(system_registry.get_service_configurations_hashes(cparams[:service_name]))
end

get '/v0/system_registry/services/configuration/:service_name/:configurator_name' do
    cparams =  RegistryUtils::Params.assemble_params(params, [:configurator_name,:service_name], :all,nil)
  process_result(system_registry.get_service_configuration(cparams))
end

post '/v0/system_registry/services/configurations/add/:service_name/:configurator_name/:publisher_namespace/*' do
  #  STDERR.puts( ' ADD to configurations ' + params.to_s + ' parsed as ' +  p_params.to_s)
  splats = params['splat']
   params[:type_path] =   splats[0] 
  p_params = post_params(request)
  params.merge!(p_params)
  cparams =  RegistryUtils::Params.assemble_params(params, [:service_name,:configurator_name,:publisher_namespace,:type_path],  :all,:all)
 # STDERR.puts( ' add to configuration ' + cparams.to_s )
#  p_params = post_params(request)
#  p_params.merge(params)
  process_result(system_registry.add_service_configuration(cparams))
end

post '/v0/system_registry/services/configuration/update/:service_name/:configurator_name/:publisher_namespace/*' do
  #  STDERR.puts( ' update to configuration ' + params.to_s )
#  p_params = post_params(request)
#  p_params.merge(params)
  splats = params['splat']
   params[:type_path] =   splats[0] 
  p_params = post_params(request)
   params.merge!(p_params)
   cparams =  RegistryUtils::Params.assemble_params(params, [:service_name,:configurator_name,:publisher_namespace,:type_path],  :all,:all)
 # STDERR.puts( ' update to configuration ' + cparams.to_s + ':' + params.to_s)
  process_result(system_registry.update_service_configuration(cparams))
end

delete '/v0/system_registry/services/configurations/del/:service_name/:configurator_name' do
  cparams =  RegistryUtils::Params.assemble_params(params, [:configurator_name,:service_name], :all,nil)
  process_result(system_registry.rm_service_configuration(cparams))
end
