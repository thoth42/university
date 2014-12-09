require_relative 'cypher'

class Frequency
  include Cypher

  def initialize cipher = ""
    @words = {}
    initiate_dictionary
  end

  def most_used_char
    @msch ||= cipher.scan(/\w/)
                              .inject(Hash.new(0)) { |h, c| h[c] += 1; h }
                              .max_by { |_,v| v }.first
  end

  def rot_num
    chars = ["z", "f", "e", "t", "a", "o", "i", "n"]

    char = chars.detect {|char| valid?(ord_num(char))}
    ord_num char
  end

  def valid? num
    rot(cipher, num).split.select{ |word| @words[word.downcase] }.count  > 1
  end

  def ord_num char
    most_used_char.ord - char.ord
  end

  def original
    rot cipher, rot_num
  end

end

p Frequency.new.original