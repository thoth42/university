class UdpServer
  BLOCK_SIZE = 1024

  attr_reader :host, :port, :neighbors, :udp_server, :average

  def initialize host, port, neighbors, average
    @host = host
    @port = port
    @average = average
    @neighbors = neighbors
    setup
  end

  def listener
    loop do
      request, client = @udp_server.recvfrom(BLOCK_SIZE)
      Thread.new(client) do |clientAddress|
        puts "Client #{clientAddress[1]} asked information."
        send_back request
      end
    end
  end

  private

  def setup
    # show host name as an ip numeric address
    BasicSocket.do_not_reverse_lookup = true
    # Create socket and bind to address
    @udp_server = UDPSocket.new
    udp_server.setsockopt(Socket::SOL_SOCKET,Socket::SO_BROADCAST, true)
    udp_server.bind(host, port.to_i)
  end

  def send_back request
    if request =~ /connections:(\d)+/
      data = "#{neighbors.size}:#{average}"
      client = get_client_port request
      udp_server.send(data, 0, host, client)
    end
  end

  def get_client_port request
    request.scan( /connections:(\d+)/).last.first.to_i
  end

end
