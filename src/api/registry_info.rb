require_relative 'utils.rb'

get '/v0/system_registry/status/' do
  r = true
 r.to_json
 end
 
get '/v0/system_registry/tree' do
  process_result(system_registry.system_registry_tree)
 end