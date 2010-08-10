module Lazer
  def Lazer.naturals
    Enumerator.new do |yielder|
      number = 1
      loop do
        yielder.yield number
        number += 1
      end
    end
  end
end
