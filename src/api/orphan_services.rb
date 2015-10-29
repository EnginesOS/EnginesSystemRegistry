
get '/system_registry/orphan_services_tree' do
  @@system_registry.orphaned_services_registry.to_json
 end
