class EnginesError # < FalseClass
  attr_accessor :source, :error_type, :error_mesg, :sub_system
  def initialize(message, type, *objs )
    @error_mesg = message
    @error_type = type
    @sub_system = 'global'
    @source = []
    @source[0] = caller[2].to_s
    @source[1] = caller[3].to_s if caller.count >= 4
    @source[2] = caller[4].to_s if caller.count >= 5
    @params = objs
  end

  def to_h
    self.instance_variables.each_with_object({}) { |var, hash| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
  end

  def to_s
    @sub_system.to_s + ':' +  @error_type.to_s + ':'  + @error_mesg.to_s + ':' + @source.to_s
  end

  def to_json(opt = nil)
     self.to_h.to_json(opt)
  end

end

