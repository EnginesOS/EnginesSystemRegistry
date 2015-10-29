

begin
  
  require 'sinatra'
  require 'json'
  require 'rubytree'
  require_relative'utils.rb'
  require_relative 'system_registry/system_registry.rb'
  
  set :sessions, true
  set :logging, true
  set :run, true

   @system_registry = SystemRegistry.new
    
require_relative 'api/configurations.rb'
require_relative 'api/managed_services.rb'
require_relative 'api/orphan_services.rb'
require_relative 'api/managed_engines.rb'


rescue StandardError=>e 
  log_exception(e)
end
