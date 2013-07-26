# LAZER

[http://github.com/icambron/lazer](http://github.com/icambron/lazer)

## Summary

Lazer implements chainable, lazy enumeration methods in Ruby. For example, lazer's

```ruby
(1..200000)
  .map_lazy{|i| i * 2}
  .select_lazy{|i| i % 13}
  .first
```

does the same thing as Ruby's

```ruby
(1..200000)
  .map{|i| i * 2}
  .select{|i| i % 13}
  .first
```

but it does far less work to get there, only evaluating as much of the sequence as required to produce the answer:

```
-> % ruby benchmark/basic.rb
Nonlazy:   0.030000   0.000000   0.030000 (  0.037961)
Lazy:   0.000000   0.000000   0.000000 (  0.000051)
```

If you know [LINQ](http://msdn.microsoft.com/en-us/library/bb308959.aspx), you'll feel right at home.

## Installation

```
gem install lazer
```

Requires Ruby 1.9.1 or above.

## Usage

```ruby
require 'lazer'
```

Lazer implements lazy versions of many of the methods defined on [Enumerable](http://ruby-doc.org/ruby-1.9/classes/Enumerable.html). If we haven't implemented it, it's probably lazy to begin with. Instead of returning arrays, these methods return enumerators that wrap a thunk. So instead of actually enumerating the enumerable and doing real work, the method hands you an object that promises to do the work when you enumerate _it_.

You can chain the methods, just like you can chain the regular enumerable methods:

```ruby
(1..100)
  .map_lazy{|i| i + 3}
  .drop_while_lazy{|i| < 7}
  .take_lazy(5)
  .to_a
```

But instead of creating an array at each step, the lazy methods do nothing until an actual answer is asked of them (in this case, the `to_a` does that), and only examine the minimum number of items required to give that answer (in this case, 12).

The lazy operators are even useful on infinite sequences, such as `Lazer.natural_numbers`. For example, to find the first 7 numbers divisible by 6 and whose digits sum a multiple of 5:

```ruby
puts Lazer.naturals
  .select_lazy{|i| i % 6 == 0}
  .select_lazy{|i| i.to_s.split('').inject(0){|s, j| s + j.to_i} % 5 == 0}
  .take_lazy(7)
  .to_a
```

## Some notes

Laziness is an awesome tool, and it can be useful for dealing with slow or infinitely long pieces of data. There are also situations where laziness can turn your program into unperformant goo.

## License

(The MIT License)

Copyright (c) 2013:

Isaac Cambron
Jonathan Palmer

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
