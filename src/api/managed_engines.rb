require_relative 'utils.rb'

get '/v0/system_registry/engines/tree' do
  @@system_registry.managed_engines_registry_tree.to_json
 end

get '/v0/system_registry/engine/service/' do
  @@system_registry.find_engine_service_hash(RegistryUtils.symbolize_keys(params)).to_json
end

get '/v0/system_registry/engine/services/' do
  STDERR.puts 'engines_services'
    STDERR.puts params.to_s
@@system_registry.find_engine_services_hashes(RegistryUtils.symbolize_keys(params)).to_json
end

get '/v0/system_registry/engine/services/nonpersistant/' do
  STDERR.puts 'engines_services_nonpersistant'
  STDERR.puts params.to_s
@@system_registry.get_engine_nonpersistant_services(RegistryUtils.symbolize_keys(params)).to_json
end


get '/v0/system_registry/engine/services/persistant/' do
  
  STDERR.puts ':system_registry_engine_services_persistant_'
  STDERR.puts RegistryUtils.symbolize_keys(params).to_s
@@system_registry.get_engine_persistant_services(RegistryUtils.symbolize_keys(params)).to_json
end

post '/v0/system_registry/engine/services/' do
  STDERR.puts RegistryUtils.symbolize_keys(params).to_s
  if @@system_registry.add_to_managed_engines_registry(RegistryUtils.symbolize_keys(params)).to_json
  status(202)
else
  status(404)
end    
end

delete '/v0/system_registry/engine/services/del' do
if @@system_registry.remove_from_managed_engines_registry(RegistryUtils.symbolize_keys(params)).to_json
  status(202)
else
  status(404)
end    
end 

put  '/v0/system_registry/engine/service/update' do
  if @@system_registry.update_managed_engine_service(RegistryUtils.symbolize_keys(params)).to_json
  status(202)
else
  status(404)
end    
end 