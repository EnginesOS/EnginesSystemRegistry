get '/system_registry/configurations_tree' do
  @@system_registry.service_configurations_registry_tree.to_json
 end

 get '/system_registry/configurations/' do
   @@system_registry.get_service_configurations_hashes(params['service_name']).to_json
 end

 get '/system_registry/configuration/' do
  @@system_registry.get_service_configuration(symbolize_keys(params)).to_json
 end
 
 post '/system_registry/configuration/' do
    if@@system_registry.add_service_configuration(symbolize_keys(params)).to_json
      status(202)
    else
      status(404)
    end    
 end
 
 put '/system_registry/configuration/' do 
 if@@system_registry.update_service_configuration(symbolize_keys(params)).to_json
   status(202)
 else
   status(404)
 end    
end

delete '/system_registry/configuration/' do
 if@@system_registry.rm_service_configuration(symbolize_keys(params)).to_json
    status(202)
  else
    status(404)
  end    
end
