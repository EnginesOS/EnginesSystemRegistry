
  require 'rest-client'
  require 'rubytree'
  
p :get_tree_test
  r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations_tree', nil)

 obj = JSON.parse(r, :create_additions => true)
 p r.class
 p 'PPPPPPPPPPPPPPPPP'
 p obj.class
 p 'OOOOOOOOOOOOOOOOO'
 
p :get_hashes_test
params = {}
params[:name]='cert_auth'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations/',{:params => params })
 obj = JSON.parse(r, :create_additions => true)
 p obj.to_s
 
p :get_hash_test
params = {}
params[:name]='cert_auth'
params[:configurator_name]='system_ca'
r =   RestClient.get('http://127.0.0.1:4567/system_registry/configuration/',{:params => params })


 obj = JSON.parse(r, :create_additions => true)
 p obj.to_s
 