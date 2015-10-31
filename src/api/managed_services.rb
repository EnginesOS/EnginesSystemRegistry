require_relative 'utils.rb'

get '/system_registry/services/tree' do
  @@system_registry.services_registry_tree.to_json
end
 
get '/system_registry/service/registered/engines/' do
  @@system_registry.all_engines_registered_to(RegistryUtils.symbolize_keys(params)).to_json
end

get '/system_registry/service/consumers/' do
  @@system_registry.find_service_consumers(RegistryUtils.symbolize_keys(params)).to_json
end

get '/system_registry/service/registered/' do
  @@system_registry.get_registered_against_service(RegistryUtils.symbolize_keys(params)).to_json
end

get '/system_registry/services/providers/in_use/' do
  @@system_registry.list_providers_in_use().to_json
end

get '/system_registry/service/' do
  @@system_registry.get_service_entry(RegistryUtils.symbolize_keys(params)).to_json
end

get '/system_registry/service/is_registered' do
  @@system_registry.service_is_registered?(RegistryUtils.symbolize_keys(params)).to_json
end

post '/system_registry/services/' do
  p RegistryUtils.symbolize_keys(params)
 if @@system_registry.add_to_services_registry(RegistryUtils.symbolize_keys(params)).to_json
  status(202)
else
  status(404)
end    
end

put '/system_registry/service/update' do
if @@system_registry.update_attached_service(RegistryUtils.symbolize_keys(params)).to_json
 status(202)
else
 status(404)
end    
end

delete '/system_registry/service/del' do
if @@system_registry.remove_from_services_registry(RegistryUtils.symbolize_keys(params)).to_json
 status(202)
else
 status(404)
end    
end






