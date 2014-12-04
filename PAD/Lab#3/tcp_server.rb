class TcpServer
  BLOCK_SIZE = 1024
  attr_reader :host, :port, :tcp_server, :data, :neighbors

  def initialize host, port, data, neighbors
    @host = host
    @port = port
    @data = data
    @neighbors = neighbors
    @tcp_server = TCPServer.open(host, port.to_i)
  end

  def listener
    loop do
      Thread.start(@tcp_server.accept) do |client|
        while true do
          request = client.gets.chomp
          send_all_data(client) if request == "*all*node*data*"
          send_node_data(client) if request == "*node*data*"
        end
      end
    end
  end

  private

  def send_all_data client
    puts "send all data"
    json_data = gather_data << get_node_data
    client.puts(format_data(json_data))
  end

  def send_node_data client
    puts "send node data"
    client.puts get_node_data << "**%"
  end

  def get_node_data
    data[port]["employers"].join(",")
  end

  def gather_data
    neighbors.map do |neighbour_port|
      socket = TCPSocket.open(host, neighbour_port)
      socket.puts "*node*data*"
      receive_neighbour_data socket
    end
  end

  def receive_neighbour_data tcp_socket
    line_regex = /.*\*\*%/
    data = ''
    while line = tcp_socket.recv(BLOCK_SIZE)
      data += (line =~ line_regex) ? line.split("**%").first : line
      # add break to the first if statement
      break if line =~ line_regex
    end
    data
  end

  def format_data data
    "[#{data.join(",").gsub("=>", ":")}]**%"
  end

end
