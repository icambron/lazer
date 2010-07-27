module Enumerable

  def at_lazy(n)
    self.each_with_index do |val, index|
      return val if index == n
    end
    nil
  end

  def drop_lazy(n)
    Enumerator.new do |yielder|
      self.each_with_index do |val, index|
        yielder << val if index >= n
      end
    end
  end

  def drop_while_lazy(&block)
    Enumerator.new do |yielder|
      found = false
      self.each do |val|
        next if block.(val) && !found
        found = true
        yielder << val
      end
    end
  end

  def grep_lazy(pattern, &block)
    get_some do |yielder, val|
      if pattern === val
        yielder << (block_given? ? block.(val) : val)
      end
    end
  end

  def map_lazy(&block)
    get_some do |yielder, val|
      yielder << block.(val)
    end
  end
  alias collect_lazy map_lazy

  def reject_lazy(&block)
    self.select_lazy{|val| !block.(val)}
  end

  def select_lazy(&block)
    get_some do |yielder, val|
      yielder << val if block.(val)
    end
  end
  alias find_all_lazy select_lazy

  def take_lazy(n)
    Enumerator.new do |yielder|
      self.each_with_index do |val, index|
        yielder << val
        break if index == n-1
      end
    end
  end

  def take_while_lazy(&block)
    Enumerator.new do |yielder|
      self.each do |val|
        break unless block.(val)
        yielder << val
      end
    end
  end

  def flatten_lazy(&block)
    Enumerator.new do |yielder|
      self.each do |val|
        block.(val).each do |inner_val|
          yielder << inner_val
        end
      end
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
      self.each do |value|
        yield yielder, value
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
