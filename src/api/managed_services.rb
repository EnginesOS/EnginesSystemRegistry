

get '/v0/system_registry/services/tree' do
  process_result(RegistryUtils.as_hash(system_registry.services_registry_tree))
end
# clear_service_from_registry(service_hash)
delete '/v0/system_registry/services/clear/:container_type/:parent_engine/:persistence' do
  cparams =  RegistryUtils::Params.assemble_params(params, [:container_type,:parent_engine,:persistence], :all,:all) 
  #:parent_engine  :container_type  :persistence 
  process_result(system_registry.clear_service_from_registry(cparams))
end

get '/v0/system_registry/service/registered/engines/:service_type' do
  #:publisher_namespace :type_path
  splats = params['splat']
    params[:type_path] =   splats[0]
cparams =  RegistryUtils::Params.assemble_params(params, [:service_type], :all,:all) 
  process_result(system_registry.all_engines_registered_to(cparams ))#RegistryUtils.symbolize_keys(params)[:service_type]))
end

get '/v0/system_registry/service/consumers/:publisher_namespace/*' do
  #:publisher_namespace :type_path
  splats = params['splat']
    params[:type_path] =   splats[0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:publisher_namespace,:type_path], :all,:all) 
  process_result(system_registry.find_service_consumers(cparams))
end

get '/v0/system_registry/service/registered/:publisher_namespace/*' do
  #:publisher_namespace :type_path
  splats = params['splat']
    params[:type_path] =   splats[0]
   cparams =  RegistryUtils::Params.assemble_params(params, [:publisher_namespace,:type_path], :all,:all) 
  process_result(system_registry.get_registered_against_service(cparams))
end

get '/v0/system_registry/services/providers/in_use/' do
  process_result(system_registry.list_providers_in_use())
end

get '/v0/system_registry/service/is_registered/:parent_engine/:service_handle/:publisher_namespace/*' do
  #:publisher_namespace :type_path :parent_engine :service_handle
  splats = params['splat']
   params[:type_path] =   splats[0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path],  :all,:all)
  process_result(system_registry.service_is_registered?(cparams))
end






post '/v0/system_registry/services/add/:parent_engine/:service_handle/:publisher_namespace/*' do
  #:publisher_namespace :type_path :parent_engine :service_handle + post
  STDERR.puts( ' ADD to services ' + params.to_s )
  splats = params['splat']
    params[:type_path] =   splats[0]
  p_params = post_params(request)
params.merge!(p_params)
    cparams =  RegistryUtils::Params.assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path],  :all,:all)
  STDERR.puts( ' ADD to services ' + params.to_s + ' parsed as '  + p_params.to_s)
  process_result(system_registry.add_to_services_registry(cparams))
end

post '/v0/system_registry/service/update/:parent_engine/:service_handle/:publisher_namespace/*' do
  #:publisher_namespace :type_path :parent_engine :service_handle + post
  STDERR.puts( ' UPDATE to services ' + params.to_s )
  splats = params['splat']
    params[:type_path] =   splats[0]
p_params = post_params(request)
 params.merge!(p_params)
    cparams =  RegistryUtils::Params.assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path],  :all,:all)
STDERR.puts( ' UPDATE to services parsed as '  + cparams.to_s)
  process_result(system_registry.update_attached_service(cparams))
end

delete '/v0/system_registry/services/del/:parent_engine/:service_handle/:publisher_namespace/*' do
  #:publisher_namespace :type_path :parent_engine :service_handle 
  STDERR.puts( ' RM to services ' + params.to_s )
  splats = params['splat']
    params[:type_path] =   splats[0]
    cparams =  RegistryUtils::Params.assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path],  :all,nil)
STDERR.puts( ' ERM to services parsed as '  + cparams.to_s)
  process_result(system_registry.remove_from_services_registry(cparams))
end

get '/v0/system_registry/service/:parent_engine/:service_handle/:publisher_namespace/*' do
  splats = params['splat']
  params[:type_path] =   splats[0]
 cparams =  RegistryUtils::Params.assemble_params(params, [:parent_engine,:service_handle,:publisher_namespace,:type_path],  :all,:all)
 
  process_result(system_registry.get_service_entry(cparams))
  #:publisher_namespace :type_path :parent_engine :service_handle
end