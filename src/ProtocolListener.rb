class ProtocolListener
  attr_accessor :last_error
  
  require_relative 'SystemRegistry.rb'
  

  def initialize()
    @system_registry = SystemRegistry.new
  end
  
  def  perform_request(command_hash)
    if command_hash != nil
    
    if command_hash.has_key?(:command) == false 
      @last_error="Error_non_command"
      return false
    end
    
    command = command_hash[:command]
      
    if command == nil
         @last_error = "nil command"
         return false
       end
     
    response_hash = Hash.new
    response_hash[:command]=command
    response_hash[:request_value]=command_hash[:value]


      request = command_hash[:value]
    end
     p :command     
       p command
       p :request_hash
       p command_hash
    
    begin 
       method_symbol = command.to_sym
       request_method = @system_registry.method(method_symbol)
       method_params = request_method.parameters
       p method_params
       p "invoking " + command.to_s + " with " + 
    
       if method_params.length ==0
         response_object =  @system_registry.public_send(method_symbol,nil)
       else
         response_object = @system_registry.public_send(method_symbol,request)
       end
       rescue Exception=>e
         p e.to_s
         p "with " + request.to_s + " " +  command.to_s + e.backtrace.to_s
         return false
       end
    
    if response_object.is_a?(Tree::TreeNode)
      response_object = response_object.detached_subtree_copy
    end
    
    response_hash[:object] = response_object.to_yaml

   return response_hash
  
  end
  #requests
  #
  #general Getters
  #
  
  # find_engine_services(params)
  # find_engine_services_hashes
  # get_engine_nonpersistant_services(params)
  # get_engine_persistant_services(params)
  # remove_from_managed_engines_registry(service_hash)
  # add_to_managed_engines_registry(service_hash)
  #
  # save_as_orphan(params)
  # release_orphan(params)
  # reparent_orphan(params)
  # retrieve_orphan(params)
  # get_orphaned_services(params)
  # find_orphan_consumers(params)
  # orphan_service(service_hash)
  #
  # find_service_consumers(service_query_hash)
  # update_attached_service(service_hash)
  # add_to_services_registry(service_hash)
  # remove_from_services_registry
  # service_is_registered?(service_hash)
  # get_registered_against_service(params)
  # 
  # get_service_configurations_hashes(service_hash)
  # update_service_configuration(config_hash)
  # list_providers_in_use
  #
  # system_registry_tree
  # service_configurations_registry
  # orphaned_services_registry
  # services_registry
  # managed_engines_registry 
end