get '/v0/system_registry/services/orphans/tree' do
  begin
    process_result($system_registry.registry_as_hash(system_registry.orphaned_services_registry_tree))
  rescue StandardError => e
    handle_exception(e)
  end
end

post '/v0/system_registry/services/orphans/add/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    params.merge!(post_params(request))
    cparams = assemble_params(params, [:parent_engine, :service_handle, :publisher_namespace, :type_path], :all, :all)
    process_result(system_registry.orphanate_service(cparams))
  rescue StandardError => e
    STDERR.puts("Exception #{e} \n #{e.backtrace}")
    handle_exception(e)
  end
end

post '/v0/system_registry/services/orphans/return/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    params.merge!(post_params(request))
    cparams =  assemble_params(params, [:parent_engine, :service_handle, :publisher_namespace, :type_path], :all, :all)
    process_result(system_registry.rollback_orphaned_service(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

delete '/v0/system_registry/services/orphans/del/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:parent_engine, :service_handle, :type_path, :publisher_namespace])
    process_result(system_registry.release_orphan(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/services/orphan_lost' do
  begin
    process_result(system_registry.orphan_lost_services)
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/services/orphans/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    #  STDERR.puts('GET ORPHANS ' +   params.to_s)
    cparams = assemble_params(params, [:type_path, :publisher_namespace])
    process_result(system_registry.get_orphaned_services(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/services/orphan/:parent_engine/:service_handle/:publisher_namespace/*' do
  begin
    params[:type_path] = params['splat'][0]
    cparams = assemble_params(params, [:parent_engine,:service_handle,:type_path,:publisher_namespace])
    # STDERR.puts( 'ORPHAN get params ' + cparams.to_s)
    process_result(system_registry.retrieve_orphan(cparams))
  rescue StandardError => e
    handle_exception(e)
  end
end

#reparent_orphan

#rebirth_orphan

