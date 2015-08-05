

@registry_socket= open_socket("127.0.0.1",21028)

params=Hash.new


command="list"

send_request(command,params)


def send_request(command,params)
  request_hash = params.dup
  request_hash[:command] = command
   request_json
  @registry_socket.send(request_json,0,"127.0.0.1",21027)
end


def open_socket(host,port)
   require 'socket.rb' 
    socket = UDPSocket.new(Socket::AF_INET)
    if socket     
      socket.bind(host,port)           
      return socket
    end
end    