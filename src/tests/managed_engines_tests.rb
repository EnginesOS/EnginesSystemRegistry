

test_type('Managed Engines Regsitry')


annouce_test("Tree")
obj = rest_get('/system_registry/engines/tree', nil)
test_failed('Loading Tree', obj) unless obj.is_a?(Tree::TreeNode)


annouce_test("Find service hash for an engine")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'dns'
params[:service_handle] = 'dns'
params[:service_container_name] = 'dns'
obj = rest_get('/system_registry/engine/service/',{:params => params })
test_failed('Failed to find', obj) unless obj.is_a?(Hash)

    
annouce_test("Find service hashes for an engine ")
params = {}
params[:container_type] = 'service'
params[:parent_engine] = 'auth'
obj = rest_get('/system_registry/engine/services/',{:params => params })
test_failed('Failed to find', obj) unless obj.is_a?(Array)


annouce_test("Find non persist service hashes for an engine ")
params = {}
params[:container_type] = 'service'
params[:parent_engine] = 'mysql_server'
obj = rest_get('/system_registry/engine/services/nonpersistant/',{:params => params })
test_failed('Failed to find', obj) unless obj.is_a?(Array)

  
annouce_test("Find  persist service hashes for an engine ")

params = {}
params[:container_type] = 'service'
params[:parent_engine] = 'auth'
obj = rest_get('/system_registry/engine/services/persistant/',{:params => params })
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
obj = rest_post('/system_registry/engine/services/',params )
test_failed('Failed to add', obj) unless obj.is_a?(Array)

annouce_test("Find service hash for an engine")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'test'
params[:service_handle] = 'test_dns'
params[:service_container_name] = 'dns'
obj = rest_get('/system_registry/engine/service/',{:params => params })
test_failed('Failed to find added', obj) unless obj.is_a?(Hash)
 

annouce_test("Update service hash from an engine")

params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'test'
params[:service_handle] = 'test_dns'
params[:service_container_name] = 'dns'
params[:variables] = {}
params[:variables][:service_handle] = params[:service_handle]
params[:variables][:ip] = 'ip2'
params[:variables][:hostname] = 'ip2'
obj = rest_get('/system_registry/engine/service/',{:params => params })
test_failed('Failed to update', obj) unless obj == true
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'test'
params[:service_handle] = 'test_dns'
params[:service_container_name] = 'dns'
obj = rest_get('/system_registry/engine/service/',{:params => params })
test_failed('Failed to find modified', obj) unless obj.is_a?(Hash)
test_failed(' modified Failed', obj) unless obj[:variables][:hostname] == 'ip2'

annouce_test("Remove service hash from an engine")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'test'
params[:service_handle] = 'test_dns'
params[:service_container_name] = 'dns'
obj = rest_delete('/system_registry/engine/services/',{:params => params })
test_failed('Failed to del added', obj) unless obj == true

annouce_test("checl did Remove service hash from an engine")
params = {}
obj = rest_get('/system_registry/engine/service/',{:params => params })
test_failed('Failed as found deleted ', obj) if obj.is_a?(Hash)


