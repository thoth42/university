# Reopen File Class
class File
  def each_chunk(chunk_size=MEGABYTE)
    yield read(chunk_size) until eof?
  end
end

class DupFile
  attr_reader :hash

  def initialize args
    @path = args[:path]
    @max_size = args[:max_size]
    @exclude = args[:exclude]
    @hash = {}

    calculate_size
  end

  def list_all_files
    hash.inject([]) do |res, (path, info)|
      res << "#{path} : [#{info[:size]} bytes]  [#{info[:hash]}]"
    end.join "\n"
  end

  def list_same_files
    same_files.inject([]) do |res, (hash, paths)|
      res << "#{hash}"
      paths.each {|path| res << path }
      res
    end.join "\n"
  end

  def same_files
    hash_contents.group_by{|_, info| info[:hash] }
            .each {|_, v| v.map! {|h| h.first } }
            .select {|_, v| v.size > 1 }
  end

  private

  def calculate_size
    Dir.glob("#{@path}/**/*")
          .reject { |file| File.directory? file }
          .reject { |file| unwanted_paterns(file) }
          .each  { |file| @hash[file] = {size: File.size?(file) } }
  end

  def filter_size
    hash.select {|key, value| value[:size] < @max_size }
  end

  def hash_contents
    filter_size.each { |path, info| @hash[path][:hash] = digest_file path }
  end

  def unwanted_paterns str
   @exclude.gsub("*", "\w*").split(" ").any? { |regx| str =~ /#{regx}/ }
  end

  def digest_file filename
    # Digest::SHA256.file(filename).hexdigest
    open(filename, "rb") do |f|
      sha256 = Digest::SHA256.new
      f.each_chunk() {|chunk|  sha256 << chunk }
      sha256.hexdigest
    end
  end

end