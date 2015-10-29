
  
  require 'sinatra'
  require 'json'
  require_relative 'system_registry/system_registry.rb'
    
   @system_registry = SystemRegistry.new
    
  get '/system_registry/configurations_tree' do
    @system_registry.service_configurations_registry_tree.to_json
  end
  
  get '/system_registry/configurations' do
    @system_registry.service_configurations_hashes(params).to_json
  end

  get '/system_registry/configuration/' do
    @system_registry.get_service_configuration(params).to_json
  end
  
  post '/system_registry/configuration' do
     if @system_registry.add_service_configuration(service_hash)
       status(202)
     else
       status(404)
     end    
  end
  
  put '/system_registry/configuration' do
  if @system_registry.update_service_configuration(service_hash)
    status(202)
  else
    status(404)
  end    
end

delete '/system_registry/configuration' do
  if @system_registry.rm_service_configuration(service_hash)
     status(202)
   else
     status(404)
   end    
 end
 
