require_relative 'utils.rb'
get '/v0/system_registry/services/orphans/tree' do
  process_result(RegistryUtils.as_hash(system_registry.orphaned_services_registry_tree))
end


post '/v0/system_registry/services/orphans/add/:parent_engine/:service_handle/:publisher_namespace/*' do
  splats = params['splat']
  p_params[:type_path] =   splats[0]
  p_params = post_params(request)
  p_params.merge(params)
  STDERR.puts('Noew ORPHAN ' + p_params.to_s + ' ' + params.to_s)
  process_result(system_registry.orphanate_service(p_params ))
end

post '/v0/system_registry/services/orphans/return/:parent_engine/:service_handle/:publisher_namespace/*' do
  p_params = post_params(request)
  p_params.merge(params)
  p_params = params['splat']
  params[:type_path] =   splats[0]
  process_result(system_registry.rollback_orphaned_service(RegistryUtils.symbolize_keys(params)))

end

delete '/v0/system_registry/services/orphans/del/:service_handle/:parent_engine/:publisher_namespace/*' do
  splats = params['splat']
  params[:type_path] =   splats[0]
  process_result(system_registry.release_orphan(params))
end


get '/v0/system_registry/services/orphans/:publisher_namespace/*' do
  splats = params['splat']
  params[:type_path] =   splats[0]
  process_result(system_registry.get_orphaned_services(params))
end

get '/v0/system_registry/services/orphan/:parent_engine/:service_handle/:publisher_namespace/*' do
  splats = params['splat']
  params[:type_path] =   splats[0]
  STDERR.puts( 'ORPHAN get params ' + params.to_s)
  process_result(system_registry.retrieve_orphan(params))
end
#reparent_orphan

#rebirth_orphan

