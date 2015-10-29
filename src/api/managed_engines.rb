get '/system_registry/engines/tree' do
  @system_registry.managed_engines_registry_tree.to_json
 end

get '/system_registry/engine/service/' do
  @system_registry.find_engine_service_hash(symbolize_keys(params)).to_json
end

get '/system_registry/engine/services/' do
@system_registry.find_engine_services_hashes(symbolize_keys(params)).to_json
end

get '/system_registry/engine/services/nonpersistant/' do
@system_registry.get_engine_nonpersistant_services(symbolize_keys(params)).to_json
end


get '/system_registry/engine/services/persistant/' do
@system_registry.get_engine_persistant_services(symbolize_keys(params)).to_json
end

post '/system_registry/engine/services/' do
  if @system_registry.add_to_managed_engines_registry(symbolize_keys(params)).to_json
  status(202)
else
  status(404)
end    
end

delete '/system_registry/engine/services/' do
if @system_registry.remove_from_managed_engines_registry(symbolize_keys(params)).to_json
  status(202)
else
  status(404)
end    
end 

put  '/system_registry/engine/service/' do
  if @system_registry.update_managed_engine_service(symbolize_keys(params)).to_json
  status(202)
else
  status(404)
end    
end 