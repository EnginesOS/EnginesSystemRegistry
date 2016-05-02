require_relative 'engines_error.rb'
class EnginesRegistryError < EnginesError
 
  
    def initialize(message, type, *objs )
      super
        @sub_system = 'engines_registry'
        @registry_source = error_hash[:source]
        @params = objs
      end
      
  def to_json(opt)
  #FixMe this is a kludge
      '{"error_type":"' + @error_type.to_s + '","error_mesg":"' + @error_mesg.to_s + '","sub_system":"' + @sub_system.to_s + '","source":"' + @source.to_s + '","params":"' + @params.to_s + '"}'
  end
  
 
end
