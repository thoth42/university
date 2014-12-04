require 'active_support/core_ext/hash'

class HttpHandler

  attr_accessor :host, :data, :tcp_socket, :port

  def initialize host, port
    @host = host
    @port = port
    @tcp_socket = TCPSocket.new(host, 8000)
  end

  def send_get_request request, type
   header =["GET #{request} HTTP/1.0",
        "Accept-Type: application/#{type}"].join("\r\n")

    tcp_socket.puts header + "\r\n\r\n"    
    type == 'json' ? parse_json(get_response) : parse_xml(get_response)
  end

  def send_put_request data, type
    header =["PUT /employees HTTP/1.0",
             "HOST: #{host}",
             "Content-Type: application/#{type}",
             "Content-Length: #{data.bytesize}",
             "Connection: close"].join("\r\n")

    tcp_socket.puts header + "\r\n\r\n" + data
    p "send put request"
    tcp_socket.close
  end

  private

  def parse_json response
    p "Received json"
    @data = JSON.parse response
  end
  
  def parse_xml response
    p "Received xml"
    @data = JSON.parse(Hash.from_xml(response).to_json)
  end

  def get_response
    request = tcp_socket.read
    _, body = request.split("\r\n\r\n")
    tcp_socket.close
    body
  end

end
