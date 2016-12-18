require_relative 'utils.rb'

get '/v0/system_registry/engines/tree' do
  process_result(system_registry.managed_engines_registry_tree)
end

get '/v0/system_registry/engine/service/' do
  process_result(system_registry.find_engine_service_hash(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/engine/services/' do
  process_result(system_registry.find_engine_services_hashes(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/engine/services/nonpersistent/' do
  STDERR.puts( ' non persist ' + params.to_s)
  process_result(system_registry.get_engine_nonpersistent_services(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/engine/services/persistent/' do
  process_result(system_registry.get_engine_persistent_services(RegistryUtils.symbolize_keys(params)))
end

post '/v0/system_registry/engine/services/add' do
  process_result(system_registry.add_to_managed_engines_registry(RegistryUtils.symbolize_keys(params)))
end

delete '/v0/system_registry/engine/services/del' do
  process_result( system_registry.remove_from_managed_engines_registry(RegistryUtils.symbolize_keys(params)))
end

put '/v0/system_registry/engine/service/update' do
  process_result( system_registry.update_managed_engine_service(RegistryUtils.symbolize_keys(params)))
end 