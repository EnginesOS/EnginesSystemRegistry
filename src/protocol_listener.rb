class ProtocolListener
  attr_accessor :last_error

  require_relative 'system_registry/system_registry.rb'
  def initialize
    @system_registry = SystemRegistry.new
  end

  
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
      p 'invoking ' + command.to_s + ' with ' + request.to_s + "source" + " : " + command_hash.to_s
      if method_params.length == 0
        response_object = @system_registry.public_send(method_symbol)
      else
        response_object = @system_registry.public_send(method_symbol, request)
      end
    rescue StandardError => e
      SystemUtils.log_error_mesg( 'with ' + request.to_s + ' ' + command.to_s + @system_registry.last_error.to_s, command_hash)
      return SystemUtils.log_exception(e)
    end
    response_object = response_object.detached_subtree_copy if response_object.is_a?(Tree::TreeNode)      
    response_hash[:object] = response_object.to_yaml
    response_hash[:last_error] = @system_registry.last_error
    return response_hash
  end

  def is_command_hash_valid?(command_hash)
    return false if command_hash.nil?      
    return SystemUtils.log_error_mesg('Error_no command', command_hash) if !command_hash.key?(:command)
    return SystemUtils.log_error_mesg('nilcommand', command_hash) if command_hash[:command].nil?
    return true
  end

  def shutdown
    @system_registry.shutdown
  end
end
