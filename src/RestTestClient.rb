
  require 'rest-client'
  r =   RestClient.post('http://127.0.0.1:4567/system_registry/configurations_tree', TrueClass.to_json, :content_type => :json, :accept => :json)
 p r
