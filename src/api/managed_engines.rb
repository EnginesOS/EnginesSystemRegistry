get '/v0/system_registry/engines/tree' do
  begin
    process_result(registry_as_hash(system_registry.managed_engines_registry_tree))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/engine/service/:container_type/:parent_engine/:service_handle/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:container_type, :parent_engine, :service_handle, :type_path])
    # STDERR.puts( ' GET FROM managed engines ' + cparams.to_s)
    process_result(system_registry.find_engine_service_hash(cparams))

  rescue StandardError => e
    handle_exception(e)
  end
end

delete '/v0/system_registry/engine/services/del/:container_type/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:container_type, :parent_engine, :publisher_namespace, :service_handle, :type_path])
    #STDERR.puts( ' DEL FRO managed engines ' )
    process_result(system_registry.remove_from_managed_engines_registry(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

post '/v0/system_registry/engine/service/update/:container_type/:parent_engine/:service_handle/*' do
  begin
    params.merge!(post_params(request))
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:container_type, :parent_engine, :service_handle, :type_path], nil, :all)
    # STDERR.puts( ' UPDATE FROM managed engines ')
    process_result(system_registry.update_managed_engine_service(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/engine/services/nonpersistent/:container_type/:parent_engine' do
  begin
    #  STDERR.puts( ' NON PERS ' + params.to_s)
    cparams = assemble_params(params, [:parent_engine, :container_type])
    #  STDERR.puts( ' NON PERS ' + cparams.to_s)
    process_result(system_registry.get_engine_nonpersistent_services(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/engine/services/persistent/:container_type/:parent_engine' do
  begin
    # STDERR.puts( ' PERS ' + params.to_s )
    cparams = assemble_params(params, [:parent_engine, :container_type])
    # STDERR.puts( ' PERS ' + params.to_s )
    process_result(system_registry.get_engine_persistent_services(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

post '/v0/system_registry/engine/services/add/:container_type/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    params.merge!(post_params(request))
    cparams = assemble_params(params, [:parent_engine, :container_type, :service_handle, :publisher_namespace, :type_path], nil, :all)
    STDERR.puts( ' ADD to managed engines ' + cparams.to_s )
    process_result(system_registry.add_to_managed_engines_registry(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

#/v0/system_registry/engine/services/:parent_engine/:type_path
get '/v0/system_registry/engine/services/:container_type/:parent_engine' do
  begin
    cparams = assemble_params(params, [:container_type, :parent_engine])
    STDERR.puts('/v0/system_registry/engine/services/:container_type/:parent_engine' + cparams.to_s)
    process_result(system_registry.find_engine_services_hashes(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

#/v0/system_registry/engine/services/:parent_engine/:type_path
get '/v0/system_registry/engine/services/:container_type/:parent_engine/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:container_type, :parent_engine, :type_path] )
    STDERR.puts(' v0/system_registry/engine/services/:container_type/:parent_engine/*' + cparams.to_s)
    process_result(system_registry.find_engine_services_hashes(cparams))

  rescue StandardError => e
    handle_exception(e)
  end
end

