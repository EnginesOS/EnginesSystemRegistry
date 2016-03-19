require_relative 'utils.rb'

get '/v0/system_registry/shares/tree' do
  p :sgare
  p  @@system_registry.shares_registry_tree.to_json
  @@system_registry.shares_registry_tree.to_json
end
 
      
post '/v0/system_registry/shares/add' do
  p RegistryUtils.symbolize_keys(params)
 if @@system_registry.add_to_shares_registry(RegistryUtils.symbolize_keys(params)).to_json
  status(202)
else
  status(404)
end    
end

delete '/v0/system_registry/shares/del' do
if @@system_registry.remove_from_shares_registry(RegistryUtils.symbolize_keys(params)).to_json
 status(202)
else
 status(404)
end    
end






