require_relative 'engines_error.rb'
class EnginesRegistryError < EnginesError
 
  
    def initialize(message, type, *objs )
      super(message, type)
        @sub_system = 'engines_registry'
        @params = objs
      end
      
#  def to_json(opt=nil)
#  #FixMe this is a kludge
#     return '{"error_type":"' + @error_type.to_s + '","error_mesg":"' + @error_mesg.to_s + '","sub_system":"' + @sub_system.to_s +  '","params":' + @params.to_json + '}'
#  end
#  
 
end
""
