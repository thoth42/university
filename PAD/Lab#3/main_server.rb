require 'socket'
require 'json'
require 'thread'

class MainServer

  HOST = 'localhost'
  PORT = 8000
  attr_reader :server, :nodes

  def initialize
    @server = TCPServer.new HOST, PORT
    @semaphore = Mutex.new
    @nodes = []
  end

  def run
    loop do
     Thread.start(server.accept) do |client|
        request = client.gets

        if request =~ /^GET.*/
          send_get_response(client)
        else
         @semaphore.synchronize { @nodes << client.read }
        end
        client.close
     end
    end
  end

  def nodes
    @nodes.map { |request| parse(request) }
  end

  def send_get_response client
    response = JSON.generate max_node

    client.print "HTTP/1.1 200 OK\r\n" +
             "Content-Type: text/plain\r\n" +
             "Content-Length: #{response.bytesize}\r\n" +
             "Connection: close\r\n"

    client.print "\r\n"
    client.print response
    client.close
  end

  def max_node
    node = nodes.max_by{ |n| n[:neighbors].size }
    node.tap { |hash| hash.delete :neighbors }
  end

  def parse request
    res = {}
    info = request.match(/(\d*):(.*):(\d*)/)
    res[:port], res[:neighbors], res[:average] = info.captures
    res[:neighbors] = JSON.parse res[:neighbors]
    res
  end

end

MainServer.new.run
