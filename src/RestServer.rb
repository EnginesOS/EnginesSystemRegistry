begin

  require 'sinatra'
 # require 'yajl'
  require 'rubytree'
  require 'gctools/oobgc'
  require 'ffi_yajl'
  require_relative 'registry/system_registry/system_registry.rb'
  require_relative 'utils/registry_utils.rb'
  require_relative 'errors/engines_registry_error.rb'
  set :sessions, true
  set :logging, true
  set :run, true

  $system_registry = SystemRegistry.new

#  after do
  #  GC::OOB.run()
 # end
  

  
  
  require_relative 'api/registry_info.rb'
  require_relative 'api/configurations.rb'
  require_relative 'api/orphan_services.rb'
  require_relative 'api/managed_services.rb'
  require_relative 'api/managed_engines.rb'
  require_relative 'api/subservices.rb'
  require_relative 'api/shares.rb'

  def system_registry
    $system_registry
  end

  def post_params(request)
    json_parser.parse(request.env["rack.input"].read)
   # RegistryUtils.symbolize_keys( JSON.parse(request.env["rack.input"].read, :create_additons => true ))
  rescue StandardError => e
    log_error_mesg(request, e, e.backtrace.to_s)
    {}
  end
  
  
  def json_parser
    #  @json_parser = Yajl::Parser.new(:symbolize_keys => true) if @json_parser.nil?
    @json_parser = FFI_Yajl::Parser.new({:symbolize_keys => true})  if @json_parser.nil?
     @json_parser
   end
   
   
  def process_result(result)
    unless result.is_a?(EnginesRegistryError)
      status(202)
    else
      status(404)
    end
    #  FFI_Yajl::Encoder.encode(result)
    result.to_json
  rescue StandardError => e
    log_exception(e, result)
  end

  def log_exception(e, *obj)
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
