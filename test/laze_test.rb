$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"

require "test/unit"
require "laze"

class LazeTest < Test::Unit::TestCase

  def test_at
    assert_equal 17, Laze.naturals.at_lazy(16)
  end

  def test_drop
    assert_equal 4, Laze.naturals.drop_lazy(3).first
  end

  def test_drop_while
    assert_equal 5, Laze.naturals.drop_while_lazy{|i| i < 5}.first
  end

  def test_grep
    assert_equal 'h', ('a'..'z').cycle.grep_lazy(/h/).first
    assert_equal 'hello', ('a'..'z').cycle.grep_lazy(/h/){|a| a + 'ello'}.first
  end

  def test_map
    assert_equal 2, Laze.naturals.map_lazy{|a| a + 1}.first
  end

  def test_reject
    assert_equal 7, Laze.naturals.reject_lazy{|i| i % 2 == 0}.at_lazy(3)
  end

  def test_select
    assert_equal 8, Laze.naturals.select_lazy{|i| i % 2 == 0}.at_lazy(3)
  end

  def test_slice
    assert_equal 7, Laze.naturals.slice_lazy(6).first
    assert_equal [7, 8, 9], Laze.naturals.slice_lazy(6, 3).to_a
    assert_equal [7, 8, 9], Laze.naturals.slice_lazy(6..8).to_a
  end

  def test_take
    assert_equal [1, 2], Laze.naturals.take_lazy(2).to_a
    assert_equal 1, angry_enumerator(1).take_lazy(2).first
  end

  def test_take_while
    assert_equal [1, 2, 3], Laze.naturals.take_while_lazy{|a| a < 4}.to_a
    assert_equal 1, angry_enumerator(3).take_while_lazy{|a| a < 4}.first
  end

  # test that we're lazy not only on the outer enumerator but also if the block makes use of lazy enumerators
  def test_flatten
    assert_equal ['11','21','22','31','32','33', '41'], Laze.naturals.flatten_lazy{|n| Laze.naturals.map_lazy{|m| "#{n}#{m}"}.take(n)}.take(7)
  end

  def test_zip_lazy
    assert_equal [1, 1], Laze.naturals.zip_lazy(1..2).first
    assert_equal [3, nil], Laze.naturals.zip_lazy(1..2).at_lazy(2)
  end

  #same as natural_numbers, but gets very upset if you evaluate more of him than you actually need to
  def angry_enumerator(length = null)
    Enumerator.new do |yielder|
      number = 1
      loop do
        raise "Not that lazy!" if number > length
        yielder.yield number
        number += 1
      end
    end
  end

end
