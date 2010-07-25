module Enumerable

  def l_at(n)
    self.each_with_index do |val, index|
      return val if index == n
    end
    nil
  end

  def l_cycle(n = nil)
    Enumerator.new do |yielder|
      so_far = 0
      while(n.nil? || n != so_far)
        self.each do |val|
          yielder << val
        end
        so_far += 1
      end
    end
  end

  def l_drop(n)
    Enumerator.new do |yielder|
      self.each_with_index do |val, index|
        yielder << val if index >= n
      end
    end
  end

  def l_drop_while(&block)
    Enumerator.new do |yielder|
      found = false
      self.each do |val|
        next if block.(val) && !found
        found = true
        yielder << val
      end
    end
  end

  def l_grep(pattern, &block)
    get_some do |yielder, val|
      if patter === val
        yeilder << block_given? ? block.(val) : val
      end
    end
  end

  def l_map(&block)
    get_some do |yielder, val|
      yielder << block.(val)
    end
  end
  alias l_collect l_map

  def l_reject(&block)
    self.l_select{|val| !block.(val)}
  end

  def l_select(&block)
    get_some do |yielder, val|
      yielder << val if block.(val)
    end
  end
  alias l_find_all l_select

  def l_take(n)
    Enumerator.new do |yielder|
      self.each_with_index do |val, index|
        break if index >= n
        yielder << val
      end
    end
  end

  def l_take_while(&block)
    Enumerator.new do |yielder|
      self.each do |val|
        break unless block.(val)
        yielder << val
      end
    end
  end

  #this is disgusting, and reason why Enumerator needs a has_next?
  def l_zip(*args, &block)
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
