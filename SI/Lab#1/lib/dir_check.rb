class DirCheck
  attr_reader :hash

  def initialize args
    @path = args[:path]
    @max_size = args[:max_size]
    @exclude = args[:exclude]
    @db = args[:db]
    @rows = @db.execute( "select * from hash_table" )
    @hash = {}
    @result ={created: [],  deleted: [], modified: [] }

    initiate_hash
  end

  # initiate hash form {path => size}
  def initiate_hash
    Dir.glob("#{@path}/**/*")
          .reject { |file| File.directory? file }
          .reject { |file| unwanted_paterns(file) }
          .each  { |file| @hash[file] = {size: File.size?(file) } }
  end

  def check_contents
    @rows.size > 1 ? search_change : fill_table
  end

  def show_result
    check_contents
    result = @result.inject([]) do |res, (status, paths)|
      paths.each { |path| res << "#{path} (#{status})" }
      res
    end.join "\n"
    refresh_table
    result
  end

  def refresh_table
    @db.execute('DELETE FROM hash_table')
    fill_table
  end

  def search_change
    check_new_files
    check_modified_files
  end

  def check_new_files
    current, old = @hash.keys, @rows.map(&:first)
    @result[:deleted] =  old - current
    @result[:created] = current - old
  end

  def check_modified_files
    @rows.each do |db_path, db_hash, db_size|
      if @hash.has_key?(db_path)
        @result[:modified] << db_path if digest_file(db_path) != db_hash
      end
    end
  end

  # generate new content table
  def fill_table
    hash_contents.each do |path, info|
      @db.execute("insert into hash_table values ( ?, ?,  ?)", [path, info[:hash], info[:size]])
    end
  end

  def filter_size
    hash.select {|key, value| value[:size] < @max_size }
  end

  # hash all files
  def hash_contents
    filter_size.each { |path, info|  @hash[path][:hash] = digest_file(path) }
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