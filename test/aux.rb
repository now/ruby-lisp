# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



$LOAD_PATH.unshift '../lib'

require 'test/unit'
require 'lisp/format'

class Test::Unit::TestCase
  def self.def_format_test(method, format, args, expected)
    define_method(method){ assert_equal(expected, format.format(*args)) }
  end
  
  def self.def_range_test(method, range, initial, format)
    define_method(method) do
      range.each{ |i| assert_equal(initial * i, format.format(i)) }
    end
  end

  def self.def_range_test2(method, range, initial, format)
    define_method(method) do
      range.each{ |i| assert_equal(initial * i, format.format(i).format) }
    end
  end

  def self.def_range_args_test(method, range, initial, format)
    define_method(method) do
      range.each{ |i| assert_equal(initial * i, format.format(*Array.new(i))) }
    end
  end

  def self.def_format_error_test(method, format, *args)
    define_method(method) do
      assert_raise(Lisp::Format::Error){ format.format(*args) }
    end
  end

  def coin
    rand(2) == 1
  end
end

StandardChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@\#$%^&*()_+|\\=-`{}[]:\";'<>?,./\n".unpack('C*')

MiniUniverse = [nil, true, :a, 0, -1, +1, 0.0, -1.0, +1.0, ?a, ?z, ?\n, ?\s, [], [1, 2, 3], {:a => 1, :b => 2, :c => 3}]
