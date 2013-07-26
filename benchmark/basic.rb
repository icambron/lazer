$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"

require 'benchmark'
require "lazer"

with = Benchmark.measure do
  (1..200000)
    .map_lazy{|i| i * 2}
    .select_lazy{|i| i % 13}
    .first
end

without = Benchmark.measure do
  (1..200000)
    .map{|i| i * 2}
    .select{|i| i % 13}
    .first
end

puts "Nonlazy: #{without}"
puts "Lazy: #{with}"

