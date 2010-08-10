module Enumerable
  def at_lazy(n)
    self.each_with_index do |val, index|
      return val if index == n
    end
    nil
  end

  def drop_lazy(n)
    get_some{|yielder, val, index| yielder << val if index >= n}
  end

  def drop_while_lazy(&block)
    found = false
    get_some do |yielder, val|
      next if block.(val) && !found
      found = true
      yielder << val
    end
  end

  def grep_lazy(pattern, &block)
    get_some {|yielder, val| yielder << (block_given? ? block.(val) : val) if pattern === val}
  end

  def flatten_lazy(&block)
    get_some do |yielder, val|
      block.(val).each do |inner_val|
        yielder << inner_val
      end
    end
  end

  def map_lazy(&block)
    get_some {|yielder, val| yielder << block.(val)}
  end

  alias collect_lazy map_lazy

  def reject_lazy(&block)
    self.select_lazy{|val| !block.(val)}
  end

  def select_lazy(&block)
    get_some {|yielder, val| yielder << val if block.(val)}
  end

  alias find_all_lazy select_lazy

  def slice_lazy(index, length=1)
    start, finish = index.begin, index.end if index.instance_of? Range
    start, finish = index, index + length - 1 if index.instance_of? Fixnum

    get_some do |yielder, val, index|
      next if index < start
      throw :done if index > finish
      yielder << val
    end
  end

  def take_lazy(n)
    get_some do |yielder, val, index|
      yielder << val
      throw :done if index == n-1
    end
  end

  def take_while_lazy(&block)
    get_some do |yielder, val|
      throw :done unless block.(val)
      yielder << val
    end
  end

  #this is disgusting, and the reason why Enumerator needs a has_next?
  def zip_lazy(*args, &block)
    rators = ([self] + args).map{|arr| arr.each}
    Enumerator.new do |yielder|
      loop do
        answer = rators.map do |rator|
          begin
            [rator.better_next, true]
          rescue StopIteration
            [nil, false]
          end
        end
        break if answer.none?{|val, signal| signal}
        output = answer.map{|val, signal| val}
        output = block.(output) if block_given?
        yielder << output
      end
    end
  end

  private

  def get_some
    Enumerator.new do |yielder|
      catch :done do
        self.each_with_index do |value, index|
          yield yielder, value, index
        end
      end
    end
  end
end

class Enumerator
  def better_next
    if @no_more
      raise StopIteration
    else
      begin
        self.next
      rescue StopIteration
        @no_more = true
        raise StopIteration
      end
    end
  end
end
