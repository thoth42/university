require 'active_support/core_ext/hash'
require 'socket'
require 'json'
require 'thread'
require 'digest'
require 'nokogiri'

class MainServer

  HOST = 'localhost'
  HASH_FILE= 'hash.json'
  DATABASE = 'database.json'
  PORT = 8000
  attr_reader :server, :hash, :xml_schema, :http_header

  def initialize
    @hash = JSON.parse(File.read(HASH_FILE)) rescue []
    @server = TCPServer.new HOST, PORT
    @semaphore = Mutex.new
    @xml_schema = Nokogiri::XML::Schema(File.read("dataSchema.xsd"))
  end

  def run
    loop do
     Thread.start(server.accept) do |client|
        @semaphore.synchronize do
          @http_header = client.gets("\r\n\r\n")
          http_header =~ /^GET.*/ ? send_response(client) : add_to_database(client.read)
          client.close
        end
      end
    end
  end

  def send_response client
    @url , _, type = parse_request(http_header)
    type == 'json' ? send_get_response(client, json_response) : send_get_response(client, xml_response)
  end

  # GET request 

  def json_response
    JSON.generate response
  end

  def xml_response
    response.to_xml(:root => 'employees')
  end

  # needs refactor, bad implementation
  def response
    id = @url.scan(/\d+/)
    id.empty? ? current_employees : employer(id)
  end

  def employer id
    if current_employees.size < id.first.to_i-1
      {"problem" => "There is no such id" } 
    else
      current_employees[id.first.to_i-1]
    end
  end

  def send_get_response client, response
     client.print "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/plain\r\n" +
            "Content-Length: #{response.bytesize}\r\n" +
            "Connection: close\r\n"

    client.print "\r\n"
    client.print response
    client.close
  end

  def parse_request request
     request.scan(/\/([^\s]*)/).flatten
  end

  # PUT request

  def add_to_database http_body
    _, _, type = parse_request http_header
    json = http_body

    if type == "xml"
      errors = xml_schema.validate(Nokogiri::XML(http_body))
      if errors.empty? #valid xml
        json = xml_to_json(http_body)
      else #invalid xml
        puts "ERROR: invalid xml"
        return
      end
    end

    save(json) unless check_uniq?(json)
  end

  def xml_to_json xml_data
    json = JSON.parse(Hash.from_xml(xml_data).to_json)
    #fix xml to json incompatibility
    json["employees"] = json["employees"]["employee"]
    json["employees"].each { |e| e["salary"] = e["salary"].to_i }
    #convert from hash to json format
    json.to_json
  end

  private

  def check_uniq? body
    hash.include? generate_hash(body)
  end

  def save body
    File.write(DATABASE, JSON.pretty_generate(current_employees + (JSON.parse(body)["employees"] - current_employees)))
    add_hash body
  end

  def current_employees
    file = File.exist?(DATABASE) ? File.read(DATABASE) : ""
    file.empty? ? [] : JSON.parse(file)
  end

  def generate_hash message
    Digest::SHA256.new.hexdigest(message).to_s
  end

  def add_hash body
    File.open(HASH_FILE, 'w+') { |file| file.write @hash << generate_hash(body) }
  end

end

MainServer.new.run
