
  require 'rest-client'
  r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations_tree', nil)
 p r
 obj = JSON.parse(r)
 p obj.to_s
