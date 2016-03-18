begin

  require 'sinatra'
  require 'yajl'
  require 'rubytree'

  require_relative 'registry/system_registry/system_registry.rb'

  set :sessions, true
  set :logging, true
  set :run, true

  @@system_registry = SystemRegistry.new
  require_relative 'api/registry_info.rb'
  require_relative 'api/configurations.rb'
  require_relative 'api/managed_services.rb'
  require_relative 'api/orphan_services.rb'
  require_relative 'api/managed_engines.rb'
  require_relative 'api/subservices.rb'



def log_exception(e)
  e_str = e.to_s()
  e.backtrace.each do |bt|
    e_str += bt + ' \n'
  end
  @@last_error = e_str
  STDERR.puts e_str
  SystemUtils.log_output(e_str, 10)
  f = File.open('/opt/engines/run/service_manager/exceptions.' + Process.pid.to_s, 'a+')
  f.puts(e_str)
  f.close
  return false
end
end
