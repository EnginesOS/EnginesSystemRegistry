begin

  require 'sinatra'
  # require 'yajl'
  require 'rubytree'

  require 'ffi_yajl'
  require_relative 'registry/system_registry/system_registry.rb'
  # require_relative 'utils/registry_utils.rb'
  require_relative 'errors/engines_registry_error.rb'
  require_relative 'helpers/helpers.rb'

  require_relative 'api/registry_info.rb'
  require_relative 'api/configurations.rb'
  require_relative 'api/orphan_services.rb'
  require_relative 'api/managed_services.rb'
  require_relative 'api/managed_engines.rb'
  require_relative 'api/subservices.rb'
  require_relative 'api/shares.rb'

  class Application < Sinatra::Base
    set :sessions, true
    set :logging, true
    set :run, true
    set :timeout, 60
  end
  require 'objspace'

  $system_registry ||= SystemRegistry.new
  before do
    redirect  '/v0/unauthenticated' unless authenticate

    # authenticate
  end

#  after do
#   GC::OOB.run()
# end

  def system_registry
    $system_registry
  end

  def post_params(request)
    json_parser.parse(request.env["rack.input"].read)
  rescue StandardError => e
    log_error_mesg(request, e, e.backtrace.to_s)
  end

  def json_parser
    @json_parser ||= FFI_Yajl::Parser.new({:symbolize_keys => true})
  end

  def handle_exception(e)
    unless e.is_a?(EnginesException) || e.is_a?(EnginesRegistryError)
      process_result(e, 400)
    else
      STDERR.puts  e.to_s.slice(0, 512).to_s
      if e.level == :warning
        ec = 403
      else
        ec = 400
      end
      process_result(e, ec)
    end
  end

  def process_result(r, s = 202)
    unless r.nil?
  
      #  STDERR.puts("process_result" + r.to_s)
      content_type 'application/json'
      if r.is_a?(EnginesRegistryError) || r.is_a?(StandardError)
        STDERR.puts("Error:" + r.class.name  + ':' + r.to_s)
        
        source = []
        source[0] = caller[1].to_s
          source[1] = caller[2].to_s
        source[2] = caller[3].to_s if caller.count >= 4
        source[3] = caller[4].to_s if caller.count >= 5
        STDERR.puts("Error:" + source.to_s)
        s = 404 if s == 202
        status(s)        
        r = r.to_json
      else
        status(s)
        if r.is_a?(TrueClass) || r.is_a?(FalseClass)
          r = { BooleanResult: r }.to_json
        elsif r.is_a?(String)
          content_type 'plain/text'
        else
          r = r.to_json
        end
        STDERR.puts("Error e 400 or more"+ s.to_s + ' ' + r.to_s) if s > 399
      end
    else
      content_type 'plain/text'
      r = ''
    end

    #STDERR.puts("OUT " + r[0..256]) unless r.nil?
    r
  rescue StandardError => e
    log_exception(e, r)
  end

  def log_exception(e, *obj)
    e_str = e.to_s()
    e.backtrace.each do |bt|
      e_str += bt + ' \n'
    end

    STDERR.puts e_str
    SystemUtils.log_output(e_str, 10)
    f = File.open('/opt/engines/run/service_manager/exceptions.' + Process.pid.to_s, 'a+')
    f.puts(e_str)
    f.close
    false
  end
end
