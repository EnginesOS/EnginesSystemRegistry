
get '/v0/system_registry/status/' do
  'true'
end

get '/v0/system_registry/tree' do
  process_result(RegistryUtils.as_hash(system_registry.system_registry_tree))
  #process_result($system_registry.registry_as_hash(system_registry.system_registry_tree))
end