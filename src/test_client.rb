require 'json'

def send_request(command,params)
  request_hash = params.dup
  request_hash[:command] = command
   request_json = request_hash.to_json
  @registry_socket.send(request_json,0,"127.0.0.1",21027)
end


def open_socket(host,port)
   require 'socket.rb' 
  BasicSocket.do_not_reverse_lookup = true
    socket = UDPSocket.new(Socket::AF_INET)
    if socket     
      socket.bind(host,port)           
      return socket
    end
end   

@registry_socket= open_socket("127.0.0.1",21028)

params=Hash.new


command="system_registry_tree"
result = send_request(command,params)
p "system_registry_tree"
p result

command="service_configurations_registry"
result = send_request(command,params)
p "service_configurations_registry"
p result

command="orphaned_services_registry"
result = send_request(command,params)
p "orphaned_services_registry"
p result

command="services_registry"
result = send_request(command,params)
p "services_registry"
p result

command="managed_engines_registry"
result=send_request(command,params)
p "managed_engines_registry"
p result

 