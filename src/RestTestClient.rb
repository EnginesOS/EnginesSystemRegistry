
  require 'rest-client'
  require 'rubytree'
  r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations_tree', nil)
 p :get_tree_test
 obj = JSON.parse(r)
 p r
 p 'PPPPPPPPPPPPPPPPP'
 p obj.class
 p 'OOOOOOOOOOOOOOOOO'
 
 
params = {}
params[:name]='cert_auth'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations',params)

p :get_hashes_test
 obj = JSON.parse(r)
 p obj.to_s
 
params = {}
params[:name]='cert_auth'
params[:configurator_name]='system_ca'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configuration',params)

p :get_hash_test
 obj = JSON.parse(r)
 p obj.to_s
 