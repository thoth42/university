class TcpClient

  attr_reader :tcp_socket, :file_name

  def initialize host, file_name, port
    @tcp_socket = TCPSocket.open(host, port)
    @file_name = file_name
  end

  def run
    request_node_data
    save_data(receive_node_data)
  end

  private

  def request_node_data
    tcp_socket.puts "*all*node*data*"
  end

  def receive_node_data
    data = ''
    while line = @tcp_socket.recv(1024)
      if line =~ /.*\*\*%/
        data += line.split("**%").first
        break
      else
        data += line
      end
    end
    data
  end

  def save_data data
    begin
      fullpath = File.expand_path(file_name)
      file = File.open(fullpath, "w+")
      file.write data
      puts "Data saved"
    rescue  => e
      puts e.message
      puts "Could not open file"
    rescue IOError => e
      puts "Could not write to file"
    ensure
      file.close unless file.nil?
    end
  end

end
