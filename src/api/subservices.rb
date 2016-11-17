require_relative 'utils.rb'

get '/v0/system_registry/subservices/tree' do
  process_result(system_registry.subservices_registry_tree)
end

get '/v0/system_registry/subservice/registered/engines/' do
  process_result(system_registry.all_subservices_registered_to(RegistryUtils.symbolize_keys(params)[:subservice_type]))
end

get '/v0/system_registry/subservice/consumers/' do
  process_result(system_registry.find_subservice_consumers(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/subservice/registered/' do
  process_result(system_registry.get_subservices_registered_against_service(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/subservice/' do
  process_result(system_registry.get_subservice_entry(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/subservice/is_registered' do
  process_result(system_registry.subservice_is_registered?(RegistryUtils.symbolize_keys(params)))
end

post '/v0/system_registry/subservices/add' do
  process_result(system_registry.add_to_subservices_registry(RegistryUtils.symbolize_keys(params)))
end

put '/v0/system_registry/subservice/update' do
  process_result(system_registry.update_attached_subservice(RegistryUtils.symbolize_keys(params)))
end

delete '/v0/system_registry/subservices/del' do
  process_result(system_registry.remove_from_subservices_registry(RegistryUtils.symbolize_keys(params)))
end

