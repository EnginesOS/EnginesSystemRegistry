require 'yaml'
require 'timeout'
require 'thread'
class NetworkListener
  
  def initialize(protocol_listener,ip,socket)
    @registry_listener = open_socket(ip,socket)
    @protocol_listener = protocol_listener
    @registry_lock  = Mutex.new()
  end
  
  #Fix me need to limit connections close thread etc
  def listen_for_messages
    loop do
      client = @registry_listener.accept       
      log_connection(client)
      thr = Thread.new {   process_messages(client) }
    end
  end
  
  def log_connection(client)
           client_ipdetails = client.peeraddr(true,:numeric)
           p "Connection on " + client_ipdetails[2].to_s + ":" + client_ipdetails[1].to_s
   end
   
  def send_error(socket,request_hash,result)
    p :errio
    request_hash[:result] = "Error"
    request_hash[:error] = result
    send_result(socket,request_hash) 
  end
  
  def send_ok_result(socket,result)    
    p :ok
    result[:result] = "OK"
    send_result(socket,result)      
  end
  
  def process_first_chunk(mesg_data)
    p :deheaded_chunk
    deheaded_chunk = Array.new
    total_length = mesg_data.size
    end_tag_indx = mesg_data.index(',')
    mesg_lng_str = mesg_data.slice(0,end_tag_indx)
    mesg_len =  mesg_lng_str.to_i
    end_byte =  total_length - end_tag_indx
    message_request = mesg_data.slice(end_tag_indx+1,end_byte+1)
    deheaded_chunk[0]=message_request
    deheaded_chunk[1]=mesg_len
   
    p deheaded_chunk.to_s
    return deheaded_chunk
  end
  
  def process_messages(socket)
    
    session_timer_thread=1
    while true 
      begin   
          message_request= String.new
          first_bytes=true
          
        mesg_len = 1 #will set on first pass
      while message_request.size < mesg_len
        begin
          p :getting_mesg_data
          mesg_data = socket.read_nonblock(1500)
          p mesg_data
        if first_bytes == true
         # session_timer_thread = Thread.new {sleep 5}
          first_bytes = false
          deheaded_chunk = process_first_chunk(mesg_data)
          message_request = deheaded_chunk[0]
           mesg_len   = deheaded_chunk[1]
          p "got " + message_request + " in " + mesg_len + " bytes" 
        else
          message_request = message_request + mesg_data
#           if session_timer_thread.is_running == false
#             p :Timeout
#           end
        end
        
       if message_request.size == mesg_len
        
          break
       end
       
        rescue IO::EAGAINWaitReadable
          if message_request.size >= mesg_len
             break
          end
                retry
          rescue Errno::EIO
            p :EIO
          return  
         rescue Errno::ECONNRESET
            return
         rescue Errno::EPIPE
           p :EPIPE
            return 
         rescue EOFError
          #End of Message
                return  
        end
      end 

      request_hash = convert_request_to_hash(message_request)

      @registry_lock.synchronize   {
    result = @protocol_listener.perform_request(request_hash)                 
                 if result  != false
                   send_ok_result(socket,result)
                 else                
                   send_error(socket,request_hash,result)
                 end
      }      
    end
  end
end
  
  def send_result(socket,reply_hash)
    retry_count=0
    reply_yaml=reply_hash.to_yaml
    reply = build_mesg(reply_yaml)
   begin
      status = Timeout::timeout(15) {
        bytes =  socket.send(reply,0)
       
      }
     # socket.recv(0) #check it's open anc hcuck wobbly if not
    rescue  IO::EAGAINWaitWritable
      retry_count+=1
      retry
      rescue  Timeout::Error 
         @last_error="Timeout sending reply"
         return false
    rescue Exception=>e
      p  e.to_s
      p e.backtrace.to_s
      return false
  end
     
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
   hash_request = YAML::load(request)
    return hash_request # symbolize_top_level_keys(hash_request)

  end
 
  def symbolize_top_level_keys(hash)
      hash.inject({}){|result, (key, value)|
        new_key = case key
        when String then key.to_sym
          else key
        end
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