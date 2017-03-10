get '/v0/system_registry/services/tree' do
  # process_result(RegistryUtils.as_hash(system_registry.services_registry_tree))
  process_result(registry_as_hash(system_registry.services_registry_tree))
end
# clear_service_from_registry(service_hash)
delete '/v0/system_registry/services/clear/:container_type/:parent_engine/:persistence' do
  params = assemble_params(params, [:container_type,:parent_engine,:persistence], :all,:all)
  #:parent_engine  :container_type  :persistence
  process_result(system_registry.clear_service_from_registry(params))
end

get '/v0/system_registry/service/registered/engines/:service_type' do
  #:publisher_namespace :type_path
  #  splats = params['splat']
  #  params[:type_path] =   splats[0]
  params = assemble_params(params, [:service_type], :all,:all)
  process_result(system_registry.all_engines_registered_to(params ))#RegistryUtils.symbolize_keys(params)[:service_type]))
end

get '/v0/system_registry/service/consumers/:publisher_namespace/*' do
  #:publisher_namespace :type_path
  # splats = params['splat']
  params[:type_path] = params['splat'][0]
  params = assemble_params(params, [:publisher_namespace,:type_path], :all,:all)
  process_result(system_registry.find_service_consumers(params))
end

get '/v0/system_registry/service/registered/:publisher_namespace/*' do
  #:publisher_namespace :type_path
  # splats = params['splat']
  params[:type_path] = params['splat'][0]
  params = assemble_params(params, [:publisher_namespace,:type_path], :all,:all)
  process_result(system_registry.get_registered_against_service(params))
end

get '/v0/system_registry/services/providers/in_use/' do
  process_result(system_registry.list_providers_in_use())
end

get '/v0/system_registry/service/is_registered/:parent_engine/:service_handle/:publisher_namespace/*' do
  #:publisher_namespace :type_path :parent_engine :service_handle
  #splats = params['splat']
  params[:type_path] = params['splat'][0]
  params = assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path], :all,:all)
  process_result(system_registry.service_is_registered?(params))
end

post '/v0/system_registry/services/add/:parent_engine/:service_handle/:publisher_namespace/*' do
  #:publisher_namespace :type_path :parent_engine :service_handle + post
  #STDERR.puts( ' ADD to services ' + params.to_s )
  # splats = params['splat']
  params[:type_path] = params['splat'][0]
  params.merge!(post_params(request))
  params = assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path], :all,:all)
  #  STDERR.puts( ' ADD to services ' + params.to_s + ' parsed as '  + p_params.to_s)
  process_result(system_registry.add_to_services_registry(params))
end

post '/v0/system_registry/service/update/:parent_engine/:service_handle/:publisher_namespace/*' do
  #:publisher_namespace :type_path :parent_engine :service_handle + post
  # STDERR.puts( ' UPDATE to services ' + params.to_s )
  #  splats = params['splat']
  params[:type_path] = params['splat'][0]
  # p_params = post_params(request)
  params.merge!(post_params(request))
  params = assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path], :all,:all)
  # STDERR.puts( ' UPDATE to services parsed as '  + cparams.to_s)
  process_result(system_registry.update_attached_service(params))
end

delete '/v0/system_registry/services/del/:parent_engine/:service_handle/:publisher_namespace/*' do
  #:publisher_namespace :type_path :parent_engine :service_handle
  # STDERR.puts( ' RM to services ' + params.to_s )
  #  splats = params['splat']
  params[:type_path] =    params['splat'][0]
  params = assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path], :all,nil)
  # STDERR.puts( ' ERM to services parsed as '  + cparams.to_s)
  process_result(system_registry.remove_from_services_registry(params))
end

get '/v0/system_registry/service/:parent_engine/:service_handle/:publisher_namespace/*' do
  # splats = params['splat']
  params[:type_path] = params['splat'][0]
  params = assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path], :all,:all)
  process_result(system_registry.get_service_entry(params))
  #:publisher_namespace :type_path :parent_engine :service_handle
end