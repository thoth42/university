require 'socket'
require 'json'
require 'optparse'
require_relative 'http_handler'
require_relative 'tcp_server'

class Server
  HOST = 'localhost'
  DATA_FILE = './data.json'
  attr_reader :port, :data, :http_server, :tcp_server

  def initialize port
    @port = port
    prepare_data
    @http_server = HttpHandler.new HOST, port, neighbors, average
    @tcp_server  = TcpServer.new  HOST, port, data, neighbors
  end

  def run
    http_server.send_put_request
    tcp = Thread.new { tcp_server.listener }
    tcp.join
  end

  def prepare_data
    @data = JSON.parse File.read(DATA_FILE)
  end

  def neighbors
    data[port]["neighbors"]
  end

  def average
    employees = data[port]["employers"]
    sum = employees.reduce(0) { |sum, employer| sum += employer["salary"] }
    sum / employees.size
  end

end

options = {}
options[:port] = "10000"
OptionParser.new do |opts|
  opts.banner =  "Usage: ruby server.rb [options]\n\n"
  opts.on("-p", "--port [PORT]", "provide port for server") do |p|
    options[:port] = p || "10000"
  end
end.parse!

Server.new(options[:port]).run