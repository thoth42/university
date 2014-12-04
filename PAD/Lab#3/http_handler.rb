class HttpHandler

  attr_accessor :host, :node, :tcp_socket, :port, :neighbors, :average

  def initialize host, port, neighbors=0, average=0
    @host = host
    @neighbors = neighbors
    @average = average
    @node = {}
    @port = port
    @tcp_socket = TCPSocket.new(host, 8000)
  end

  def send_get_request
    tcp_socket.puts "GET / HTTP/1.0\r\n\r\n"
    parse get_response
  end

  def send_put_request
    response = "#{port}:#{neighbors}:#{@average}"
    header = [ "PUT / HTTP/1.0",
               "HOST: #{host}",
               "Content-Type: text/plain",
               "Content-Length: #{response.bytesize}",
               "Connection: Keep-Alive" ].join "\r\n"

    tcp_socket.puts header + "\r\n\r\n" + response
    p "sent put request"
    tcp_socket.close
  end

  def max_port
    @node["port"]
  end

  def average
    @node["average"]
  end

  private

  def parse response
    @node = JSON.parse response
  end 

  def get_response
   response = tcp_socket.read 
   _,body = response.split(/\r\n\r\n/)
   tcp_socket.close
   body
  end

end
