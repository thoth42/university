class UdpClient

  LISTEN_PORT = 20001
  PORTS = [10000, 10001, 10002]
  attr_accessor :host, :nodes

  def initialize host
    @host = host
    @nodes = []
    # show host name as an ip numeric address
    BasicSocket.do_not_reverse_lookup = true
    # Create socket and bind to address
    @udp_server = UDPSocket.new
    @udp_server.setsockopt(Socket::SOL_SOCKET,Socket::SO_BROADCAST, true)
    @udp_server.bind(host, LISTEN_PORT)
  end

  def send_requests
    PORTS.each {|port| send_request port}
  end

  def run
    loop {  listener }
  end

  def max_port
    nodes.max_by { |info| info[:neighbours] }[:port]
  end

  def average
    sum = nodes.reduce(0) { |sum, node| sum += node[:average].to_i }
    sum / nodes.size
  end

  private

  def listener
    response, client = @udp_server.recvfrom(1024)
    Thread.new(client) do |clientAddress|
      neighbours, average = response.chomp.split(":")
      nodes << {port: clientAddress[1], neighbours: neighbours, average: average}
      show_node_info(nodes.last)
    end
  end

  def send_request port
    upd_socket = UDPSocket.new
    upd_socket.send("connections:#{LISTEN_PORT}", 0, host, port)
  end

  def show_node_info node
    str = "Received from port: #{node[:port]} "
    str << "which has #{node[:neighbours]} neighbours "
    str << "with an average of salary: #{node[:average]}"
    puts str
  end

end
