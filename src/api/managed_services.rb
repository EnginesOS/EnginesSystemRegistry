require_relative 'utils.rb'

get '/v0/system_registry/services/tree' do
  process_result(system_registry.services_registry_tree)
end
# clear_service_from_registry(service_hash)
delete '/v0/system_registry/services/clear' do
  process_result(system_registry.clear_service_from_registry(RegistryUtils.symbolize_keys(params)))
end
get '/v0/system_registry/service/registered/engines/' do
  process_result(system_registry.all_engines_registered_to(RegistryUtils.symbolize_keys(params)[:service_type]))
end

get '/v0/system_registry/service/consumers/' do
  process_result(system_registry.find_service_consumers(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/service/registered/' do
  process_result(system_registry.get_registered_against_service(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/services/providers/in_use/' do
  process_result(system_registry.list_providers_in_use())
end

get '/v0/system_registry/service/' do
  process_result(system_registry.get_service_entry(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/service/is_registered' do
  process_result(system_registry.service_is_registered?(RegistryUtils.symbolize_keys(params)))
end

post '/v0/system_registry/services/add' do
  STDERR.puts( ' ADD to services ' + params.to_s + ' parsed as '  + RegistryUtils.symbolize_keys(params).to_s)
  process_result(system_registry.add_to_services_registry(RegistryUtils.symbolize_keys(params)))
end

put '/v0/system_registry/service/update' do
  process_result(system_registry.update_attached_service(RegistryUtils.symbolize_keys(params)))
end

delete '/v0/system_registry/services/del' do
  process_result(system_registry.remove_from_services_registry(RegistryUtils.symbolize_keys(params)))
end

