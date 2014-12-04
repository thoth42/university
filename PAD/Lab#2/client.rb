require 'socket'
require 'timeout'
require 'json'
require 'optparse'
require 'rainbow/ext/string'
require 'terminal-table'
require_relative 'udp_client'
require_relative 'tcp_client'
require_relative 'data_manipulation'

class Client

  HOST = 'localhost'
  WAIT_TIME = 3
  FILE_NAME = "client_data.json"

  attr_reader :data_man, :options, :udp_client

  def initialize options
    @options = options
    @udp_client = UdpClient.new(HOST)
  end

  def run
    udp_client.send_requests
    begin
      Timeout::timeout(WAIT_TIME) { udp_client.run }
    rescue Timeout::Error => e
      # abort with coupling
      abort("There are no available nodes") if udp_client.nodes.empty?
      p "Port with max connections is #{udp_client.max_port}"

      # save - read - show
      receive_data
      prepare_data
      show_data_results
    end
  end

  private

  def receive_data
    tcp_client = TcpClient.new(HOST, FILE_NAME, udp_client.max_port)
    tcp_client.run
  end

  def prepare_data
    data = read_json_file
    @data_man = DataManipulation.new(data, udp_client.average)
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
