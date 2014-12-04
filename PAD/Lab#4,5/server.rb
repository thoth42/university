require 'socket'
require 'optparse'
require 'json'
require_relative 'http_handler'

class Server
  HOST = 'localhost'
  attr_reader :file_name, :file_content

  def initialize port, file_name
    @port = port
    @file_name = file_name
    @file_content =  File.read file_name
    @http_server = HttpHandler.new HOST, port
  end

  def run
    @http_server.send_put_request file_content, data_type
  end

  private

  def data_type
    File.extname(file_name).gsub(".", "")
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner =  "Usage: ruby server.rb [options]\n\n"
  opts.on("-p", "--port [PORT]", "provide port for server") do |p|
    options[:port] = p || "10000"
  end

  opts.on("-f", "--file [FILE]", "file name containing data") do |file|
    options[:file] = file || ""
  end
end.parse!

Server.new(options[:port], options[:file]).run
