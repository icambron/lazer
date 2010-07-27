require "test/unit"
require "lib/laze.rb"

class LazeTest < Test::Unit::TestCase

  def test_map
    assert_equal (1..2).map_lazy{|a| a + 1}.to_a, [2,3]
  end

  def test_map_is_lazy
    acc = []
    (1..2).map_lazy{|a| acc << a; a}.first
    assert_equal acc.count, 1
  end

  def test_lazy_map_chaining
    acc = []
    (1..20).map_lazy{|a| a + 1; acc << a}.map_lazy{|b| b*2}.first
    assert_equal acc.count, 1
  end

end
