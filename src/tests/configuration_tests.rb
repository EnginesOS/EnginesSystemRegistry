### Test Configurations

test_type('Configurations Regsitry')

annouce_test("Tree")
obj = rest_get('/system_registry/services/configurations/tree', nil)
test_failed('Loading Tree', obj) unless obj.is_a?(Tree::TreeNode)
annouce_test("Get Hashes")
  params = {}
  params[:service_name]='cert_auth'
  obj = rest_get('/system_registry/services/configurations/',{:params => params })
  test_failed('Retrieve Configurations for a service', obj) unless obj.is_a?(Array)
 
annouce_test("Get Hash")
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='system_ca'
obj = rest_get('/system_registry/services/configuration/',{:params => params })
test_failed('Retrieve Configuration for a configurator', obj)  unless  obj.is_a?(Hash)
 
annouce_test("Add Hash")
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
params[:variables] = {}
params[:variables][:test_var] = "TEST INGS"
obj = rest_post('/system_registry/services/configurations/',params )
annouce_test("Check Add Hash")
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
obj = rest_get('/system_registry/services/configuration/',{:params => params })
 
test_failed('Add a Configuration for a configurator', obj) unless  obj.is_a?(Hash) && obj[:variables].is_a?(Hash) && obj[:variables][:test_var] = 'TEST INGS'

 
annouce_test("Update Hash")
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
params[:variables] = {}
params[:variables][:test_var] = "TESTINGS"
obj = rest_put('/system_registry/services/configuration/',params )
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
obj = rest_get('/system_registry/services/configuration/',{:params => params })
test_failed('Update a Configuration for a configurator', obj)unless  obj.is_a?(Hash)
test_failed('Update a Configuration for a configurator', obj) unless obj[:variables].is_a?(Hash) && obj[:variables][:test_var] = 'TESTINGS'
annouce_test("Delete Hash")
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
obj = rest_delete('/system_registry/services/configurations/',{:params => params } )
test_failed('Delete a Configuration for a configurator', obj) unless obj == true
annouce_test("Check Deleted Hash")
obj = rest_get('/system_registry/services/configuration/',{:params => params })
test_failed('Delete (acutally) a Configuration for a configurator', obj)  unless obj.is_a?(FalseClass)

 