test_type('Orphaned Services Regsitry')
annouce_test("Tree")
obj = rest_get('/system_registry/services/orphans/tree', nil)
test_failed('Loading Tree', obj) unless obj.is_a?(Tree::TreeNode)


annouce_test("get_orphaned_services")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
obj = rest_post('/system_registry/services/orphans/',{:params => params } )
test_failed('Failed ti list orphan services', obj) unless obj.is_a?(Array)
annouce_test("orphanate_service")

params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'auth'
params[:service_handle] = 'test'
params[:service_container_name] = 'dns'
params[:variables] = {}
params[:variables][:service_handle] = params[:service_handle]
params[:variables][:ip] = 'ip'
params[:variables][:hostname] = 'ip' 
obj = rest_post('/system_registry/services/',params )
test_failed('Failed add service to orphanate', obj) unless obj  == true
obj = rest_post('/system_registry/services/orphans/',{:params => params } )
test_failed('Failed orphanate_service', obj) unless obj  == true





annouce_test("get_orphan")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:service_handle] = 'test' 
obj = rest_get('/system_registry/services/orphan/',{:params => params } )
test_failed('Failed orphanate_service', obj) unless obj.is_a?(Hash)



annouce_test("release orphan")
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:service_handle] = 'test' 
obj = rest_delete('/system_registry/services/orphans/',{:params => params } )
test_failed('Failed release oprhan', obj) unless obj  == true
