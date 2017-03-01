

get '/v0/system_registry/services/tree' do
  process_result(RegistryUtils.as_hash(system_registry.services_registry_tree))
end
# clear_service_from_registry(service_hash)
delete '/v0/system_registry/services/clear' do
  #:parent_engine  :container_type  :persistence 
  process_result(system_registry.clear_service_from_registry(RegistryUtils.symbolize_keys(params)))
end
get '/v0/system_registry/service/registered/engines/' do
  #:publisher_namespace :type_path
  process_result(system_registry.all_engines_registered_to(RegistryUtils.symbolize_keys(params)[:service_type]))
end

get '/v0/system_registry/service/consumers/' do
  #:publisher_namespace :type_path
  process_result(system_registry.find_service_consumers(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/service/registered/' do
  #:publisher_namespace :type_path
  process_result(system_registry.get_registered_against_service(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/services/providers/in_use/' do
  process_result(system_registry.list_providers_in_use())
end

get '/v0/system_registry/service/' do
  process_result(system_registry.get_service_entry(RegistryUtils.symbolize_keys(params)))
  #:publisher_namespace :type_path :parent_engine :service_handle
end

get '/v0/system_registry/service/is_registered' do
  #:publisher_namespace :type_path :parent_engine :service_handle
  process_result(system_registry.service_is_registered?(RegistryUtils.symbolize_keys(params)))
end

post '/v0/system_registry/services/add' do
  #:publisher_namespace :type_path :parent_engine :service_handle + post
  p_params = post_params(request)
  STDERR.puts( ' ADD to services ' + params.to_s + ' parsed as '  + p_params.to_s)
  process_result(system_registry.add_to_services_registry(p_params))
end

put '/v0/system_registry/service/update' do
  #:publisher_namespace :type_path :parent_engine :service_handle + post
  process_result(system_registry.update_attached_service(RegistryUtils.symbolize_keys(params)))
end

delete '/v0/system_registry/services/del/:container_type/:parent_engine/:service_handle/:publisher_namespace/*' do
  #:publisher_namespace :type_path :parent_engine :service_handle 
  splats = params['splat']
    params[:type_path] =   splats[0]
    cparams =  RegistryUtils::Params.assemble_params(params, [:container_type,:parent_engine,:service_handle,:publisher_namespace,:type_path],  :all,nil)
STDERR.puts( ' EM to services ' + params.to_s + ' parsed as '  + carams.to_s)
  process_result(system_registry.remove_from_services_registry(cparams))
end

