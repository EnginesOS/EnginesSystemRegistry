require 'yaml'
class NetworkListener
  
  def initialize(protocol_listener,ip,socket)
    @registry_listener = open_socket(ip,socket)
    @protocol_listener = protocol_listener
  end
  
  def listen_for_messages
    loop do
      client = @registry_listener.accept 
      process_messages(client)  #thr = Thread.new {   process_messages(client) }
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
      
#      first_bytes = socket.read_nonblock(1500) 
#
#      end_tag_indx = first_bytes.index(',')
#
#      mesg_lng_str = first_bytes.slice(0,end_tag_indx)
#      mesg_len =  mesg_lng_str.to_i
#
#
#      
#      total_length = first_bytes.size
#      end_byte =  total_length - end_tag_indx 
#
#        p :first_bytes
#        p first_bytes
#        p :first_bytes_l
#        p first_bytes.size
#        p :end_byte
#        p end_byte
#        p :end_tag_indx
#        p end_tag_indx
#        p :mesg_len
#        p mesg_len
#        
#      message_request = first_bytes.slice(end_tag_indx+1,end_byte+1) 
#      p message_request
#      p :message_request_l
#        p message_request.size.to_s
          message_request= String.new
          first_bytes=nil
        mesg_len = 1 #will set on first pass
      while message_request.size < mesg_len
        begin
          p :getting_more
       more = socket.read_nonblock(1500)
       
        if first_bytes == nil
          first_bytes = more
          end_tag_indx = first_bytes.index(',')
          mesg_lng_str = first_bytes.slice(0,end_tag_indx)
          mesg_len =  mesg_lng_str.to_i
          end_byte =  total_length - end_tag_indx
          message_request = first_bytes.slice(end_tag_indx+1,end_byte+1)
        else
          message_request = message_request +more
        end
        
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
           p :EPIPE
            return 
         rescue EOFError
           p :EOFError
                   return  
        end
      end 
      p :convert
      request_hash = convert_request_to_hash(message_request)
      p :request_hash
      p request_hash
    result = @protocol_listener.perform_request(request_hash)             
                 if result  != false
                   send_ok_result(socket,result)
                 else                
                   send_error(socket,request_hash,result)
                 end
    end
  end
end
  
  def send_result(socket,reply_hash)
    retry_count=0
    p :sending
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
   
    p :yamilificat
   hash_request = YAML::load(request)
    return hash_request # symbolize_top_level_keys(hash_request)
#  rescue 
#      return nil
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