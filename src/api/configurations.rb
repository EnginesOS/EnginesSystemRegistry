require_relative 'utils.rb'

get '/v0/system_registry/services/configurations/tree' do
  @@system_registry.service_configurations_registry_tree.to_json
 end

 get '/v0/system_registry/service/configurations/' do
   p params.to_s
   @@system_registry.get_service_configurations_hashes(params['service_name']).to_json
 end

 get '/v0/system_registry/services/configuration/' do
  @@system_registry.get_service_configuration(RegistryUtils.symbolize_keys(params)).to_json
 end
 
 post '/v0/system_registry/services/configurations/' do
    if  @@system_registry.add_service_configuration(RegistryUtils.symbolize_keys(params)).to_json
      status(202)
    else
      status(404)
    end    
 end
 
 put '/v0/system_registry/services/configuration/' do 
 if  @@system_registry.update_service_configuration(RegistryUtils.symbolize_keys(params)).to_json
   status(202)
 else
   status(404)
 end    
end

delete '/v0/system_registry/services/configurations/' do
 if  @@system_registry.rm_service_configuration(RegistryUtils.symbolize_keys(params)).to_json
    status(202)
  else
    status(404)
  end    
end
