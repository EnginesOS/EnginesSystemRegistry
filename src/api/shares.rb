

get '/v0/system_registry/shares/tree' do
  process_result(RegistryUtils.as_hash(system_registry.shares_registry_tree))
end

post '/v0/system_registry/shares/add' do
  p_params = post_params(request)
  process_result(system_registry.add_to_shares_registry(p_params))
end

post '/v0/system_registry/shares/del' do
  p_params = post_params(request)
  process_result( system_registry.remove_from_shares_registry(p_params))
end

