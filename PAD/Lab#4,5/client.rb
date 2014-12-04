require 'socket'
require 'json'
require 'optparse'
require 'rainbow/ext/string'
require 'terminal-table'
require_relative 'http_handler'
require_relative 'data_manipulation'

class Client

  HOST = 'localhost'
  FILE_NAME = "client_data.json"

  attr_reader :http_client,  :options

  def initialize options
    @options = options
    @http_client = HttpHandler.new HOST, 8000
  end

  def run
    http_client.send_get_request options[:request], options[:type]
    show_data_results
  end

  private

  def show_data_results
    dt = DataManipulation.new(http_client.data)
    options[:request] =~ /\d+/ ? dt.show_entry : dt.show_all
  end

end

options = {}
OptionParser.new do |opts|
  opts.banner =  "Usage: ruby client.rb [options]\n\n"
  opts.on("-r", "--request [request]", "get request to main server") do |request|
    options[:request] = request || "/emploees"
  end

  opts.on("-t", "--type [TYPE]", "file name containing data") do |type|
    options[:type] = type || "json"
  end
end.parse!

Client.new(options).run
