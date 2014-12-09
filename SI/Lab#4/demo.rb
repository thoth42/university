require "benchmark"
require "digest"

def secure_compare(a, b)
  check = a.bytesize ^ b.bytesize
  a.bytes.zip(b.bytes) { |x, y| check |= x ^ y.to_i }
  check == 0
end

def compare(base_str)
  early_str = base_str.clone
  early_str[0] = 'z'

  late_str = base_str.clone
  late_str[late_str.length-1] = '!'

  Benchmark.bmbm do |b|
      b.report("==, early fail")  { 1000.times { base_str == early_str } }
      b.report("==, late fail") {1000.times { base_str == late_str } }
      puts ""
      b.report("Ruby secure_compare, 'early'") { 1000.times { secure_compare(base_str, early_str) } }
      b.report("Ruby secure_compare, 'late'") { 1000.times { secure_compare(base_str, late_str) } }
      puts ""
      b.report("SHA512-then-==, 'early'") { 1000.times { Digest::SHA512.digest(base_str) == Digest::SHA512.digest(early_str) } }
      b.report("SHA512-then-==, 'late'") { 1000.times { Digest::SHA512.digest(base_str) == Digest::SHA512.digest(late_str) } }
    end
end

puts ""
puts "==== Short text ===="
puts ""
compare 'TrurlAndKlapaucius'

puts ""
puts "==== Long text ===="
puts ""
compare 'TrurlAndKlapaucius'*1000
