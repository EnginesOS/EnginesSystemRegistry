get '/v0/system_registry/status/' do
  begin
    'true'
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/tree' do
  begin
    process_result(registry_as_hash(system_registry.system_registry_tree))
  rescue StandardError => e
    handle_exception(e)
  end
end

get '/v0/system_registry/heap_stats' do
  begin
    dump_stats = system_registry.dump_heap_stats
    if dump_stats.is_a?(EnginesError)
      log_error(request, dump_stats)
    else
      status(202)
      content_type 'text/plain'
      "#{dump_stats}"
    end
  rescue StandardError => e
    handle_exception(e)
  end
end