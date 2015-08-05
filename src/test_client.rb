require 'json'



def wait_for_reply(socket)
#  def process_messages(socket)
      
        # while socket.is_open? ==true 
      #blocking read
      #readup to first ,
      #get count
      #sub traact bytes already read and read until the rest.
      #save next segment if there is any (or stay sync)
    first_bytes = socket.gets
     end_tag_indx = first_bytes.index(',')
     mesg_lng_str = first_bytes.slice(0,end_tag_indx)
     mesg_len =  mesg_lng_str.to_i
     message_request = first_bytes.slice(end_tag_indx+1,-1) 
     
        
        while messege_response.size < mesg_len
         more = socket.gets
          messege_response = messege_response + more
        end 
       

      
  
       p :got 
       p messege_response
 
  return messege_response
  
end
def build_mesg(mesg_str)
     header = mesg_str.to_s.length
     return header.to_s + "," + mesg_str.to_s
   end
def send_request(command,params)
  request_hash = params.dup
  request_hash[:command] = command
   request_json = request_hash.to_json
  mesg_str = build_mesg(request_json)
  @registry_socket.puts(mesg_str)
  wait_for_reply(@registry_socket)
end



def open_socket(host,port)
   require 'socket.rb' 
  BasicSocket.do_not_reverse_lookup = true
    socket = TCPSocket.new(host,port)  
    
      return socket

end   

@registry_socket= open_socket("127.0.0.1",21027)

params=Hash.new

command="list_providers_in_use"
result = send_request(command,params)
p "list_providers_in_use"
p result.to_s

command="system_registry_tree"
result = send_request(command,params)
p "system_registry_tree"
p result.to_s

command="service_configurations_registry"
result = send_request(command,params)
p "service_configurations_registry"
p result.to_s

command="orphaned_services_registry"
result = send_request(command,params)
p "orphaned_services_registry"
p result.to_s

command="services_registry"
result = send_request(command,params)
p "services_registry"
p result.to_s

command="managed_engines_registry"
result = send_request(command,params)
p "managed_engines_registry"
p result.to_s

 