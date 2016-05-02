require_relative 'utils.rb'
get '/v0/system_registry/services/orphans/tree' do
  process_result(@@system_registry.orphaned_services_registry_tree)
end

get '/v0/system_registry/services/orphans/' do
  process_result(@@system_registry.get_orphaned_services(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/services/orphan/' do
  process_result(@@system_registry.retrieve_orphan(RegistryUtils.symbolize_keys(params)))
end

post '/v0/system_registry/services/orphans/add' do
  process_result(@@system_registry.orphanate_service(RegistryUtils.symbolize_keys(params)))
end

post '/v0/system_registry/services/orphans/return' do
  process_result(@@system_registry.rollback_orphaned_service(RegistryUtils.symbolize_keys(params)))

end

delete '/v0/system_registry/services/orphans/del' do
  process_result(@@system_registry.release_orphan(RegistryUtils.symbolize_keys(params)))
end

#reparent_orphan

#rebirth_orphan

