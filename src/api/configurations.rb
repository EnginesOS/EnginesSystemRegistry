require_relative 'utils.rb'

get '/v0/system_registry/services/configurations/tree' do
  process_result(RegistryUtils.as_hash(system_registry.service_configurations_registry_tree))
end

get '/v0/system_registry/service/configurations/:service_name' do
 # STDERR.puts("get service cofngi params " + params.to_s)
  process_result(system_registry.get_service_configurations_hashes(params[:service_name]))
end

get '/v0/system_registry/services/configuration/:service_name/:configurator_name' do
  process_result(system_registry.get_service_configuration(params))
end

post '/v0/system_registry/services/configurations/add/:service_name/:configurator_name' do
#  STDERR.puts( ' ADD to configurations ' + params.to_s + ' parsed as ' +  p_params.to_s)
 p_params = post_params(request)
  p_params.merge(params)
  process_result(system_registry.add_service_configuration(p_params))
end

post '/v0/system_registry/services/configuration/update/:service_name/:configurator_name' do
#  STDERR.puts( ' update to configuration ' + params.to_s )
  p_params = post_params(request)
  p_params.merge(params)
  process_result(system_registry.update_service_configuration(RegistryUtils.symbolize_keys(p_params ) ))
end

delete '/v0/system_registry/services/configurations/del/:service_name/:configurator_name' do
  process_result(system_registry.rm_service_configuration(RegistryUtils.symbolize_keys(params)))
end
