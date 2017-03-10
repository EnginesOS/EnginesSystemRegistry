get '/v0/system_registry/engines/tree' do
 # process_result(RegistryUtils.as_hash(system_registry.managed_engines_registry_tree))
  process_result(registry_as_hash(system_registry.managed_engines_registry_tree))
end

#get '/v0/system_registry/engine/service/' do
# :publisher_namespace :type_path :parent_engine :service_handle
# process_result(system_registry.find_engine_service_hash(RegistryUtils.symbolize_keys(params)))
#end

get '/v0/system_registry/engine/service/:container_type/:parent_engine/:service_handle/*' do
#  splats = params['splat']
  params[:type_path] =    params['splat'][0]
params =  assemble_params(params, [:container_type,:parent_engine,:service_handle,:type_path]) #,  :all,:all)
STDERR.puts( ' GET FROM managed engines ' + params.to_s) 
  process_result(system_registry.find_engine_service_hash(params))

end

delete '/v0/system_registry/engine/services/del/:container_type/:parent_engine/:service_handle/:publisher_namespace/*' do
  # :publisher_namespace :type_path :parent_engine :service_handle
  # splats = params['splat']
   params[:type_path] =    params['splat'][0]
params =  assemble_params(params, [:container_type,:parent_engine,:publisher_namespace,:service_handle,:type_path]) #,  :all,:all)
#STDERR.puts( ' DEL FRO managed engines ' )
  process_result( system_registry.remove_from_managed_engines_registry(params))
end

post '/v0/system_registry/engine/service/update/:container_type/:parent_engine/:service_handle/*' do
  # :publisher_namespace :type_path :parent_engine :service_handle + post
# splats = params['splat']
  params.merge!(post_params(request))
  params[:type_path] =    params['splat'][0]
params =  assemble_params(params, [:container_type,:parent_engine,:service_handle,:type_path],  :all,:all)
 # STDERR.puts( ' UPDATE FROM managed engines ') 
  process_result( system_registry.update_managed_engine_service(params))
end

get '/v0/system_registry/engine/services/nonpersistent/:container_type/:parent_engine' do
  #:parent_engine
  # STDERR.puts( ' NON PERS ' + RegistryUtils.symbolize_keys(params).to_s)
  params =  assemble_params(params, [:parent_engine, :container_type]) #, nil, nil)
  process_result(system_registry.get_engine_nonpersistent_services(params))
end

get '/v0/system_registry/engine/services/persistent/:container_type/:parent_engine' do
  #:parent_engine
  params =  assemble_params(params, [:parent_engine, :container_type]) #, :all, nil)
  STDERR.puts( ' PERS ' + params.to_s )
  process_result(system_registry.get_engine_persistent_services(params))
end

post '/v0/system_registry/engine/services/add/:container_type/:parent_engine/:service_handle/:publisher_namespace/*' do
  #/v0/system_registry/engine/services/add/
  # :publisher_namespace :type_path :parent_engine :service_handle + post
  # p_params = post_params(request)
 # splats = params['splat']
   params[:type_path] =    params['splat'][0] 
   params.merge!(post_params(request))
 
params =  assemble_params(params, [:parent_engine,:container_type,:service_handle,:publisher_namespace,:type_path],  :all,:all)
  #STDERR.puts( ' ADD to managed engines ' + params.to_s )
  process_result(system_registry.add_to_managed_engines_registry(params))
end

#/v0/system_registry/engine/services/:parent_engine/:type_path
get '/v0/system_registry/engine/services/:container_type/:parent_engine' do

  params =  assemble_params(params, [:container_type,:parent_engine]) #,  :all, nil)
  process_result(system_registry.find_engine_services_hashes(params))
end

#/v0/system_registry/engine/services/:parent_engine/:type_path
get '/v0/system_registry/engine/services/:container_type/:parent_engine/*' do
  #  def self.service_hash_from_params(params, search)
 # splats = params['splat']
   params[:type_path] =    params['splat'][0]
params =  assemble_params(params, [:container_type,:parent_engine,:type_path]) #, :all, nil)
     STDERR.puts( ' GET FROM managed engines ' + params.to_s) 
#  splats = params['splat']
#  hash = {}
#  hash[:parent_engine] =  params[:parent_engine]
#  hash[:container_type] =  params[:container_type]
  #hash[:type_path] =  splats[0]
#
  process_result(system_registry.find_engine_services_hashes(params))
end

