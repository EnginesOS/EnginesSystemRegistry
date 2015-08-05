
require_relative "NetworkListener.rb"
require_relative "ProtocolListener.rb"

protocol_listener = ProtocolListener.new()
network_listener = NetworkListener.new(protocol_listener,"127.0.0.1",21027)
network_listener.listen_for_messages