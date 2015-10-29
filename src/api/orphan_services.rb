
get '/system_registry/services/ophans/tree' do
  @@system_registry.orphaned_services_registry_tree.to_json
 end

 