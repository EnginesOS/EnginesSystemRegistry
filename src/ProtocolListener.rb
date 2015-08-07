class ProtocolListener
  attr_accessor :last_error
  
  require_relative 'SystemRegistry.rb'
  

  def initialize()
    @system_registry = SystemRegistry.new
    @registry_lock = Mutex.new
  end
  

  
  def  perform_request(command_hash)
    if is_command_hash_valid?(command_hash)== false
      return false
    end
   
    command = command_hash[:command]
    request = command_hash[:value]
        
    response_hash = Hash.new
    response_hash[:command]=command
    response_hash[:request_value]=command_hash[:value]

    begin
    @registry_lock.synchronize  {
  
       method_symbol = command.to_sym
       request_method = @system_registry.method(method_symbol)
       method_params = request_method.parameters
       p method_params
       p "invoking " + command.to_s + " with " + method_params.to_s
    
     
       if method_params.length ==0
         response_object =  @system_registry.public_send(method_symbol)
       else
         response_object = @system_registry.public_send(method_symbol,request)
       end  
    }
       
       rescue Exception=>e
         p e.to_s
         p "with " + request.to_s + " " +  command.to_s + e.backtrace.to_s
      @registry_lock.unlock
         return false
       end
 
  
    if response_object.is_a?(Tree::TreeNode)
      response_object = response_object.detached_subtree_copy
    end
    
    response_hash[:object] = response_object.to_yaml

   return response_hash
  ensure 
      @registry_lock.unlock
  end
  
  def is_command_hash_valid?(command_hash)
    if command_hash == nil
          return false
    elsif command_hash.has_key?(:command) == false 
          @last_error="Error_non_command"
          return false
    elsif command_hash[:command]  == nil
      @last_error = "nil command"
       return false
     end
     return true
  end

end