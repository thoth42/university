module Cypher

  def cipher
    str = ""
    File.open("data.txt", "r") do |f|
      f.each_line { |line| str << line }
    end
    rot(str, 13)
  end

  def rot string, num
    origin = "a-zA-Z"
    cipher = [('a'..'z'), ('A'..'Z')].map {|range| range.to_a.rotate(num).join }.join
    string.tr origin, cipher
  end

  def initiate_dictionary
    # dictionary.txt
    File.open("./dictionary.txt") do |file|
      file.each { |line| @words[line.strip] = true }
    end
  end

end