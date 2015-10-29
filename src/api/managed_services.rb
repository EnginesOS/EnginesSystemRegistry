get '/system_registry/managed_services_tree' do
  @@system_registry.services_registry_tree.to_json
 end
