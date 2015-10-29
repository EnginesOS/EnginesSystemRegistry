
get '/system_registry/services/orphans/tree' do
  @@system_registry.orphaned_services_registry_tree.to_json
 end

 