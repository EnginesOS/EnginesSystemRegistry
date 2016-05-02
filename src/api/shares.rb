require_relative 'utils.rb'

get '/v0/system_registry/shares/tree' do
  process_result(@@system_registry.shares_registry_tree)
end
 
      
post '/v0/system_registry/shares/add' do
  
  process_result(@@system_registry.add_to_shares_registry(RegistryUtils.symbolize_keys(params)))
end

delete '/v0/system_registry/shares/del' do
  process_result( @@system_registry.remove_from_shares_registry(RegistryUtils.symbolize_keys(params)))
end






