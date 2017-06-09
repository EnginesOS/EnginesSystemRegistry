get '/v0/system_registry/status/' do
  'true'
end

get '/v0/system_registry/tree' do
  process_result(registry_as_hash(system_registry.system_registry_tree))
end

get '/v0/system_registry/heap_stats' do
  dump_stats = system_registry.dump_heap_stats
  return log_error(request, dump_stats) if  dump_stats.is_a?(EnginesError)
  status(202)
  content_type 'text/plain'
  dump_stats.to_s
end