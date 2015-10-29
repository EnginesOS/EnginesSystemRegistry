
  require 'rest-client'
  require 'rubytree'
  
  
### Test Configurations
p :CONFIGURATIONS
p :get_tree_test
  r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations_tree', nil)
 obj = JSON.parse(r, :create_additions => true)
 p obj.class
 
p :get_hashes_test
params = {}
params[:service_name]='cert_auth'
r = RestClient.get('http://127.0.0.1:4567/system_registry/configurations/',{:params => params })
 obj = JSON.parse(r, :create_additions => true)
 p obj.to_s
 
p :get_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='system_ca'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configuration/',{:params => params })
 obj = JSON.parse(r, :create_additions => true)
 p obj.to_s
 
p :add_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
params[:variables] = {}
params[:variables][:test_var] = "TEST INGS"
r = RestClient.post('http://127.0.0.1:4567/system_registry/configuration/',params )

params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configuration/',{:params => params })
 obj = JSON.parse(r, :create_additions => true)
 p obj.to_s
 p r
p :update_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
params[:variables] = {}
params[:variables][:test_var] = "TESTINGS"
r = RestClient.put('http://127.0.0.1:4567/system_registry/configuration/',params )
p r
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configuration/',{:params => params })
 obj = JSON.parse(r, :create_additions => true)
 p obj.to_s
 p r
p :del_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
r = RestClient.delete('http://127.0.0.1:4567/system_registry/configuration/',{:params => params } )
p r
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configuration/',{:params => params })
 p r
 
 
p :MANAGED_ENGINES
p :get_tree_test
  r =   RestClient.get('http://127.0.0.1:4567/system_registry/managed_engines_tree', nil)
 obj = JSON.parse(r, :create_additions => true)
 p obj.class
 
 
 
 
p :MANAGED_SERVCES
r =   RestClient.get('http://127.0.0.1:4567/system_registry/managed_services_tree', nil)
obj = JSON.parse(r, :create_additions => true)
p obj.class





p :ORPHAN_SERVICES
r =   RestClient.get('http://127.0.0.1:4567/system_registry/orphan_services_tree', nil)
obj = JSON.parse(r, :create_additions => true)
p obj.class
