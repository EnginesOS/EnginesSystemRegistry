get '/v0/system_registry/engines/tree' do
  process_result(RegistryUtils.as_hash(system_registry.managed_engines_registry_tree))
end

#get '/v0/system_registry/engine/service/' do
# :publisher_namespace :type_path :parent_engine :service_handle
# process_result(system_registry.find_engine_service_hash(RegistryUtils.symbolize_keys(params)))
#end

get '/v0/system_registry/engine/service/:container_type/:parent_engine/:service_handle/*' do
  splats = params['splat']
  params[:type_path] =   splats[0]
  cparams =  RegistryUtils::Params.assemble_params(params, [:container_type,:parent_engine,:service_handle,:type_path],  :all,nil)
  process_result(system_registry.find_engine_service_hash(cparams))

end

delete '/v0/system_registry/engine/services/del' do
  # :publisher_namespace :type_path :parent_engine :service_handle
  process_result( system_registry.remove_from_managed_engines_registry(RegistryUtils.symbolize_keys(params)))
end

put '/v0/system_registry/engine/service/update' do
  # :publisher_namespace :type_path :parent_engine :service_handle + post
  process_result( system_registry.update_managed_engine_service(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/engine/services/nonpersistent/' do
  #:parent_engine
  # STDERR.puts( ' NON PERS ' + RegistryUtils.symbolize_keys(params).to_s)
  process_result(system_registry.get_engine_nonpersistent_services(RegistryUtils.symbolize_keys(params)))
end

get '/v0/system_registry/engine/services/persistent/' do
  #:parent_engine
  process_result(system_registry.get_engine_persistent_services(RegistryUtils.symbolize_keys(params)))
end

post '/v0/system_registry/engine/services/add' do
  # :publisher_namespace :type_path :parent_engine :service_handle + post
  p_params = post_params(request)
  STDERR.puts( ' ADD to managed engines ' + params.to_s + ' parsed as ' +  p_params.to_s)
  process_result(system_registry.add_to_managed_engines_registry(p_params))
end

#/v0/system_registry/engine/services/:parent_engine/:type_path
get '/v0/system_registry/engine/services/:container_type/:parent_engine' do

  process_result(system_registry.find_engine_services_hashes(RegistryUtils.symbolize_keys(params)))
end

#/v0/system_registry/engine/services/:parent_engine/:type_path
get '/v0/system_registry/engine/services/:container_type/:parent_engine/*' do
  #  def self.service_hash_from_params(params, search)
  splats = params['splat']
  hash = {}
  hash[:parent_engine] =  params[:parent_engine]
  hash[:container_type] =  params[:container_type]
  hash[:type_path] =  splats[0]

  process_result(system_registry.find_engine_services_hashes(hash))
end

