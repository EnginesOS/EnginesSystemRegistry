get '/v0/system_registry/shares/tree' do
  process_result(registry_as_hash(system_registry.shares_registry_tree))
end

post '/v0/system_registry/shares/add/:service_owner/:parent_engine/:service_handle/:publisher_namespace/*' do
  params[:type_path] =  params['splat'][0]
  params.merge!(post_params(request))
  cparams =  assemble_params(params, [:service_owner, :parent_engine, :service_handle, :publisher_namespace, :type_path], [], [])
  process_result(system_registry.add_to_shares_registry(cparams))
end

delete '/v0/system_registry/shares/del/:service_owner/:parent_engine/:service_handle/:publisher_namespace/*' do
  params[:type_path] =  params['splat'][0]
  cparams =  assemble_params(params, [:service_owner, :parent_engine, :service_handle, :publisher_namespace, :type_path])
  process_result(system_registry.remove_from_shares_registry(cparams))
end

