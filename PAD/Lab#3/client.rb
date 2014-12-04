require 'socket'
require 'json'
require 'optparse'
require 'rainbow/ext/string'
require 'terminal-table'
require_relative 'http_handler'
require_relative 'tcp_client'
require_relative 'data_manipulation'

#dieharder random urandom

class Client

  HOST = 'localhost'
  FILE_NAME = "client_data.json"

  attr_reader :data_man, :options, :http_client

  def initialize options
    @options = options
    @http_client = HttpHandler.new HOST, 8000
  end

  def run
    http_client.send_get_request
    # abort("There are no available nodes") if http_client.node.empty?
    # p "Port with max connections is #{http_client.max_port}"

    # save - read - show
    receive_data
    prepare_data
    show_data_results
  end

  private

  def receive_data
    tcp_client = TcpClient.new(HOST, FILE_NAME, http_client.max_port)
    tcp_client.run
  end

  def prepare_data
    data = read_json_file
    @data_man = DataManipulation.new(data, http_client.average)
  end

  def show_data_results
    case options[:show]
    when "default"   then data_man.show_all
    when "filtered"   then data_man.show_filtered
    else
      puts "Invalid option"
    end
  end

  def read_json_file
    JSON.parse File.read(FILE_NAME)
  end

end

# input arguments from terminal
options = {}
options[:show] = "default"
OptionParser.new do |opts|
  opts.banner =  "Usage: ruby client.rb [options]\n\n"
  opts.on("-s", "--show [SHOW]", "show data by method") do |s|
    options[:show] = s || "default"
  end
end.parse!

Client.new(options).run
