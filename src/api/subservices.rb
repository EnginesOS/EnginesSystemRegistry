require_relative 'utils.rb'

get '/v0/system_registry/subservices/tree' do
  @@system_registry.subservices_registry_tree.to_json
end
 
get '/v0/system_registry/subservice/registered/engines/' do
  p = RegistryUtils.symbolize_keys(params)  
  @@system_registry.all_subservices_registered_to(p[:subservice_type]).to_json
end

get '/v0/system_registry/subservice/consumers/' do
  @@system_registry.find_subservice_consumers(RegistryUtils.symbolize_keys(params)).to_json
end

get '/v0/system_registry/subservice/registered/' do
  @@system_registry.get_subservices_registered_against_service(RegistryUtils.symbolize_keys(params)).to_json
end



get '/v0/system_registry/subservice/' do
  @@system_registry.get_subservice_entry(RegistryUtils.symbolize_keys(params)).to_json
end

get '/v0/system_registry/subservice/is_registered' do
  @@system_registry.subservice_is_registered?(RegistryUtils.symbolize_keys(params)).to_json
end

post '/v0/system_registry/subservices/add' do
  p RegistryUtils.symbolize_keys(params)
 if @@system_registry.add_to_subservices_registry(RegistryUtils.symbolize_keys(params)).to_json
  status(202)
else
  status(404)
end    
end

put '/v0/system_registry/subservice/update' do
if @@system_registry.update_attached_subservice(RegistryUtils.symbolize_keys(params)).to_json
 status(202)
else
 status(404)
end    
end

delete '/v0/system_registry/subservices/del' do
if @@system_registry.remove_from_subservices_registry(RegistryUtils.symbolize_keys(params)).to_json
 status(202)
else
 status(404)
end    
end






