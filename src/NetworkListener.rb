class NetworkListener
  
  def initialize(protocol_listener,ip,socket)
    @registry_listener = open_socket(ip,socket)
    @protocol_listener = protocol_listener
  end
  
  def listen_for_messages
    loop do
      client = @registry_listener.accept 
      thr = Thread.new {   process_messages(client) }
    end
  end
  
  def send_error(socket,request_hash,result)
    request_hash[:result] = "Error"
     request_hash[:error] = result
      send_result(socket,request_hash) 
  end
  def send_ok_result(socket,result)
    
    result[:result] = "OK"
    send_result(socket,result)
      
  end
  
  def process_messages(socket)
    while true 
      begin
   
      p "Connection on " + socket.to_s
       
      first_bytes = socket.read_nonblock(1500) 

      end_tag_indx = first_bytes.index(',')

      mesg_lng_str = first_bytes.slice(0,end_tag_indx)
      mesg_len =  mesg_lng_str.to_i

        p :first_bytes
        p first_bytes
        p first_bytes.size
        
      
      total_length = first_bytes.size
      end_byte =  total_length - end_tag_indx 

      message_request = first_bytes.slice(end_tag_indx+1,end_byte) 
      
      while message_request.size < mesg_len
        begin
       more = socket.read_nonblock(1500)
       p :more
       p more
       message_request = message_request +more
       if message_request.size == mesg_len
          break
       end
        rescue IO::EAGAINWaitReadable
          if message_request.size >= mesg_len
             break
          end
           p :EAGAINWaitReadable
                retry
          rescue Errno::EIO
            p :EIO
                 retry  
         rescue Errno::ECONNRESET
            return
         rescue Errno::EPIPE
            return 
         rescue EOFError
                   return  
        end
      end 

      request_hash = convert_request_to_hash(message_request)
    result = @protocol_listener.perform_request(request_hash)             
                 if result  != false
                   send_ok_result(socket,result)
                 else                
                   send_error(socket,request_hash,result)
                 end
        
      rescue Errno::ECONNRESET
        return
      rescue Errno::EPIPE
        return
      rescue EOFError
               return  
      rescue Errno::EIO
           retry
      rescue IO::EAGAINWaitReadable
        retry
    end
  end
end
  
  def send_result(socket,reply_hash)
    retry_count=0
    
    reply_json=reply_hash.to_json
    reply = build_mesg(reply_json)

    begin
     socket.write(reply)
    rescue  IO::EAGAINWaitWritable
      retry_count+=1
      retry
    rescue 
      return false
    end
    p "wrote " + reply.length.to_s + " " + reply_hash.to_s
    
    return true  
  end
  
  def build_mesg(mesg_str)
    header = mesg_str.to_s.length
    return header.to_s + "," + mesg_str.to_s
  end
  
  def check_request_source_address(address)
    #Stub for ip ACL rules
    return true
  end
  
  def check_request(request_str,source_address)
    if check_request_source_address(source_address) == false     
      return false
    end
   return true
  end
  
  def convert_request_to_hash(request)
    require 'YAML'
   hash_request = YAML::load(request)
    return symbolize_top_level_keys(hash_request)
  rescue 
      return nil
  end
 
  def symbolize_top_level_keys(hash)
      hash.inject({}){|result, (key, value)|
        new_key = case key
        when String then key.to_sym
        else key
        end
 #       new_value = case value
#        when Hash then symbolize_keys(value)
#        when Array   then
#          newval=Array.new
#          value.each do |array_val|
#            if array_val.is_a?(Hash)
#              array_val = symbolize_keys(array_val)
#            end
#            newval.push(array_val)
#          end
#          newval
#        else value
#        end
        
        result[new_key] = value
        result
      }
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
    
    require 'socket'
    BasicSocket.do_not_reverse_lookup = true
    server = TCPServer.new(host,port)
    return server
   
    
  end
  
end