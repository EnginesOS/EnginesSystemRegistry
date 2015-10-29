get '/system_registry/managed_engines_tree' do
  @@system_registry.managed_engines_registry_tree.to_json
 end
