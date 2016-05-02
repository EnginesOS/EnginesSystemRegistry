class ProtocolListener
  attr_accessor :last_error

  require_relative 'system_registry/system_registry.rb'
  
  # Create new System Registry
  def initialize
    @system_registry = SystemRegistry.new
  end

  # Invoke the method mapped to the command_hash[:command], with the parrameters supplied in  command_hash[:value]
  # @return false if @param command_hash is invalid or and exception is thrown
  # #return [Hash] response_object with the keys :reply_object and :last_error
  
  def perform_request(command_hash)
    return false if !is_command_hash_valid?(command_hash)
    command = command_hash[:command]
    request = command_hash[:value]
    response_hash = {}
    response_hash[:command] = command
    response_hash[:request_value] = command_hash[:value]
    response_object = ''
    begin
      method_symbol = command.to_sym
      request_method = @system_registry.method(method_symbol)
      method_params = request_method.parameters
      p method_params
      p 'invoking ' + command.to_s + ' with ' + request.to_s + "source" + " : " # + command_hash.to_s
      @system_registry.sync
      if method_params.length == 0
        response_object = @system_registry.public_send(method_symbol)
      else
        response_object = @system_registry.public_send(method_symbol, request)
      end
    rescue StandardError => e
      log_error_mesg( 'with ' + request.to_s + ' ' + command.to_s + @system_registry.last_error.to_s, command_hash)
      log_exception(e)
      response_hash[:reply_object] = false.to_yaml
      response_hash[:last_error] = e.to_s
      return response_hash
    end
    response_object = response_object.detached_subtree_copy if response_object.is_a?(Tree::TreeNode)      
    response_hash[:reply_object] = response_object.to_yaml
    response_hash[:last_error] = @system_registry.last_error
    return response_hash
  end

  # shutdown the system registry
  def shutdown
    @system_registry.shutdown
  end
  private
  
  # @return bloolean is param @command_hash is hash with the key :command
  def is_command_hash_valid?(command_hash)
    return false if command_hash.nil?      
    return SystemUtils.log_error_mesg('Error_no command', command_hash) if !command_hash.key?(:command)
    return SystemUtils.log_error_mesg('nil command', command_hash) if command_hash[:command].nil?
    return true
  end


end
