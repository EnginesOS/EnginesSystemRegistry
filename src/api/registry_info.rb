require_relative 'utils.rb'

get '/v0/system_registry/status/' do
  'true'
end

get '/v0/system_registry/tree' do
  process_result(system_registry.system_registry_tree)
end