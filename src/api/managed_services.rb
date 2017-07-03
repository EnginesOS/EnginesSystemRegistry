get '/v0/system_registry/services/tree' do
  begin
    process_result(registry_as_hash(system_registry.services_registry_tree))
  rescue StandardError => e
    handle_exception(e)
  end
end

delete '/v0/system_registry/services/clear/:container_type/:parent_engine/:persistence' do
  begin
    cparams = assemble_params(params, [:container_type, :parent_engine, :persistence])
    process_result(system_registry.clear_service_from_registry(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/service/registered/engines/:service_type' do
  begin
    cparams = assemble_params(params, [:service_type], :all, :all)
    process_result(system_registry.all_engines_registered_to(cparams ))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/service/consumers/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:publisher_namespace, :type_path])
    process_result(system_registry.find_service_consumers(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/service/registered/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:publisher_namespace, :type_path])
    process_result(system_registry.get_registered_against_service(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/services/providers/in_use/' do
  begin
    process_result(system_registry.list_providers_in_use())
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/service/is_registered/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:parent_engine, :service_handle, :publisher_namespace, :type_path])
    process_result(system_registry.service_is_registered?(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

post '/v0/system_registry/services/add/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    params.merge!(post_params(request))
    cparams = assemble_params(params, [:parent_engine, :service_handle, :publisher_namespace, :type_path], nil, :all)
    #  STDERR.puts( ' ADD to services ' + params.to_s + ' parsed as ' )
    process_result(system_registry.add_to_services_registry(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

post '/v0/system_registry/service/update/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    params.merge!(post_params(request))
    cparams = assemble_params(params, [:parent_engine, :service_handle, :publisher_namespace, :type_path], nil,:all)
    #  STDERR.puts( ' UPDATE to services parsed as ' + cparams.to_s )
    process_result(system_registry.update_attached_service(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

delete '/v0/system_registry/services/del/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] =    params['splat'][0]
    cparams = assemble_params(params, [:parent_engine,:service_handle, :publisher_namespace, :type_path])
    # STDERR.puts( ' ERM to services parsed as '  + params.to_s)
    process_result(system_registry.remove_from_services_registry(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/service/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:parent_engine, :service_handle, :publisher_namespace, :type_path])
    process_result(system_registry.get_service_entry(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end