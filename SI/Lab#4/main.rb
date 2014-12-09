require 'benchmark'
require 'digest'

def str n
  str = "TrurlAndKlapaucius"
  str = str[0...(str.size-n)]
  str << (0...n).map { ('a'..'z').to_a[rand(26)] }.join
end

def string_comparision str1, str2
  str1 == str2
end

def string_comparision_cbc str1, str2
  str1.chars.all? { |c| c == str2[str1.index(c)] }
end

def constant_time_comp a, b
  check = a.bytesize ^ b.bytesize
  a.bytes.zip(b.bytes) { |x, y| check |= x ^ y.to_i }
  check == 0
end

def are_equal?(str1, str2)
# not valid if lengths are different
  return false unless str1.length == str2.length
  
  # check each character
  result = 0
  str1.bytes.zip(str2.bytes) { |x, y| result |= x ^ y.to_i }

  # check equal
  return result == 0
end

Benchmark.bm do |x|
  x.report("first") { 1000.times { |_| are_equal?(str(0), str(1)) } }
  x.report("second") { 1000.times { |_| are_equal?(str(0), str(1)) } }
end

