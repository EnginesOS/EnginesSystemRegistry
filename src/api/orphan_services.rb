require_relative 'utils.rb'
get '/system_registry/services/orphans/tree' do
  @@system_registry.orphaned_services_registry_tree.to_json
 end

get '/system_registry/services/orphans/' do
  @@system_registry.get_orphaned_services(RegistryUtils.symbolize_keys(params)).to_json
 end

get '/system_registry/services/orphan/' do
  @@system_registry.retrieve_orphan(RegistryUtils.symbolize_keys(params)).to_json
 end

 post '/system_registry/services/orphans/' do
   p RegistryUtils.symbolize_keys(params)
 if @@system_registry.orphanate_service(RegistryUtils.symbolize_keys(params)).to_json
   status(202)
 else
   status(404)
 end    
 end
 

 delete '/system_registry/services/orphans/' do
   p :release_orphan
   p RegistryUtils.symbolize_keys(params)
 if @@system_registry.release_orphan(RegistryUtils.symbolize_keys(params)).to_json
   status(202)
 else
   status(404)
 end    
 end


#reparent_orphan

#rebirth_orphan


