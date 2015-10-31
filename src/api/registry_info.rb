require_relative 'utils.rb'

get '/system_registry/status/' do
  r = true
 r.to_json
 end
 
get '/system_registry/tree' do
  @@system_registry.system_registry_tree.to_json
 end