require_relative 'engines_error.rb'
require_relative 'engines_exception.rb'

class EnginesRegistryError < EnginesError

  def initialize(mesg, type, *objs )
    super(mesg, type, objs)
    @sub_system = 'engines_registry'
    @params = objs
  end

  def handle_exception(e, *objs)
    engines_exception(e, *objs) if e.is_a?(EnginesException)    
    log_exception(e, *objs)
  end
  
  def log_error_mesg(mesg, *objects)
    obj_str = objects.to_s.slice(0, 256)
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
    @last_error = e.to_s.slice(0, 256)
    STDERR.puts @last_error.to_s
    EnginesRegistryError.new(e.to_s, :exception, *objs)
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

