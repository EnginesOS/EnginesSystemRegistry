require_relative 'network_listener.rb'
require_relative 'protocol_listener.rb'

protocol_listener = ProtocolListener.new
network_listener = NetworkListener.new(protocol_listener, '0.0.0.0', 210_27)

Signal.trap('HUP', proc {
  protocol_listener.shutdown
  network_listener.shutdown
  exit
})

Signal.trap('TERM', proc {
  protocol_listener.shutdown
  network_listener.shutdown
  exit
})

network_listener.listen_for_messages
