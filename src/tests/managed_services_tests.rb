

test_type('Managed Services Regsitry')

annouce_test("Tree")
obj = rest_get('/system_registry/services/tree', nil)
test_failed('Loading Tree', obj) unless obj.is_a?(Tree::TreeNode)

annouce_test("all_engines_registered_to")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:service_container_name] = 'dns'
obj = rest_get('/system_registry/service/registered/engines/',{:params => params })
test_failed('Failed registered/engines/', obj) unless obj.is_a?(Array)

annouce_test("find_service_consumers")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:service_handle] = 'mgmt_dns'
params[:service_container_name] = 'dns'
obj = rest_get('/system_registry/service/consumers/',{:params => params })
  p obj
test_failed('Failed registered/engines/', obj) unless obj.is_a?(Tree::TreeNode)

annouce_test("list_providers_in_use")
params = {}
params[:publisher_namespace] = 'EnginesSystem'
obj = rest_get('/system_registry/services/providers/in_use/',{:params => params })
test_failed('Failed list_providers_in_use', obj) unless obj.is_a?(Array)

annouce_test("get_registered_against_service")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
obj = rest_get('/system_registry/service/registered/',{:params => params })
test_failed('Failed to find istry/service/registered', obj) unless obj.is_a?(Array)

params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'mgmt'
params[:service_handle] = 'mgmt_dns'
params[:service_container_name] = 'dns'
annouce_test('service_is_registered')
obj = rest_get('/system_registry/service/is_registered',{:params => params })
test_failed('Failed /system_registry/service/is_registered', obj) unless obj.is_a?(TrueClass)

obj = rest_get('/system_registry/service/',{:params => params })
test_failed('Failed system_registry/service/', obj) unless obj.is_a?(Hash)


annouce_test('add service')
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
obj = rest_post('/system_registry/services/',{:params => params })
test_failed('Failed /system_registry/service/is_registered', obj) unless obj.is_a?(TrueClass)

obj = rest_get('/system_registry/service/',{:params => params })
test_failed('Failed system_registry/service/', obj) unless obj.is_a?(Hash)

annouce_test('update service')
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
obj = rest_put('/system_registry/service/',{:params => params })
test_failed('Faile update service', obj) unless obj.is_a?(Hash)
test_failed('Faile update service', obj) unless obj[:variables].is_a?(Hash) && obj[:variables][:hostname] == 'ip2' 

annouce_test('remove_from_services_registry')
annouce_test('update service')
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
obj = rest_delete('/system_registry/services/',{:params => params })
test_failed('Failed delete/system_registry/servic', obj) unless obj.is_a?(TrueClass)
obj = rest_get('/system_registry/service/',{:params => params })
test_failed('Failed to delete', obj) unless obj.is_a?(FalseClass)
#' 