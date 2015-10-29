
  require 'rest-client'
  r =   RestClient.get('http://127.0.0.1:4567/system_registry/configurations_tree', TrueClass.to_json)
 p r
