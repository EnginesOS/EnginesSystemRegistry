require_relative 'engines_error.rb'
require_relative 'engines_exception.rb'

class EnginesRegistryError < EnginesError

  def initialize(mesg, type, *objs )
    super(mesg, type, objs)
    @sub_system = 'engines_registry'
    @params = objs
    @source = nil
  end

  def handle_exception(e, *objs)
    return log_exception(e, *objs) unless e.is_a?(EnginesException)
    @last_error = e.to_s.slice(0, 512)
    STDERR.puts @last_error.to_s
    return EnginesRegistryError.new(e.to_s, e.level, e.params)   
  end
  
  def log_error_mesg(mesg, *objects)
    obj_str = objects.to_s.slice(0, 512)
    @last_error = mesg + ':' + obj_str
    STDERR.puts @last_error.to_s
    EnginesRegistryError.new(mesg, :error, *objects)
  end

  def log_warning_mesg(mesg, *objects)
    obj_str = objects.to_s.slice(0, 256)
    @last_error = mesg + ':' + obj_str
    EnginesRegistryError.new(mesg, :warning, *objects)
  end

  def log_exception(e, *objs)    
    @last_error = e.to_s.slice(0, 512)
    STDERR.puts e.to_s
    STDERR e.backtrace.to_s
    EnginesRegistryError.new(mesg, :exception, *objects)
  end

  def engines_error(mesg, *objects)
    EnginesRegistryError.new(mesg, :error, *objs)
  end

  def engines_warning(mesg, *objects)
    EnginesRegistryError.new(mesg, :warning, *objs)
  end

  def engines_exception(e, *objs)    
    STDERR.puts('Engines Exception')
    log_exception(e, *objs)
    EnginesRegistryError.new(e, e.level, *objs)
  end
  
end

