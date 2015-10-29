
  require 'rest-client'
  r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations_tree', nil)
 p :get_tree_test
 obj = JSON.parse(r)
 p obj.to_s
 
params = {}
params[:name]='cert_auth'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations',params)

p :get_hashs_test
 obj = JSON.parse(r)
 p obj.to_s
 