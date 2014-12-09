require_relative 'cypher'

class Main
  include Cypher

  def initialize cipher = ""
    @words = {}
    initiate_dictionary
  end

  def check_rot
    (0..26).map do |num|
      cipher.split.select{ |word| @words[rot(word, num).downcase] }.count
    end
  end

  def rot_num
    26 - check_rot.each_with_index.max[1]
  end

  def show_original
    rot cipher, rot_num
  end

end

p Main.new.show_original
