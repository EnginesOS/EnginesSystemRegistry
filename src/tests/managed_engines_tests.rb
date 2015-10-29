

test_type('Managed Engines Regsitry')


annouce_test("Tree")
obj = rest_get('/system_registry/managed_engines_tree', nil)
test_failed('Loading Tree', obj) unless obj.is_a?(Tree::TreeNode)


annouce_test("Find service hash for an engine")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'dns'
params[:service_handle] = 'dns'
params[:service_container_name] = 'dns'
obj = rest_get('/system_registry/engine_service_hash/',{:params => params })
test_failed('Failed to find', obj) unless obj.is_a?(Hash)

    
annouce_test("Find service hashes for an engine ")
params = {}
params[:container_type] = 'service'
params[:parent_engine] = 'auth'
obj = rest_get('/system_registry/engine_services',{:params => params })
test_failed('Failed to find', obj) unless obj.is_a?(Array)


annouce_test("Find non persist service hashes for an engine ")
params = {}
params[:container_type] = 'service'
params[:parent_engine] = 'mysql_server'
obj = rest_get('/system_registry/engine_nonpersistant_services/',{:params => params })
test_failed('Failed to find', obj) unless obj.is_a?(Array)

  
annouce_test("Find  persist service hashes for an engine ")

params = {}
params[:container_type] = 'service'
params[:parent_engine] = 'auth'
obj = rest_get('/system_registry/engine_persistant_services/',{:params => params })
test_failed('Failed to find', obj) unless obj.is_a?(Array)


annouce_test("attach service hashes to an engine ")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'test'
params[:service_handle] = 'test_dns'
params[:service_container_name] = 'dns'
params[:variables] = {}
params[:variables][:service_handle] = params[:service_handle]
params[:variables][:ip] = 'ip'
params[:variables][:hostname] = 'ip'
obj = rest_post('/system_registry/add_to_managed_engines_registry',{:params => params })
test_failed('Failed to add', obj) unless obj.is_a?(Array)

annouce_test("Find service hash for an engine")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'test'
params[:service_handle] = 'dns'
params[:service_container_name] = 'test_dns'
obj = rest_get('/system_registry/engine_service_hash/',{:params => params })
test_failed('Failed to find added', obj) unless obj.is_a?(Hash)



