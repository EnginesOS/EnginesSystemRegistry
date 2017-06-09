begin

  require 'sinatra'
  # require 'yajl'
  require 'rubytree'
  require 'gctools/oobgc'
  require 'ffi_yajl'
  require_relative 'registry/system_registry/system_registry.rb'
  # require_relative 'utils/registry_utils.rb'
  require_relative 'errors/engines_registry_error.rb'
  require_relative 'helpers/helpers.rb'

  set :sessions, true
  set :logging, true
  set :run, true
  require 'objspace'

  $system_registry ||= SystemRegistry.new
  #  before do
  #
  #  end

  after do
    GC::OOB.run()

  end

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
  rescue StandardError => e
    log_error_mesg(request, e, e.backtrace.to_s)
  end

  def json_parser
    @json_parser ||= FFI_Yajl::Parser.new({:symbolize_keys => true})
  end

  def process_result(r, s = 202)
    content_type 'application/json'
    unless r.is_a?(EnginesRegistryError)
      status(s)
    else
      STDERR.puts("Error" + r.to_s)
      status(404)
    end
    STDERR.puts("Error "+ s.to_s + ' ' + r.to_s) if s > 399
    return {} if r.nil?

    if r.is_a?(TrueClass) || r.is_a?(FalseClass)
      r = { BooleanResult: r }.to_json

    elsif r.is_a?(String)
      content_type 'plain/text'
    else
      r = r.to_json
    end
    STDERR.puts("OUT "+ r.to_s )
    r
  rescue StandardError => e
    log_exception(e, result)
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
