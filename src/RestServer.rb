
  
  require 'sinatra'
  require 'json'
  require_relative 'system_registry/system_registry.rb'
require 'rubytree'

   @system_registry = SystemRegistry.new
    
  get '/system_registry/configurations_tree' do
    @system_registry = SystemRegistry.new
    @system_registry.service_configurations_registry_tree.to_json
  end

  get '/system_registry/configurations/' do
    @system_registry = SystemRegistry.new
    p :request_query_string
    p request.query_string
    p :params
   
    r_params = symbolize_keys(params)
    p r_params
     @system_registry.get_service_configurations_hashes(symbolize_keys(params)).to_json
  end

  get '/system_registry/configuration/' do
    @system_registry = SystemRegistry.new
    p request.query_string
    p params
    @system_registry.get_service_configuration(symbolize_keys(params)).to_json
  end
  
  post '/system_registry/configuration/' do
    @system_registry = SystemRegistry.new
    :post_new_conf
    p request.query_string
       p params
     if @system_registry.add_service_configuration(symbolize_keys(params))
       status(202)
     else
       status(404)
     end    
  end
  
  put '/system_registry/configuration' do
    @system_registry = SystemRegistry.new
  if @system_registry.update_service_configuration(service_hash)
    status(202)
  else
    status(404)
  end    
end

delete '/system_registry/configuration' do
  @system_registry = SystemRegistry.new
  if @system_registry.rm_service_configuration(service_hash)
     status(202)
   else
     status(404)
   end    
 end
def symbolize_keys(hash)
  hash.inject({}){|result, (key, value)|
    new_key = case key
    when String then key.to_sym
    else key
    end
    new_value = case value
    when Hash then symbolize_keys(value)
    when Array then
      newval = []
      value.each do |array_val|
        if array_val.is_a?(Hash)
          array_val = symbolize_keys(array_val)
        end
        newval.push(array_val)
      end
      newval
    else value
    end
    result[new_key] = new_value
    result
  }
end
