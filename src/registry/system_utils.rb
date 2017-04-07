class SystemUtils
  @@debug = true
  @@level = 5

  attr_reader :debug, :level
  def self.debug_output(label, object)
    if SystemUtils.debug
      STDERR.puts label.to_s
      STDERR.puts  object.to_s
    end
  end

  def self.log_output(object, level)
    if SystemUtils.level < level
      STDERR.puts 'Error'
      STDERR.puts  object.to_s
    end
  end

  # @Logs to  std out the @msg followed by @object.to_s
  # Logs are written to apache/error.log
  # error mesg is truncated to 512 bytes
  # returns nothing
  def self.log_error_mesg(msg, object)
    obj_str = object.to_s.slice(0, 512)
    SystemUtils.log_output(msg + ':->:' + obj_str, 10)
  end

  def self.log_error(object)
    SystemUtils.log_output(object, 10)
  end


  def self.log_exception(e)
    e_str = e.to_s()
    e.backtrace.each do |bt|
      e_str += bt + ' \n'
    end
   
    p e_str
    SystemUtils.log_output(e_str, 10)
    f = File.open('/opt/engines/run/service_manager/exceptions.' + Process.pid.to_s, 'a+')
    f.puts(e_str)
    f.close
  end

  

  def self.level
     @@level
  end

  def self.debug
     @@debug
  end

end
