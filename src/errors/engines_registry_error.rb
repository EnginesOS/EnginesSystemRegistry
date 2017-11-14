require_relative 'engines_error.rb'
require_relative 'engines_exception.rb'

class EnginesRegistryError < EnginesError
  def initialize(mesg, type, *objs )
    super(mesg, type, objs)
    @sub_system = 'engines_registry'
    @params = objs
    @source = caller.to_s
  end

  def handle_exception(e, *objs)
    unless e.is_a?(EnginesException)
      log_exception(e, *objs)
    else
      STDERR.puts  e.to_s.slice(0, 512).to_s
      EnginesRegistryError.new(e.to_s, e.level, e.params)
    end
  end

  def log_error_mesg(mesg, *objs)
    obj_str = objs.to_s.slice(0, 512)
    STDERR.puts mesg + ':' + obj_str
    EnginesRegistryError.new(mesg, :error, *objs)
  end

  def log_warning_mesg(mesg, *objs)
    obj_str = objs.to_s.slice(0, 256)
    EnginesRegistryError.new(mesg, :warning, *objs)
  end

  def log_exception(e, *objs)
    error  = e.to_s
    error  += e.backtrace.to_s
    error = e.to_s.slice(0, 512)
    STDERR.puts('EXCEPTION:' + e.to_s + ' ' + e.backtrace.to_s)

    EnginesRegistryError.new(error, :exception, *objs)
  end

  def engines_error(mesg, *objs)
    EnginesRegistryError.new(mesg, :error, *objs)
  end

  def engines_warning(mesg, *objs)
    EnginesRegistryError.new(mesg, :warning, *objs)
  end

  def engines_exception(e, *objs)
    STDERR.puts('Engines Exception')
    log_exception(e, *objs)
    EnginesRegistryError.new(e, e.level, *objs)
  end

end

