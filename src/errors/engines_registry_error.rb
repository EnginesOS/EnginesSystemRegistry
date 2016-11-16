require_relative 'engines_error.rb'
class EnginesRegistryError < EnginesError
 
  
    def initialize(message, type, *objs )
      super(message, type)
        @sub_system = 'engines_registry'
        @params = objs
      end
      
#
 
end

