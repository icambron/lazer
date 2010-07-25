require "test/unit"
require "lib/laze.rb"

class LazeTest < Test::Unit::TestCase

  def test_map
    assert (1..2).l_map{|a| a + 1}.is_array [2,3]
  end

  def test_map_is_lazy
    acc = []
    (1..2).l_map{|a| acc << a; a}.first
    assert_equal acc.count, 1
  end

end

class Enumerator
  def is_array(array)
    self.to_a == array
  end

  def index_is(index, value)
    self.l_at(index) == value
  end

end
