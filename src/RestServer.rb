
  
  require 'sinatra'
  require 'json'
  require_relative 'system_registry/system_registry.rb'
require 'rubytree'

   @@system_registry = SystemRegistry.new
    
 require_relative 'configurations.rb'
 
 
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
