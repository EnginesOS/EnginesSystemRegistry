### Test Configurations

test_type('Configurations Regsitry')

  r = rest_get('/system_registry/configurations_tree', nil)
 obj = JSON.parse(r, :create_additions => true)
   p :Configuration_tree_error unless obj.is_a?(Tree::TreeNode)

  p :get_hashes_test
  params = {}
  params[:service_name]='cert_auth'
  obj = rest_get('/system_registry/configurations/',{:params => params })
  p :Configuration_hashes_test_error unless obj.is_a?(Array)
 
p :get_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='system_ca'
obj = rest_get('/system_registry/configuration/',{:params => params })
p :Configuration_hashes_test_error unless  obj.is_a?(Hash)
 
p :add_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
params[:variables] = {}
params[:variables][:test_var] = "TEST INGS"
obj = rest_post('/system_registry/configuration/',params )
p obj
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
ob = rest_get('/system_registry/configuration/',{:params => params })
 
p :add_failed_to_add unless  obj.is_a?(Hash) && obj[:variables].is_a?(Hash) && obj[:variables][:test_var] = 'TEST INGS'

 
p :update_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
params[:variables] = {}
params[:variables][:test_var] = "TESTINGS"
obj = rest_put('/system_registry/configuration/',params )
p obj
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
r = rest_get('/system_registry/configuration/',{:params => params })
 obj = JSON.parse(r, :create_additions => true) 

p :failed_to_update unless  obj.is_a?(Hash)
p :failed_to_update  unless obj[:variables].is_a?(Hash) && obj[:variables][:test_var] = 'TESTINGS'

p :del_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
r = rest_delete('/system_registry/configuration/',{:params => params } )
p r

r = rest_get('/system_registry/configuration/',{:params => params })
  p r
p :add_failed_to_del unless r == 'false'


 