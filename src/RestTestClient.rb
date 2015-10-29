
  require 'rest-client'
  require 'rubytree'
require_relative'utils.rb'
  
### Test Configurations
p :CONFIGURATIONS

  r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations_tree', nil)
 obj = JSON.parse(r, :create_additions => true)
   p :Configuration_tree_error unless obj.is_a?(Tree::TreeNode)

  p :get_hashes_test
  params = {}
  params[:service_name]='cert_auth'
  r = RestClient.get('http://127.0.0.1:4567/system_registry/configurations/',{:params => params })
  obj = JSON.parse(r, :create_additions => true)
  p :Configuration_hashes_test_error unless obj.is_a?(Array)
 
p :get_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='system_ca'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configuration/',{:params => params })
 obj = JSON.parse(r, :create_additions => true)
p :Configuration_hashes_test_error unless  obj.is_a?(Hash)
 
p :add_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
params[:variables] = {}
params[:variables][:test_var] = "TEST INGS"
r = RestClient.post('http://127.0.0.1:4567/system_registry/configuration/',params )
p r
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configuration/',{:params => params })
 robj = JSON.parse(r, :create_additions => true)
 p robj.to_s
 p r
 obj = symbolize_keys(robj)
p :add_failed_to_add unless  obj.is_a?(Hash) && obj[:variables].is_a?(Hash) && obj[:variables][:test_var] = 'TEST INGS'

 
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
 robj = JSON.parse(r, :create_additions => true) 
obj = symbolize_keys(robj)
p :failed_to_update unless  obj.is_a?(Hash)
p :failed_to_update  unless obj[:variables].is_a?(Hash) && obj[:variables][:test_var] = 'TESTINGS'

p :del_hash_test
params = {}
params[:service_name]='cert_auth'
params[:configurator_name]='test_ca'
r = RestClient.delete('http://127.0.0.1:4567/system_registry/configuration/',{:params => params } )
p r

r =   RestClient.get('http://127.0.0.1:4567/system_registry/configuration/',{:params => params })
  p r
p :add_failed_to_del unless r == 'false'


 
 
 
p :MANAGED_ENGINES
p :get_tree_test
  r =   RestClient.get('http://127.0.0.1:4567/system_registry/managed_engines_tree', nil)
 obj = JSON.parse(r, :create_additions => true)
p :MANAGED_ENGINES_tree_error unless obj.is_a?(Tree::TreeNode)
p obj
 
params = {}

params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'dns'
params[:service_handle] = 'dns'
params[:service_container_name] = 'dns'
r = RestClient.get('http://127.0.0.1:4567/system_registry/engine_service_hash/',{:params => params })
  obj = JSON.parse(r, :create_additions => true)
  p :Configuration_hashes_test_error unless obj.is_a?(Hash)
  
  
  
  
p :MANAGED_SERVCES
r =   RestClient.get('http://127.0.0.1:4567/system_registry/managed_services_tree', nil)
obj = JSON.parse(r, :create_additions => true)
p :MANAGED_SERVCES_tree_error unless obj.is_a?(Tree::TreeNode)


p :ORPHAN_SERVICES
r =   RestClient.get('http://127.0.0.1:4567/system_registry/orphan_services_tree', nil)
obj = JSON.parse(r, :create_additions => true)
p obj.class.name
p :ORPHAN_SERVCES_tree_error unless obj.is_a?(Tree::TreeNode)