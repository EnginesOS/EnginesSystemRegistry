get '/v0/system_registry/engines/tree' do
  # process_result(RegistryUtils.as_hash(system_registry.managed_engines_registry_tree))
  process_result(registry_as_hash(system_registry.managed_engines_registry_tree))
end

#get '/v0/system_registry/engine/service/' do
# :publisher_namespace :type_path :parent_engine :service_handle
# process_result(system_registry.find_engine_service_hash(RegistryUtils.symbolize_keys(params)))
#end

get '/v0/system_registry/engine/service/:container_type/:parent_engine/:service_handle/*' do
  params[:type_path] =    params['splat'][0]
  params =  assemble_params(params, [:container_type,:parent_engine,:service_handle,:type_path], nil,:all)
  STDERR.puts( ' GET FROM managed engines ' + params.to_s)
  process_result(system_registry.find_engine_service_hash(params))

end

delete '/v0/system_registry/engine/services/del/:container_type/:parent_engine/:service_handle/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  params =  assemble_params(params, [:container_type,:parent_engine,:publisher_namespace,:service_handle,:type_path], nil, :all)
  #STDERR.puts( ' DEL FRO managed engines ' )
  process_result( system_registry.remove_from_managed_engines_registry(params))
end

post '/v0/system_registry/engine/service/update/:container_type/:parent_engine/:service_handle/*' do
  params.merge!(post_params(request))
  params[:type_path] =    params['splat'][0]
  params =  assemble_params(params, [:container_type,:parent_engine,:service_handle,:type_path], nil, :all)
  # STDERR.puts( ' UPDATE FROM managed engines ')
  process_result( system_registry.update_managed_engine_service(params))
end

get '/v0/system_registry/engine/services/nonpersistent/:container_type/:parent_engine' do
   STDERR.puts( ' NON PERS ' + params.to_s)
  params =  assemble_params(params, [:parent_engine, :container_type])
  STDERR.puts( ' NON PERS ' + params.to_s)
  process_result(system_registry.get_engine_nonpersistent_services(params))
end

get '/v0/system_registry/engine/services/persistent/:container_type/:parent_engine' do
  STDERR.puts( ' PERS ' + params.to_s )
  params =  assemble_params(params, [:parent_engine, :container_type])
  STDERR.puts( ' PERS ' + params.to_s )
  process_result(system_registry.get_engine_persistent_services(params))
end

post '/v0/system_registry/engine/services/add/:container_type/:parent_engine/:service_handle/:publisher_namespace/*' do
  params[:type_path] =    params['splat'][0]
  params.merge!(post_params(request))
  params =  assemble_params(params, [:parent_engine,:container_type,:service_handle,:publisher_namespace,:type_path], nil, :all)
  #STDERR.puts( ' ADD to managed engines ' + params.to_s )
  process_result(system_registry.add_to_managed_engines_registry(params))
end

#/v0/system_registry/engine/services/:parent_engine/:type_path
get '/v0/system_registry/engine/services/:container_type/:parent_engine' do
  params =  assemble_params(params, [:container_type,:parent_engine],  nil, nil)
  process_result(system_registry.find_engine_services_hashes(params))
end

#/v0/system_registry/engine/services/:parent_engine/:type_path
get '/v0/system_registry/engine/services/:container_type/:parent_engine/*' do
  params[:type_path] =    params['splat'][0]
  params =  assemble_params(params, [:container_type,:parent_engine,:type_path], nil, nil)
  STDERR.puts( ' GET FROM managed engines ' + params.to_s)
  process_result(system_registry.find_engine_services_hashes(params))
end

