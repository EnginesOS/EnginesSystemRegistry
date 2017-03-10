require_relative 'engines_error.rb'
require_relative 'engines_exception.rb'

class EnginesRegistryError < EnginesError

  def initialize(message, type, *objs )
    super(message, type, objs)
    @sub_system = 'engines_registry'
    @params = objs
  end

  def handle_exception(e, *objs)
    engines_exception(e, *objs) if e.is_a?(EnginesException)    
    log_exception(e, *objs)
  end
  
  def log_error_mesg(msg, *objects)
    obj_str = objects.to_s.slice(0, 256)
    @last_error = msg + ':' + obj_str
    STDERR.puts @last_error.to_s
    EnginesRegistryError.new(msg, :error, *objects)
  end

  def log_warning_mesg(msg, *objects)
    obj_str = objects.to_s.slice(0, 256)
    @last_error = msg + ':' + obj_str
    EnginesRegistryError.new(msg, :warning, *objects)
  end

  def log_exception(e, *objs)
    @last_error = e.to_s.slice(0, 256)
    STDERR.puts @last_error.to_s
    EnginesRegistryError.new(e.to_s, :exception, *objs)
  end

  def engines_error(msg, *objects)
    EnginesRegistryError.new(msg, :error, *objs)
  end

  def engines_warning(msg, *objects)
    EnginesRegistryError.new(msg, :warning, *objs)
  end

  def engines_exception(e, *objs)    
    EnginesRegistryError.new(msg, e.level, *objs)
  end
  
end

