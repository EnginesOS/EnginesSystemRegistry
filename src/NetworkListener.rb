class NetworkListener
  
  def initialize(protocol_listener,ip,socket)
    @registry_listener_socket = open_socket(ip,socket)
    @protocol_listener = protocol_listener
  end
  
  def listen_for_messages
    while true 
    
      request , address = @registry_listener_socket.recvfrom()
        if check_request(request , address) == true
          result = @protocol_listener.perform_request
          if result.is_a(Hash)
            send_result
          else
            send_error
          end
        end
    end
  end
  
  def check_request_source_address(address)
    #Stub for ip ACL rules
    return true
  end
  
  def check_request(request_str,source_address)
    if check_request_source_address(source_address) == false     
      return false
    end
    if (request_str.to_hash)
    end
  end
  
  def convert_request_to_hash(request)
    require 'json'
   hash_request = JSON.parse(request)
    return symbolize_keys(hash_request)
  rescue 
      return nil
  end
  
  def symbolize_keys(hash)
      hash.inject({}){|result, (key, value)|
        new_key = case key
        when String then key.to_sym
        else key
        end
        new_value = case value
        when Hash then symbolize_keys(value)
        when Array   then
          newval=Array.new
          value.each do |array_val|
            if array_val.is_a?(Hash)
              array_val = symbolize_keys(array_val)
            end
            newval.push(array_val)
          end
          newval
        else value
        end
        result[new_key] = new_value
        result
      }
    end
  
  protected
  def open_socket(host,port)
    
    socket = UDPSocket.new(Socket::AF_INET)
    if socket     
      socket.bind(host,port)           
      return socket
    end
    
  end
  
end